# Yuri Server Protocol Structure Definitions

This document provides complete C struct definitions for all packet types in the Yuri MMORPG server protocol.

## Base Packet Structure

```c
// All packets start with this header
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA - packet delimiter
    uint16_t length;     // Total packet length - 3 (SWAP16 applied)
    uint8_t  opcode;     // Packet type identifier
    uint8_t  data[];     // Variable-length payload
} base_packet_t;
```

## Server-to-Client Packet Structures

### Map Server Packets

#### 0x02 - Message Packet
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x02
    uint8_t  subtype;    // 0x02
    uint8_t  code;       // Message code
    uint8_t  msg_len;    // Message string length
    char     message[];  // Message text
    uint16_t padding;    // 0x0000
} s2c_message_t;
```

#### 0x03 - Server Transfer
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x03
    uint32_t server_ip;  // SWAP32(ip address)
    uint16_t port;       // SWAP16(port)
    uint8_t  type;       // 0x16 for map transfer
    uint16_t key_len;    // SWAP16(9) - xor key length
    char     xor_key[9]; // Encryption key
    uint8_t  name_len;   // Username length
    char     username[]; // Username
} s2c_transfer_t;
```

#### 0x04 - Position Update
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x0D)
    uint8_t  opcode;     // 0x04
    uint16_t x;          // SWAP16(x coordinate)
    uint16_t y;          // SWAP16(y coordinate)
    uint16_t view_x;     // SWAP16(viewport x)
    uint16_t view_y;     // SWAP16(viewport y)
} s2c_position_t;
```

#### 0x05 - Send Player ID
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x0E)
    uint8_t  opcode;     // 0x05
    uint32_t player_id;  // SWAP32(player ID)
    uint16_t unknown1;   // 0x0000
    uint8_t  unknown2;   // 0x00
    uint8_t  unknown3;   // 0x02
    uint8_t  unknown4;   // 0x03
    uint16_t unknown5;   // SWAP16(0)
} s2c_player_id_t;
```

#### 0x06 - Map Data
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x06
    uint8_t  subtype;    // 0x03
    uint8_t  flags;      // 0x00
    uint16_t x0;         // SWAP16(start x)
    uint16_t y0;         // SWAP16(start y)
    uint8_t  width;      // Map width
    uint8_t  height;     // Map height
    struct {
        uint16_t tile;   // SWAP16(tile ID)
        uint16_t pass;   // SWAP16(passability)
        uint16_t obj;    // SWAP16(object ID)
    } tiles[];           // width * height tiles
} s2c_map_data_t;
```

#### 0x07 - Object Look
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x07
    uint16_t count;      // SWAP16(object count)
    uint16_t x;          // SWAP16(x coordinate)
    uint16_t y;          // SWAP16(y coordinate)
    uint32_t object_id;  // SWAP32(object ID)
    // Object-specific data follows (variable by type)
} s2c_object_look_t;
```

#### 0x0A - Popup/Broadcast Message
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x0A
    uint8_t  type;       // 0x03
    uint8_t  subtype;    // 0x05 for broadcast, 0x08 for popup
    uint16_t msg_len;    // SWAP16(message length)
    char     message[];  // Message text
} s2c_broadcast_t;
```

#### 0x0C - NPC Spawn
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x0C)
    uint8_t  opcode;     // 0x0C
    uint32_t npc_id;     // SWAP32(NPC ID)
    uint16_t x;          // SWAP16(x coordinate)
    uint16_t y;          // SWAP16(y coordinate)
    uint8_t  direction;  // Facing direction
    uint8_t  unknown;    // 0x00
} s2c_npc_spawn_t;
```

#### 0x0E - Destroy Object (Type 1)
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(6)
    uint8_t  opcode;     // 0x0E
    uint8_t  subtype;    // 0x03
    uint32_t object_id;  // SWAP32(object ID)
} s2c_destroy_t;
```

#### 0x0F - Item Display
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x0F
    uint8_t  slot;       // Inventory slot
    uint32_t item_id;    // SWAP32(item ID)
    uint8_t  color;      // Item color
    uint8_t  name_len;   // Item name length
    char     name[];     // Item name
    uint32_t quantity;   // SWAP32(quantity)
    uint8_t  durability; // Current durability
    uint8_t  max_dur;    // Maximum durability
} s2c_item_display_t;
```

