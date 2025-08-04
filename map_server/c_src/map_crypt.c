#include <arpa/inet.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mmo.h"
#include "map_server.h"
#include "net_crypt.h"
#include "session.h"

// Map-specific encryption functions
int tk_encrypt(int fd) {
  USER *sd = NULL;
  char key[16];
  sd = session[fd]->session_data;

  if (sd == NULL) return 1;

  set_packet_indexes((unsigned char *)WFIFOP(fd, 0));

  if (is_key_server(WFIFOB(fd, 3))) {
    generate_key2((unsigned char *)WFIFOP(fd, 0), sd->EncHash, key, 0);
    tk_crypt_dynamic((unsigned char *)WFIFOP(fd, 0), key);
  } else {
    tk_crypt_static((unsigned char *)WFIFOP(fd, 0));
  }
  return (int)SWAP16(*(unsigned short *)WFIFOP(fd, 1)) + 3;
}

int tk_decrypt(int fd) {
  USER *sd = NULL;
  char key[16];
  sd = (USER *)session[fd]->session_data;

  if (sd == NULL) return 1;

  if (is_key_client(RFIFOB(fd, 3))) {
    generate_key2((unsigned char *)RFIFOP(fd, 0), sd->EncHash, key, 1);
    tk_crypt_dynamic((unsigned char *)RFIFOP(fd, 0), key);
  } else {
    tk_crypt_static((unsigned char *)RFIFOP(fd, 0));
  }
  return 0;
}