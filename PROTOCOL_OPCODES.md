# Yuri Server Protocol Opcodes Documentation

This document provides a comprehensive listing of all packet opcodes used in the Yuri MMORPG server protocol.

## Important Notes

1. **Magic Byte**: All packets start with `0xAA` as the first byte
2. **Packet Structure**: `[0xAA] [Length Low] [Length High] [Opcode] [Data...]`
3. **Encryption**: Most packets use `tk_encrypt()` (stream cipher), some use `tk_crypt_static()` (static XOR)
4. **Direction Matters**: The same opcode means different things when sent from server vs client!

## Server-to-Client Packets

### Map Server Packets

| Opcode | Function | Description | Encryption |
|--------|----------|-------------|------------|
| 0x02 | `clif_message()` (login) | Send message to client | Static |
| 0x03 | `clif_transfer()` | Server transfer (map/char server) | Stream |
| 0x03 | `clif_transfer_test()` | Test server transfer | Stream |
| 0x03 | `clif_closeit()` | Close connection/logout | Stream |
| 0x04 | `clif_sendxy()` | Send player position | Stream |
| 0x04 | `clif_sendxynoclick()` | Send position without click | Stream |
| 0x04 | `clif_sendxychange()` | Send position change | Stream |
| 0x05 | `clif_sendid()` | Send player ID | Stream |
| 0x06 | `clif_sendmapdata()` | **Send map tile data** | Stream |
| 0x07 | `clif_mob_look_close_func()` | Object look/graphics | Stream |
| 0x08 | `clif_sendupdatestatus_onkill()` | Status update on kill | Stream |
| 0x08 | `clif_sendupdatestatus_onequip()` | Status update on equip | Stream |
| 0x08 | `clif_sendupdatestatus_onunequip()` | Status update on unequip | Stream |
| 0x0A | `clif_popup()` | Popup message | Stream |
| 0x0A | `clif_broadcast()` | Broadcast message | Stream |
| 0x0A | `clif_sendbluemessage()` | Send blue message | Stream |
| 0x0C | `clif_npc_look_send()` | NPC spawn/look | Stream |
| 0x0E | `clif_send_destroy()` | Destroy object (type 1) | Stream |
| 0x0F | `clif_itemdisplay()` | Display item | Stream |
| 0x10 | `clif_floor_item()` | Floor item | Stream |
| 0x11 | `clif_sendside()` | Send side/direction | Stream |
| 0x12 | `clif_sendguidespecific()` | Send guide/tutorial | Stream |
| 0x13 | `clif_send_selfbar()` | Health bar update (self) | Stream |
| 0x13 | `clif_send_groupbars()` | Health bar update (group) | Stream |
| 0x15 | `clif_sendmapinfo()` | Send map information | Stream |
| 0x17 | `clif_sendaddspell()` | Add spell to list | Stream |
| 0x18 | `clif_removespell()` | Remove spell from list | Stream |
| 0x19 | `clif_sendmapinfo()` | Map BGM/music | Stream |
| 0x1B | `clif_paperpopupwrite()` | Paper popup write | Stream |
| 0x1E | `clif_sendack()` | Send acknowledgment | Stream |
| 0x20 | `clif_sendtime()` | Send server time | Stream |
| 0x22 | `clif_sendstats()` | Send character stats | Stream |
| 0x23 | `clif_sendoptions()` | Send client options | Stream |
| 0x26 | `clif_sendlist()` | Send list/inventory | Stream |
| 0x29 | `clif_sendanimation()` | Send animation | Stream |
| 0x2E | `clif_mapselect()` | Map selection | Stream |
| 0x2F | `clif_buydialog()` | NPC buy dialog | Stream |
| 0x2F | `clif_selldialog()` | NPC sell dialog | Stream |
| 0x30 | `clif_scriptmes()` | Script message | Stream |
| 0x31 | `clif_showboards()` | Show boards | Stream |
| 0x31 | `clif_sendBoardQuestionaire()` | Send questionnaire | Stream |
| 0x33 | `clif_sendnpclook()` | NPC look | Stream |
| 0x33 | `clif_sendmoblook()` | Mob look | Stream |
| 0x33 | `clif_object_look_func2()` | Object look | Stream |
| 0x34 | `clif_sendaethers()` | Send magic aethers | Stream |
| 0x35 | `clif_paperpopup()` | Paper popup | Stream |
| 0x38 | `clif_unequipit()` | Unequip item | Stream |
| 0x39 | `clif_sendack()` | Send character info | Stream |
| 0x3B | `clif_sendheartbeat()` | Heartbeat/keepalive | Stream |
| 0x42 | `clif_exchange_message()` | Exchange/trade message | Stream |
| 0x46 | `clif_sendpowerboard()` | Power board | Stream |
| 0x49 | `clif_retrieveprofile()` | Retrieve profile | Stream |
| 0x4E | `clif_throwconfirm()` | Throw confirmation | Stream |
| 0x58 | `clif_equip()` | Equip item | Stream |
| 0x58 | `clif_destroyold()` | Destroy old object | Stream |
| 0x59 | `clif_sendtowns()` | Send towns list | Stream |
| 0x5A | `clif_screensaver()` | Screensaver control | Stream |
| 0x5F | `clif_send_destroy()` | Destroy object (type 2) | Stream |
| 0x62 | `clif_sendboard()` | Send board URL | Stream |
| 0x62 | `clif_sendprofile()` | Send profile URL | Stream |
| 0x63 | `clif_sendtest()` | Test packet | Stream |
| 0x66 | `clif_sendurl()` | Send URL to client | Stream |
| 0x67 | `clif_send_timer()` | Send timer | Stream |
| 0x68 | `pc_sendpong()` | Ping response (pong) | Stream |
| 0x6F | `send_minitext()` | Send mini text | Stream |
| 0x70 | `clif_sendminimap()` | Send minimap | Stream |
| 0x83 | `clif_showclan()` | Show clan info | Stream |
| 0x84 | `clif_showsubpath()` | Show subpath info | Stream |