#### 0x10 - Floor Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x10
    uint16_t x;          // SWAP16(x coordinate)
    uint16_t y;          // SWAP16(y coordinate)
    uint32_t item_id;    // SWAP32(item ID)
    uint8_t  color;      // Item color
    uint8_t  name_len;   // Item name length
    char     name[];     // Item name
} s2c_floor_item_t;
```

#### 0x11 - Send Side/Direction
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x08)
    uint8_t  opcode;     // 0x11
    uint32_t entity_id;  // SWAP32(entity ID)
    uint8_t  direction;  // 0=North, 1=East, 2=South, 3=West
} s2c_direction_t;
```

#### 0x12 - Guide/Tutorial
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x07)
    uint8_t  opcode;     // 0x12
    uint8_t  type;       // 0x03
    uint8_t  unknown1;   // 0x00
    uint8_t  unknown2;   // 0x02
    uint16_t guide_id;   // Guide ID
    uint8_t  unknown3;   // 0x00
    uint8_t  show;       // 0x01 to show
} s2c_guide_t;
```

#### 0x13 - Health Bar Update
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(12)
    uint8_t  opcode;     // 0x13
    uint32_t entity_id;  // SWAP32(entity ID)
    uint8_t  critical;   // Critical hit flag
    uint8_t  percentage; // Health percentage (0-100)
    uint32_t damage;     // SWAP32(damage amount)
} s2c_healthbar_t;
```

#### 0x15 - Map Information
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x15
    uint16_t map_id;     // SWAP16(map ID)
    uint16_t map_width;  // SWAP16(map width)
    uint16_t map_height; // SWAP16(map height)
    uint8_t  flags;      // 4=weather, 5=normal
    uint8_t  name_len;   // Map name length
    char     name[];     // Map name
} s2c_map_info_t;
```

#### 0x17 - Add Spell
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x17
    uint8_t  slot;       // Spell slot position
    uint32_t spell_id;   // SWAP32(spell ID)
    uint8_t  name_len;   // Spell name length
    char     name[];     // Spell name
} s2c_add_spell_t;
```

#### 0x18 - Remove Spell
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(5)
    uint8_t  opcode;     // 0x18
    uint8_t  slot;       // Spell slot to remove
} s2c_remove_spell_t;
```

#### 0x19 - Map BGM/Music
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x12)
    uint8_t  opcode;     // 0x19
    uint8_t  bgm_type;   // 1=mp3/lsr, 2=mid
    uint8_t  unknown;    // 0x00
    uint16_t bgm_id;     // SWAP16(BGM ID)
    uint16_t bgm_id2;    // SWAP16(BGM ID repeat)
} s2c_map_bgm_t;
```

#### 0x1B - Paper Popup Write
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x1B
    uint8_t  inv_slot;   // Inventory slot
    uint8_t  unknown;    // 0x00
    uint8_t  width;      // Paper width
    uint8_t  height;     // Paper height
    uint16_t text_len;   // SWAP16(text length)
    char     text[];     // Paper text
} s2c_paper_write_t;
```

#### 0x1E - Acknowledgment
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x06)
    uint8_t  opcode;     // 0x1E
    uint8_t  type;       // 0x06
    uint8_t  result;     // 0x00
} s2c_ack_t;
```

#### 0x20 - Server Time
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x04)
    uint8_t  opcode;     // 0x20
    uint8_t  subtype;    // 0x03
    uint8_t  cur_time;   // Current time
    uint8_t  cur_year;   // Current year
} s2c_time_t;
```

#### 0x22 - Character Stats
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x22
    // Variable structure based on character data
    uint32_t hp;         // SWAP32(current HP)
    uint32_t max_hp;     // SWAP32(maximum HP)
    uint32_t mp;         // SWAP32(current MP)
    uint32_t max_mp;     // SWAP32(maximum MP)
    // Additional stat fields...
} s2c_stats_t;
```

#### 0x23 - Send Options
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x23
    uint8_t  flags;      // Option flags
    // Variable option data
} s2c_options_t;
```

#### 0x2F - NPC Shop Dialog
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x2F
    uint32_t npc_id;     // SWAP32(NPC ID)
    uint8_t  shop_type;  // 0=buy, 1=sell
    uint8_t  item_count; // Number of items
    struct {
        uint32_t item_id;  // SWAP32(item ID)
        uint32_t price;    // SWAP32(price)
        uint8_t  name_len; // Item name length
        char     name[];   // Item name
    } items[];           // Variable item list
} s2c_shop_dialog_t;
```

