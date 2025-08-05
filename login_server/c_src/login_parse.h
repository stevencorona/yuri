#pragma once

/**
 * @file
 * @brief Contains functions for parsing client packets.
 */

/**
 * @struct login_session_data
 * @brief Holds session-specific data for a client.
 */
struct login_session_data {
  unsigned int id;                                  /**< The account ID. */
  char name[16];                                  /**< The account name. */
  char pass[16];                                  /**< The account password. */
  char face, country, totem, sex, hair, face_color, hair_color; /**< Character appearance data. */
};

/**
 * Sends a message to the client.
 * @param fd The client's file descriptor.
 * @param code The message code.
 * @param buff The message string.
 * @return 0 on success.
 */
int clif_message(int, char, char *);

/**
 * Sends a URL to the client to be opened in their browser.
 * @param fd The client's file descriptor.
 * @param type The type of URL (0 for in-game browser, 1 for external, 2 for popup).
 * @param url The URL to send.
 * @return 0 on success.
 */
int login_clif_sendurl(int, int, const char *);

/**
 * Handles a new client connection.
 * @param fd The client's file descriptor.
 * @return 0 on success.
 */
int clif_accept(int);

/**
 * Parses incoming packets from a client.
 * @param fd The client's file descriptor.
 * @return 0 on success.
 */
int login_clif_parse(int);