### Login Server Packets

| Opcode | Function | Description | Encryption |
|--------|----------|-------------|------------|
| 0x00 | Login response | Version check response | None |
| 0x02 | `clif_message()` | Send message (error/info) | Static |
| 0x60 | Login response | Authentication packet | Static |
| 0x66 | `login_clif_sendurl()` | Send URL | Static |
| 0x6F | `send_metafile()` | Send meta file data | Stream |

## Client-to-Server Packets

### Map Server Client Packets
**All packets use `tk_decrypt()` stream cipher decryption**

| Opcode | Handler Function | Description |
|--------|-----------------|-------------|
| 0x05 | `clif_parsemap()` | Request map data |
| 0x06 | `clif_parsewalk()` | Walk/movement |
| 0x07 | `clif_parsegetitem()` | Pick up item |
| 0x08 | `clif_parsedropitem()` | Drop item |
| 0x09 | `clif_parselookat_2()` | Look at (type 2) |
| 0x0A | `clif_parselookat()` | Look at |
| 0x0B | `clif_closeit()` | Close/logout |
| 0x0C | `clif_handle_missingobject()` | Missing object report |
| 0x0D | `clif_parseignore()` | Ignore player |
| 0x0E | `clif_parsesay()` | Say/chat |
| 0x0F | `clif_parsemagic()` | Cast magic |
| 0x10 | `clif_accept2()` | Accept connection |
| 0x11 | `clif_parseside()` | Change direction |
| 0x12 | `clif_parsewield()` | Wield/equip item |
| 0x13 | `clif_parseattack()` | Attack |
| 0x17 | `clif_parsethrow()` | Throw item |
| 0x18 | `clif_user_list()` | Request user list |
| 0x19 | `clif_parsewisp()` | Whisper |
| 0x1A | `clif_parseeatitem()` | Eat/consume item |
| 0x1B | `clif_changestatus()` | Change status |
| 0x1C | `clif_parseuseitem()` | Use item |
| 0x1D | `clif_parseemotion()` | Emotion/emote |
| 0x1E | `clif_parsewield()` | Wield (alternate) |
| 0x1F | `clif_parseunequip()` | Unequip item |
| 0x20 | `clif_open_sub()` | Open object (press 'O') |
| 0x23 | `clif_paperpopupwrite_save()` | Save paper popup |
| 0x24 | `clif_dropgold()` | Drop gold |
| 0x27 | Quest tab | Quest tab/guide (Shift+Z) |
| 0x29 | `clif_handitem()` | Hand item (trade) |
| 0x2A | `clif_handgold()` | Hand gold (trade) |
| 0x2D | `clif_mystaytus()`/`clif_groupstatus()` | Status request |
| 0x2E | `clif_addgroup()` | Add to group |
| 0x30 | `clif_parsechangespell()`/`clif_parsechangepos()` | Change spell/position |
| 0x32 | `clif_parsewalk()` | Walk (alternate) |
| 0x34 | `clif_postitem()` | Post item |
| 0x38 | `clif_refresh()` | Refresh view |
| 0x39 | `clif_handle_menuinput()` | Menu/input response |
| 0x3A | `clif_parsenpcdialog()` | NPC dialog response |
| 0x3B | `clif_handle_boards()` | Board interaction |
| 0x3F | `pc_warp()` | Map change request |
| 0x41 | `clif_parseparcel()` | Parcel/mail |
| 0x42 | Client crash debug | Debug info |
| 0x43 | `clif_handle_clickgetinfo()` | Click get info |
| 0x4A | `clif_parse_exchange()` | Exchange/trade |
| 0x4C | `clif_handle_powerboards()` | Power boards |
| 0x4F | `clif_changeprofile()` | Change profile |
| 0x60 | Ping | Keepalive ping |
| 0x66 | `clif_sendtowns()` | Request towns |
| 0x69 | Obstruction | Movement blocked |
| 0x6B | `createdb_start()` | Creation system |
| 0x73 | `clif_sendprofile()`/`clif_sendboard()` | Web board/profile |
| 0x75 | `clif_parsewalkpong()` | Walk pong response |
| 0x7B | `send_meta()`/`send_metalist()` | Request meta files |
| 0x7C | `clif_sendminimap()` | Request minimap |
| 0x7D | `clif_parseranking()` | Ranking system |
| 0x77 | `clif_parsefriends()` | Friends list |
| 0x82 | `clif_parseviewchange()` | View change |
| 0x83 | Screenshots | Screenshot notification |
| 0x84 | `clif_huntertoggle()` | Hunter list toggle |
| 0x85 | `clif_sendhunternote()` | Hunter note |