#### 0x30 - Script Message
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x30
    uint32_t npc_id;     // SWAP32(NPC ID)
    uint8_t  type;       // Message type
    uint8_t  msg_len;    // Message length
    char     message[];  // Message text
    uint8_t  has_prev;   // Previous button flag
    uint8_t  has_next;   // Next button flag
} s2c_script_message_t;
```

#### 0x31 - Board/Quest List
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x31
    uint8_t  type;       // 0x09 for quest
    uint8_t  count;      // Number of items
    // Variable list of board/quest items
} s2c_board_list_t;
```

#### 0x33 - Object Look (Extended)
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x33
    uint16_t x;          // SWAP16(x coordinate)
    uint16_t y;          // SWAP16(y coordinate)
    uint8_t  direction;  // Facing direction
    uint32_t object_id;  // SWAP32(object ID)
    // Object-specific appearance data
} s2c_object_look_ext_t;
```

#### 0x35 - Paper Popup
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x35
    uint8_t  unknown1;   // 0x00
    uint8_t  width;      // Paper width
    uint8_t  height;     // Paper height
    uint8_t  unknown2;   // 0x00
    uint16_t text_len;   // SWAP16(text length)
    char     text[];     // Paper text
} s2c_paper_popup_t;
```

#### 0x39 - Character Information
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x39
    uint8_t  ac;         // Armor class
    uint8_t  damage;     // Damage rating
    uint8_t  hit;        // Hit rating
    // Variable character data including clan, path, etc.
} s2c_char_info_t;
```

#### 0x3B - Heartbeat
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x07)
    uint8_t  opcode;     // 0x3B
    uint8_t  unknown1;   // 0x5F
    uint8_t  unknown2;   // 0x0A
} s2c_heartbeat_t;
```

#### 0x42 - Exchange Message
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x42
    uint8_t  type;       // Exchange type
    uint8_t  extra;      // Extra data
    uint8_t  msg_len;    // Message length
    char     message[];  // Message text
} s2c_exchange_msg_t;
```

#### 0x46 - Power Board
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x46
    // Power board specific data
} s2c_powerboard_t;
```

#### 0x49 - Retrieve Profile
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x04)
    uint8_t  opcode;     // 0x49
    uint8_t  subtype;    // 0x03
    uint16_t unknown;    // 0x0000
} s2c_retrieve_profile_t;
```

#### 0x4E - Throw Confirm
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x4E
    uint8_t  slot;       // Inventory slot
    // Throw confirmation data
} s2c_throw_confirm_t;
```

#### 0x58 - Equip Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x58
    uint8_t  unknown1;   // 0x00
    uint8_t  type;       // 0x06
    uint8_t  slot;       // Equipment slot
    // Item data
} s2c_equip_t;
```

#### 0x59 - Towns List
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x59
    uint8_t  unknown1;   // 0x40
    uint16_t unknown2;   // 0x0000
    uint8_t  unknown3;   // 0x22
    uint8_t  town_count; // Number of towns
    struct {
        uint8_t  id;       // Town ID
        uint8_t  name_len; // Town name length
        char     name[];   // Town name
        uint16_t map_id;   // SWAP16(map ID)
        uint16_t x;        // SWAP16(x coordinate)
        uint16_t y;        // SWAP16(y coordinate)
    } towns[];           // Variable town list
} s2c_towns_t;
```

#### 0x5A - Screensaver
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x04)
    uint8_t  opcode;     // 0x5A
    uint8_t  subtype;    // 0x03
    uint8_t  unknown;    // 0x00
    uint8_t  screen;     // Screensaver type
} s2c_screensaver_t;
```

#### 0x5F - Destroy Object (Type 2)
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(6)
    uint8_t  opcode;     // 0x5F
    uint8_t  subtype;    // 0x03
    uint32_t object_id;  // SWAP32(object ID)
} s2c_destroy2_t;
```

