// command.cpp - Command and Control Utility Functions
#include <iostream>
#include "command.h"
#include "sysdef.h"
using namespace sysdef;

////////////////////////////////
// Local function definitions
////////////////////////////////
void form_read_request(char *buffer, const unsigned sequence, const unsigned byte_address)
{
    buffer[0] = char((sequence     >>  0) & 0xFF);
    buffer[1] = char((sequence     >>  8) & 0xFF);
    buffer[2] = char((sequence     >> 16) & 0xFF);
    buffer[3] = char((sequence     >> 24) & 0xFF);

    buffer[4] = REG_READ_REQUEST;

    buffer[5] = char((byte_address >>  0) & 0xFF);
    buffer[6] = char((byte_address >>  8) & 0xFF);
    buffer[7] = char((byte_address >> 16) & 0xFF);
    buffer[8] = char((byte_address >> 24) & 0xFF);
}

void form_write_request(char *buffer, const unsigned sequence, const unsigned byte_address, const unsigned value)
{
    buffer[0]  = char((sequence     >>  0) & 0xFF);
    buffer[1]  = char((sequence     >>  8) & 0xFF);
    buffer[2]  = char((sequence     >> 16) & 0xFF);
    buffer[3]  = char((sequence     >> 24) & 0xFF);

    buffer[4]  = REG_WRITE_REQUEST;

    buffer[5]  = char((byte_address >>  0) & 0xFF);
    buffer[6]  = char((byte_address >>  8) & 0xFF);
    buffer[7]  = char((byte_address >> 16) & 0xFF);
    buffer[8]  = char((byte_address >> 24) & 0xFF);

    buffer[9]  = char((value        >>  0) & 0xFF);
    buffer[10] = char((value        >>  8) & 0xFF);
    buffer[11] = char((value        >> 16) & 0xFF);
    buffer[12] = char((value        >> 24) & 0xFF);
}

// void decode_message(const char *buffer, unsigned & sequence, unsigned & value, bool & success)
// {
//     // unsigned char msg_id;

//     // // Initialize fields
//     // sequence = 0;
//     // value = 0;
//     // success = false;

//     // // Extract Sequence Number
//     // sequence = buffer[3];
//     // sequence <<= 8;
//     // sequence |= buffer[2];
//     // sequence <<= 8;
//     // sequence |= buffer[1];
//     // sequence <<= 8;
//     // sequence |= buffer[0];

//     // // Extract Message ID
//     // msg_id = buffer[4];

//     // // Depending on Message ID, Extract More
//     // switch (msg_id) {
//     //     REG_WRITE_REQUEST: {
//     //         std::cerr << "Received msg_id: 0x";
//     //         std::cerr << std::hex << msg_id << std::dec;
//     //         std::cerr << " REG_WRITE_REQUEST (unsupported on this side)" << std::endl;
//     //         break;
//     //     }
//     //     REG_READ_REQUEST: {
//     //         std::cerr << "Received msg_id: 0x";
//     //         std::cerr << std::hex << msg_id << std::dec;
//     //         std::cerr << " REG_READ_REQUEST (unsupported on this side)" << std::endl;
//     //         break;
//     //     }
//     //     MEM_WRITE_REQUEST: {
//     //         std::cerr << "Received msg_id: 0x";
//     //         std::cerr << std::hex << msg_id << std::dec;
//     //         std::cerr << " MEM_WRITE_REQUEST (unsupported)" << std::endl;
//     //         break;
//     //     }
//     //     MEM_READ_REQUEST: {
//     //         std::cerr << "Received msg_id: 0x";
//     //         std::cerr << std::hex << msg_id << std::dec;
//     //         std::cerr << " MEM_READ_REQUEST (unsupported)" << std::endl;
//     //         break;
//     //     }
//     //     MSG_ACK: {
//     //         // Indicates Normal Operation
//     //         std::cerr << "Received msg_id: 0x";
//     //         std::cerr << std::hex << msg_id << std::dec;
//     //         std::cerr << " MSG_ACK" << std::endl;

//     //         if (buffer[5] == REG_READ_REQUEST) {
//     //             value = buffer[9];
//     //             value <<= 8;
//     //             value |= buffer[8];
//     //             value <<= 8;
//     //             value |= buffer[7];
//     //             value <<= 8;
//     //             value |= buffer[6];
//     //         }
//     //         break;
//     //     }
//     //     MSG_NACK: {
//     //         // Indicates an Error on the Line
//     //         std::cerr << "Received msg_id: 0x";
//     //         std::cerr << std::hex << msg_id << std::dec;
//     //         std::cerr << " MSG_NACK" << std::endl;
//     //         break;
//     //     }
//     //     MSG_UNKNOWN: {
//     //         // Indicates an Error on the Line
//     //         std::cerr << "Received msg_id: 0x";
//     //         std::cerr << std::hex << msg_id << std::dec;
//     //         std::cerr << " MSG_UNKNOWN" << std::endl;
//     //         break;
//     //     }
//     //     default: {
//     //         std::cerr << "Unrecognized msg_id received: 0x";
//     //         std::cerr << std::hex << msg_id << std::dec << "." << std::endl;
//     //         break;
//     //     }
//     // }
// }

