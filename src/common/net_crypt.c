#include "net_crypt.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "md5calc.h"

static char enckey[] = "Urk#nI7ni";

char *generate_hashvalues(const char *name, char *outbuffer, int buflen) {
  struct cvs_MD5Context context;
  unsigned char checksum[16];
  int i;

  if (buflen < 33) {
    return 0;
  }

  cvs_MD5Init(&context);
  cvs_MD5Update(&context, name, strlen(name));
  cvs_MD5Final(checksum, &context);

  for (i = 0; i < 16; i++) {
    sprintf(&outbuffer[i * 2], "%02x", (unsigned int)checksum[i]);
  }

  outbuffer[32] = 0;
  return outbuffer;
}

char *populate_table(const char *name, char *table, int tablelen) {
  char hash[64];
  int i;

  if (tablelen < 0x401) {
    return 0;
  }

  if (!generate_hashvalues(name, &hash[0], sizeof(hash))) {
    return 0;
  }

  table[0] = 0;
  sprintf(&table[0], "%s", &hash[0]);
  generate_hashvalues(&table[0], &hash[0], sizeof(hash));
  table[0] = 0;
  sprintf(&table[0], "%s", &hash[0]);

  for (i = 0; i < 32; i++) {
    generate_hashvalues(&table[0], &hash[0], sizeof(hash));
    sprintf(&table[0], "%s%s", &table[0], &hash[0]);
  }

  return &table[0];
}

#ifdef USE_RANDOM_INDEXES
#define rnd() (rand())
#else
#define rnd() (0x1337)
#endif

int set_packet_indexes(unsigned char *packet) {
  unsigned char k1 = ((rnd() & 0x7FFF) % 0x9B + 0x64) ^ 0x21;
  unsigned short k2 = ((rnd() & 0x7FFF) + 0x100) ^ 0x7424;
  unsigned short psize = (unsigned short)(packet[1] << 8) + (packet[2] & 0xFF);

  psize += 3;
  packet[psize] = (unsigned char)k2 & 0xFF;
  packet[psize + 1] = k1;
  packet[psize + 2] = (unsigned char)(k2 >> 8) & 0xFF;
  packet[1] = (unsigned char)(psize >> 8) & 0xFF;
  packet[2] = (unsigned char)psize & 0xFF;

  return psize + 3;
}
#undef rnd

char *generate_key2(unsigned char *packet, char *table, char *keyout,
                    int fromclient) {
  unsigned short psize = (unsigned short)(packet[1] << 8) + (packet[2] & 0xFF);
  unsigned int k1 = packet[psize + 1];
  unsigned int k2 =
      (unsigned int)(packet[psize + 2] << 8) + (packet[psize] & 0xFF);
  int i;

  if (fromclient) {
    k1 ^= 0x25;
    k2 ^= 0x2361;
  } else {
    k1 ^= 0x21;
    k2 ^= 0x7424;
  }

  k1 *= k1;

  for (i = 0; i < 9; i++) {
    keyout[i] = table[(k1 * i + k2) & 0x3FF];
    k1 += 3;
  }
  keyout[9] = 0;

  return keyout;
}

void tk_crypt_static(char *buff) { tk_crypt_dynamic(buff, enckey); }

void tk_crypt_dynamic(char *buff, char *key) {
  unsigned int Group = 0;
  unsigned int GroupCount = 0;
  unsigned int packet_len = 0;
  unsigned char packet_inc = 0;
  unsigned char KeyVal = 0;
  buff++;
  packet_len = SWAP16(*(unsigned short *)buff) - 5;
  buff += 3;
  packet_inc = *buff;
  buff++;

  // buff now points to the first data byte
  if (packet_len > 65535) {
    return;
  }

  for (int i = 0; i < packet_len; i++) {
    *(buff + i) ^= key[i % 9];

    KeyVal = (unsigned char)(Group % 256);
    if (KeyVal != packet_inc) {
      *(buff + i) ^= KeyVal;
    }

    *(buff + i) ^= packet_inc;

    GroupCount++;
    if (GroupCount == 9) {
      Group++;
      GroupCount = 0;
    }
  }
}
