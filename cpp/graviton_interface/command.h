#ifndef COMMAND_H_H
#define COMMAND_H_H

#include "sysdef.h"
using namespace sysdef;

void form_read_request(char *buffer, const unsigned sequence, const unsigned byte_address);
void form_write_request(char *buffer, const unsigned sequence, const unsigned byte_address, const unsigned value);
void decode_message(const char *buffer, unsigned & sequence, unsigned & value, bool & success);

#endif
