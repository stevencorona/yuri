#pragma once

/**
 * @file
 * @brief This file contains the functions for handling communication with the character server.
 */

/**
 * Authenticates the character server.
 * @param fd The file descriptor of the character server.
 * @return 0 on success, otherwise an error code.
 */
int intif_auth(int);

/**
 * Parses a packet from the character server.
 * @param fd The file descriptor of the character server.
 * @return 0 on success, otherwise an error code.
 */
int login_intif_parse(int);
