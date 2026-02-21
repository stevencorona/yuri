 Binary Protocol

## Raw Frame

### No Encryption, No Seq
`0xAA 0x00 0x05 0xFF 0x00 0x00 0x00 0x00`

    byte   magic  - 0xAA   (1 byte)
    short  size   - 0x0005 (2 bytes)
    byte   opcode - 0xFF   (1 byte)
    byte[] data   - ...    (size - 1 byte)

### Static Encryption, Seq
`0xAA 0x00 0x05 0xFF 0x01 0x00 0x00 0x00`

    byte   magic       - 0xAA   (1 byte)
    short  size        - 0x0005 (2 bytes)
    byte   opcode      - 0xFF   (1 byte)
    byte   seq         - 0x01   (1 byte)
    byte[] encrypted   - ...    (size - 1 byte)


### Stream Encryption, Seq
`0xAA 0x00 0x08 0xFF 0x01 0x00 0x00 0x00 0xFF 0xFF 0xFF`

    byte   magic       - 0xAA     (1 byte)
    short  size        - 0x0008   (2 bytes)
    byte   opcode      - 0xFF     (1 byte)
    byte   seq         - 0x01     (1 byte)
    byte[] encrypted   - ...      (size - 4 byte)
    byte[] trailer     - 0xFFFFFF (3 bytes)
