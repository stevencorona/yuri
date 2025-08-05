Below is your document with the tables cleaned up so they render correctly in Markdown.

---

# Login Server Documentation

This document provides a detailed explanation of the login server's architecture, packet protocol, encryption method, and inter-server communication protocol.

## 1. Architecture

The login server is a standalone application responsible for authenticating users and providing them with a list of available character servers. It is written in C and uses a single-threaded, non-blocking I/O model with a `select()` loop to handle multiple client connections simultaneously.

The server is composed of the following main components:

* **`login_server.c`** – The main entry point of the application. It initializes the server, listens for incoming connections, and handles the main `select()` loop.
* **`login_parse.c`** – Contains the logic for parsing incoming packets from clients (login requests, new-character requests, password changes, etc.).
* **`login_char.c`** – Manages communication with the character server (credential checks, character creation, password changes).
* **`net_crypt.c`** – Implements encryption and decryption of packets exchanged between the client and login server.
* **`session.c`** – Provides a generic session-management layer for handling client connections, including socket I/O.

The login server interacts with a MySQL database to store user-account information, character data, and other relevant game data.

## 2. Packet Protocol

Communication between the client and login server follows a custom packet protocol. All packets share a common 3-byte header followed by a variable-length payload.

### 2.1. Packet Header

| Field     | Size (bytes) | Description                                       |
| --------- | ------------ | ------------------------------------------------- |
| Packet ID | 2            | Unique identifier for the packet type.            |
| Length    | 2            | Total length of the packet, including the header. |

### 2.2. Ingress Packets (Client ➜ Server)

| Opcode | Name                  | Description                                                                                                                    |
| ------ | --------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `0x00` | Version Request       | Sent by the client to verify that its game version is compatible with the server.                                              |
| `0x02` | New Account Request   | Sent by the client to create a new account. Contains the desired username and password.                                        |
| `0x03` | Login Request         | Sent by the client to log in to an existing account. Contains the username and password.                                       |
| `0x04` | New Character Request | Sent by the client to create a new character. Contains the character’s name, gender, hair style, and other appearance details. |
| `0x26` | Change Password       | Sent by the client to change the account password. Contains the username, old password, and new password.                      |
| `0x7B` | Meta File Request     | Sent by the client to request a meta file from the server (item definitions, monster stats, map info, etc.).                   |

### 2.3. Egress Packets (Server ➜ Client)

| Opcode | Name             | Description                                                                                                                                                             |
| ------ | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `0x00` | Version Response | Sent in response to a version request. Contains a status code indicating whether the client’s version is up-to-date.                                                    |
| `0x02` | Message          | Displays a message to the client. Contains a message code and a string.                                                                                                 |
| `0x03` | Login Response   | Sent in response to a login request. Contains a status code indicating success/failure; on success it also includes the character-server IP, port, and a session token. |
| `0x6F` | Meta File        | Sent in response to a meta-file request. Contains the (compressed) file data.                                                                                           |

## 3. Encryption

Communication between the client and login server is protected by a two-layer XOR scheme.

### 3.1. Layer 1: Static XOR Encryption

A static XOR key, hard-coded in both client and server, encrypts/decrypts every packet.

### 3.2. Layer 2: Dynamic XOR Encryption

A per-session dynamic XOR key is derived from a hash of the username plus a random seed. After the server shares this key with the client, both parties encrypt/decrypt only the **payload** of subsequent packets with it.

**Handshake flow**

1. Client sends `Login Request`.
2. Server generates dynamic key (username + random seed).
3. Server returns the dynamic key to the client.
4. Both sides use that key for the remainder of the session.

## 4. Inter-server Protocol

The login server talks to the character server for account operations (auth, character creation, etc.) using a simple request/response protocol.

### 4.1. Ingress Packets (Character Server ➜ Login Server)

| Opcode   | Name                     | Description |
| -------- | ------------------------ | ----------------------- |
| `0x2001` | New Account Response     | Sent in response to a new-account request. Contains a status code indicating success/failure.                                   |
| `0x2002` | New Character Response   | Sent in response to a new-character request. Contains a status code indicating success/failure.                                 |
| `0x2003` | Login Response           | Sent in response to a login request. Contains a status code and, on success, the character-server IP, port, and session token.  |
| `0x2004` | Change Password Response | Sent in response to a change-password request. Contains a status code indicating whether the password was updated successfully. |

### 4.2. Egress Packets (Login Server ➜ Character Server)

| Opcode   | Name                  | Description                                                                                                      |
| -------- | --------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `0x1001` | New Account Request   | Sent to create a new account. Contains the desired username and password.                                        |
| `0x1002` | New Character Request | Sent to create a new character. Contains the character’s name, gender, hair style, and other appearance details. |
| `0x1003` | Login Request         | Sent to authenticate a user. Contains the username and password.                                                 |
| `0x1004` | Change Password       | Sent to change an account’s password. Contains the username, old password, and new password.                     |