#### 0x62 - Board/Profile URL
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x62
    uint8_t  type;       // 0x00=board, 0x04=profile
    // URL data with length-prefixed strings
} s2c_board_url_t;
```

#### 0x66 - Send URL
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x66
    uint8_t  subtype;    // 0x03
    uint8_t  url_type;   // 0=ingame, 1=popup+close, 2=popup
    uint16_t url_len;    // SWAP16(URL length)
    char     url[];      // URL string
} s2c_send_url_t;
```

#### 0x67 - Send Timer
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(7)
    uint8_t  opcode;     // 0x67
    uint8_t  type;       // Timer type
    uint32_t duration;   // SWAP32(duration in ms)
} s2c_timer_t;
```

#### 0x68 - Pong (Ping Response)
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(0x09)
    uint8_t  opcode;     // 0x68
    uint32_t timestamp;  // SWAP32(tick count)
    uint8_t  unknown;    // 0x00
} s2c_pong_t;
```

#### 0x6F - Mini Text
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x6F
    uint8_t  text_len;   // Text length
    char     text[];     // Mini text message
} s2c_minitext_t;
```

#### 0x70 - Minimap
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x70
    // Minimap data
} s2c_minimap_t;
```

## Client-to-Server Packet Structures

### Map Server Client Packets

#### 0x05 - Request Map Data
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x05
    uint8_t  seq;        // Sequence number
    uint8_t  type;       // Request type
    uint16_t checksum;   // SWAP16(map checksum)
} c2s_map_request_t;
```

#### 0x06 - Walk Request
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x06
    uint8_t  seq;        // Sequence number
    uint16_t x0;         // SWAP16(start x)
    uint16_t y0;         // SWAP16(start y)
    uint8_t  x1;         // Width
    uint8_t  y1;         // Height
    uint16_t checksum;   // SWAP16(checksum)
} c2s_walk_t;
```

#### 0x07 - Get Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x07
    uint8_t  seq;        // Sequence number
    uint32_t item_id;    // SWAP32(item ID)
    uint16_t x;          // SWAP16(x coordinate)
    uint16_t y;          // SWAP16(y coordinate)
} c2s_get_item_t;
```

#### 0x08 - Drop Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x08
    uint8_t  seq;        // Sequence number
    uint8_t  slot;       // Inventory slot
    uint32_t quantity;   // SWAP32(quantity to drop)
    uint16_t x;          // SWAP16(x coordinate)
    uint16_t y;          // SWAP16(y coordinate)
} c2s_drop_item_t;
```

#### 0x09 - Look At (Type 2)
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x09
    uint8_t  seq;        // Sequence number
    uint32_t target_id;  // SWAP32(target ID)
} c2s_lookat2_t;
```

#### 0x0A - Look At
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x0A
    uint8_t  seq;        // Sequence number
    uint32_t target_id;  // SWAP32(target ID)
} c2s_lookat_t;
```

#### 0x0B - Close/Logout
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(3)
    uint8_t  opcode;     // 0x0B
    uint8_t  seq;        // Sequence number
} c2s_logout_t;
```

#### 0x0C - Missing Object Report
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x0C
    uint8_t  seq;        // Sequence number
    uint32_t object_id;  // SWAP32(missing object ID)
} c2s_missing_object_t;
```

#### 0x0D - Ignore Player
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x0D
    uint8_t  seq;        // Sequence number
    uint8_t  name_len;   // Player name length
    char     name[];     // Player name to ignore
} c2s_ignore_t;
```

#### 0x0E - Say/Chat
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x0E
    uint8_t  seq;        // Sequence number
    uint8_t  type;       // Chat type
    uint8_t  msg_len;    // Message length
    char     message[];  // Chat message
} c2s_say_t;
```

#### 0x0F - Cast Magic
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x0F
    uint8_t  seq;        // Sequence number
    uint8_t  lines;      // Number of spell lines
    struct {
        uint8_t len;     // Line length
        char    text[];  // Spell line text
    } spell_lines[];     // Variable spell lines
} c2s_cast_magic_t;
```

#### 0x10 - Accept Connection
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x10
    uint8_t  seq;        // Sequence number
    uint8_t  unknown[11];// Unknown data
    uint8_t  name_len;   // Character name length
    char     name[];     // Character name
} c2s_accept_t;
```

#### 0x11 - Change Direction
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x11
    uint8_t  seq;        // Sequence number
    uint8_t  direction;  // 0=North, 1=East, 2=South, 3=West
} c2s_change_dir_t;
```

#### 0x12 - Wield/Equip Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x12
    uint8_t  seq;        // Sequence number
    uint8_t  slot;       // Inventory slot
} c2s_wield_t;
```

