#ifndef SYSDEF_H_H_H
#define SYSDEF_H_H_H
/* System Definition File - Primarily for defining shared constant values. */

namespace sysdef {

    ////////////////////////////////////////////////
    // LINK CONSTANTS
    ////////////////////////////////////////////////
    constexpr char DAC_DATA_IP[]     = "192.168.2.2";
    constexpr char DAC_DATA_PORT[]   = "50000";
    constexpr int  DAC_PACKET_LENGTH = 1472-4;

    constexpr char ADC_DATA_PORT[]   = "50001";
    constexpr char ADC_DATA_TIMEOUT  = 100; // microseconds
    constexpr int  ADC_PACKET_LENGTH = 1472;

    constexpr char CCTX_DATA_IP[]     = "192.168.2.2";
    constexpr char CCTX_DATA_PORT[]   = "60000";
    constexpr int  CCTX_PACKET_LENGTH = 1500;

    constexpr char CCRX_DATA_PORT[]   = "60001";
    constexpr char CCRX_DATA_TIMEOUT  = 100; // microseconds
    constexpr int  CCRX_PACKET_LENGTH = 1500;

    ////////////////////////////////////////////////
    // MAGIC NUMBER CONSTANTS
    ////////////////////////////////////////////////
    constexpr unsigned NOMAGIC = 0x00000000;
    constexpr unsigned TXMAGIC = 0x80018001;
    constexpr unsigned RXMAGIC = 0x7fff7fff;

    ////////////////////////////////////////////////
    // SEND SIGNAL CONSTANTS
    ////////////////////////////////////////////////
    constexpr unsigned SIGNAL_ZERO   = 0x00000000;
    constexpr unsigned SIGNAL_RAMP   = 0x00000001;
    constexpr unsigned SIGNAL_RANDOM = 0x00000002;
    constexpr unsigned SIGNAL_SINE   = 0x00000003;
    constexpr unsigned SIGNAL_SWEEP  = 0x00000004;

    ////////////////////////////////////////////////
    // MATH NUMBER CONSTANTS
    ////////////////////////////////////////////////
    constexpr double PI = 3.14159265358979;

    ////////////////////////////////////////////////
    // DSP NORMALIZATION CONSTANTS
    ////////////////////////////////////////////////
    constexpr double DAC_FULL_SCALE = 27969.0;

    ////////////////////////////////////////////////
    // COMMAND AND CONTROL INTERFACE
    ////////////////////////////////////////////////
    constexpr unsigned char WRITE_REQUEST_LENGTH = 13; // Bytes
    constexpr unsigned char READ_REQUEST_LENGTH = 9; // Bytes

    ////////////////////////////////////////////////
    // Max messages in command and control queue
    ////////////////////////////////////////////////
    constexpr int CC_QUEUE_LENGTH = 16; // inter-thread comms

    ////////////////////////////////////////////////
    // COMMAND AND CONTROL MESSAGE/PACKET TYPES
    ////////////////////////////////////////////////
    constexpr unsigned char REG_WRITE_REQUEST = 0;
    constexpr unsigned char REG_READ_REQUEST = 1;
    constexpr unsigned char MEM_WRITE_REQUEST = 2; // Unsupported
    constexpr unsigned char MEM_READ_REQUEST = 3; // Unsupported
    constexpr unsigned char MSG_ACK = 0xF0;
    constexpr unsigned char MSG_NACK = 0xF1;
    constexpr unsigned char MSG_UNKNOWN = 0xFF;

} // end sysdef

#endif