### Login Server Client Packets
**All packets use `tk_crypt_static()` static XOR decryption**

| Opcode | Description |
|--------|-------------|
| 0x00 | Version check |
| 0x02 | Login request |
| 0x03 | Character list request |
| 0x10 | Initial connection |
| 0x57 | Create character |
| 0x68 | Select character |
| 0x71 | Change password |
| 0x7B | Request meta files |

## Packet Structure Details

### Basic Packet Header
```
Byte 0: 0xAA (Magic byte)
Byte 1-2: Packet length (Little Endian, SWAP16 applied)
Byte 3: Opcode
Byte 4+: Packet data
```

### Encryption Types

1. **Stream Cipher** (`tk_encrypt()`/`tk_decrypt()`)
   - Used for most in-game packets
   - Rolling XOR with session key
   - Key updates with each packet

2. **Static XOR** (`tk_crypt_static()`)
   - Used for login packets
   - Fixed XOR pattern
   - No key rotation

3. **No Encryption**
   - Initial handshake packets
   - Version check

### Example: Map Data Packet (0x06)
```c
WBUFB(buf, 0) = 0xAA;        // Magic byte
WBUFW(buf, 1) = length;      // Packet length
WBUFB(buf, 3) = 0x06;        // Opcode
WBUFB(buf, 4) = 0x03;        // Sub-type
WBUFB(buf, 5) = 0;           // Flags
WBUFW(buf, 6) = x0;          // Start X
WBUFW(buf, 8) = y0;          // Start Y
WBUFB(buf, 10) = x1;         // Width
WBUFB(buf, 11) = y1;         // Height
// Followed by tile data (2 bytes each for tile, pass, object)
```

## Special Notes

1. **Bidirectional Opcodes**: Many opcodes are used in both directions with completely different meanings. For example:
   - 0x06 from server = map data
   - 0x06 from client = walk request

2. **Missing from Initial Scan**: The 0x06 map data packet was not found in initial WFIFOB searches because it uses WBUFB for buffer construction before copying to WFIFO.

3. **Packet Validation**: The server validates packet sequence numbers (seeds) to detect packet editing/manipulation.

4. **Size Limits**: Maximum packet size is typically 65535 bytes due to 16-bit length field.

5. **Coordinate System**: Uses SWAP16/SWAP32 for network byte order conversion on multi-byte values.