#### 0x13 - Attack
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x13
    uint8_t  seq;        // Sequence number
    uint8_t  space_flag; // Space bar flag
} c2s_attack_t;
```

#### 0x17 - Throw Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x17
    uint8_t  seq;        // Sequence number
    uint8_t  confirm;    // Confirmation flag
    uint8_t  slot;       // Inventory slot
} c2s_throw_t;
```

#### 0x18 - Request User List
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x18
    uint8_t  seq;        // Sequence number
} c2s_userlist_t;
```

#### 0x19 - Whisper
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x19
    uint8_t  seq;        // Sequence number
    uint8_t  name_len;   // Target name length
    char     name[];     // Target player name
    uint8_t  msg_len;    // Message length
    char     message[];  // Whisper message
} c2s_whisper_t;
```

#### 0x1A - Eat Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x1A
    uint8_t  seq;        // Sequence number
    uint8_t  slot;       // Inventory slot
} c2s_eat_item_t;
```

#### 0x1B - Change Status
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x1B
    uint8_t  seq;        // Sequence number
    uint8_t  unknown;    // Unknown field
    uint8_t  status;     // New status
} c2s_change_status_t;
```

#### 0x1C - Use Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x1C
    uint8_t  seq;        // Sequence number
    uint8_t  slot;       // Inventory slot
} c2s_use_item_t;
```

#### 0x1D - Emotion/Emote
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x1D
    uint8_t  seq;        // Sequence number
    uint8_t  emotion;    // Emotion ID
} c2s_emotion_t;
```

#### 0x1F - Unequip Item
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x1F
    uint8_t  seq;        // Sequence number
    uint8_t  slot;       // Equipment slot
} c2s_unequip_t;
```

#### 0x20 - Open Object (Press 'O')
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x20
    uint8_t  seq;        // Sequence number
} c2s_open_t;
```

#### 0x23 - Save Paper Popup
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x23
    uint8_t  seq;        // Sequence number
    uint8_t  slot;       // Inventory slot
    uint16_t text_len;   // SWAP16(text length)
    char     text[];     // Paper text
} c2s_paper_save_t;
```

#### 0x24 - Drop Gold
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x24
    uint8_t  seq;        // Sequence number
    uint32_t amount;     // SWAP32(gold amount)
} c2s_drop_gold_t;
```

#### 0x27 - Quest Tab (Shift+Z)
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x27
    uint8_t  seq;        // Sequence number
    uint16_t type;       // SWAP16(quest type)
} c2s_quest_tab_t;
```

#### 0x29 - Hand Item (Trade)
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x29
    uint8_t  seq;        // Sequence number
    uint8_t  slot;       // Inventory slot
    uint32_t quantity;   // SWAP32(quantity)
} c2s_hand_item_t;
```

#### 0x2A - Hand Gold (Trade)
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x2A
    uint8_t  seq;        // Sequence number
    uint32_t amount;     // SWAP32(gold amount)
} c2s_hand_gold_t;
```

#### 0x2D - Status Request
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x2D
    uint8_t  seq;        // Sequence number
    uint8_t  type;       // 0=self, 1=group
} c2s_status_request_t;
```

#### 0x2E - Add to Group
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x2E
    uint8_t  seq;        // Sequence number
    uint8_t  name_len;   // Player name length
    char     name[];     // Player name
} c2s_add_group_t;
```

#### 0x30 - Change Spell/Position
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x30
    uint8_t  seq;        // Sequence number
    uint8_t  type;       // 0=position, 1=spell
    uint8_t  data[];     // Type-specific data
} c2s_change_spell_pos_t;
```

#### 0x39 - Menu/Input Response
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x39
    uint8_t  seq;        // Sequence number
    uint32_t npc_id;     // SWAP32(NPC ID)
    uint8_t  dialog_id;  // Dialog ID
    uint8_t  type;       // Input type
    uint8_t  data[];     // Input data
} c2s_menu_input_t;
```

#### 0x3A - NPC Dialog Response
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x3A
    uint8_t  seq;        // Sequence number
    uint32_t npc_id;     // SWAP32(NPC ID)
    uint8_t  graphic;    // NPC graphic
    uint8_t  color;      // NPC color
    uint8_t  choice;     // Dialog choice
} c2s_npc_dialog_t;
```

#### 0x3B - Board Interaction
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x3B
    uint8_t  seq;        // Sequence number
    uint8_t  type;       // Board action type
    uint16_t board_id;   // SWAP16(board ID)
    uint16_t post_id;    // SWAP16(post ID)
} c2s_board_t;
```

#### 0x3F - Map Change Request
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x3F
    uint8_t  seq;        // Sequence number
    uint16_t map_id;     // SWAP16(map ID)
    uint16_t x;          // SWAP16(x coordinate)
    uint16_t y;          // SWAP16(y coordinate)
} c2s_map_change_t;
```

#### 0x60 - Ping
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x60
    uint8_t  seq;        // Sequence number
} c2s_ping_t;
```

#### 0x75 - Walk Pong Response
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x75
    uint8_t  seq;        // Sequence number
    uint32_t timestamp;  // SWAP32(timestamp)
} c2s_walk_pong_t;
```

#### 0x7B - Request Meta Files
```c
typedef struct __attribute__((packed)) {
    uint8_t  magic;      // 0xAA
    uint16_t length;     // SWAP16(packet_len)
    uint8_t  opcode;     // 0x7B
    uint8_t  seq;        // Sequence number
    uint8_t  type;       // 0=request file, 1=request list
} c2s_meta_request_t;
```

## Important Enums and Constants

```c
// Magic byte for all packets
#define PACKET_MAGIC 0xAA

// Directions
enum direction {
    DIR_NORTH = 0,
    DIR_EAST = 1,
    DIR_SOUTH = 2,
    DIR_WEST = 3
};

// Character states
enum char_state {
    STATE_NORMAL = 0,
    STATE_MOVING = 1,
    STATE_DEAD = 2,
    STATE_SITTING = 3,
    STATE_HIDDEN = 4
};

// Equipment slots
enum equip_slot {
    EQ_WEAPON = 0,
    EQ_ARMOR = 1,
    EQ_SHIELD = 2,
    EQ_HELMET = 3,
    EQ_LEFT = 4,
    EQ_RIGHT = 5,
    EQ_NECKLACE = 6,
    EQ_BOOTS = 7,
    EQ_MANTLE = 8,
    EQ_COAT = 9,
    EQ_ACCESSORY1 = 10,
    EQ_ACCESSORY2 = 11,
    EQ_ACCESSORY3 = 12,
    EQ_ACCESSORY4 = 13
};

// Block types
enum block_type {
    BL_PC = 0x01,    // Player character
    BL_NPC = 0x02,   // NPC
    BL_MOB = 0x04,   // Monster
    BL_ITEM = 0x08,  // Item on ground
    BL_ALL = 0xFF    // All types
};

// URL types
enum url_type {
    URL_INGAME = 0,      // In-game browser
    URL_POPUP_CLOSE = 1, // Popup and close client
    URL_POPUP = 2        // Popup only
};

// Chat types
enum chat_type {
    CHAT_NORMAL = 0,
    CHAT_SHOUT = 1,
    CHAT_WHISPER = 2,
    CHAT_GROUP = 3,
    CHAT_CLAN = 4,
    CHAT_GM = 5
};

// Setting flags
#define FLAG_WEATHER    0x01
#define FLAG_SOUND      0x02
#define FLAG_MUSIC      0x04
#define FLAG_WHISPER    0x08
#define FLAG_GROUP      0x10
#define FLAG_EXCHANGE   0x20
#define FLAG_FASTMOVE   0x40
#define FLAG_HIDDEN     0x80

// Status codes
#define OUT_STATUS      0x1F

## Notes on Packet Construction

1. **Variable Length Strings**: Most strings are prefixed with a 1-byte length field
2. **Encryption**: Packets are encrypted after construction using:
   - `tk_encrypt()` for map server packets (stream cipher)
   - `tk_crypt_static()` for login server packets (static XOR)
3. **Sequence Numbers**: Client packets include sequence numbers for anti-hack protection
4. **Byte Order**: All multi-byte integers use little-endian with SWAP16/SWAP32 macros
5. **Padding**: Some packets include padding bytes for alignment
6. **Checksums**: Map data requests include checksums to avoid redundant transfers
