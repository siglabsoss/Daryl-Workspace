#ifndef SYSDEF_H_H_H
#define SYSDEF_H_H_H
/* System Definition File - Primarily for defining shared constant values. */

namespace sysdef {

    ////////////////////////////////////////////////
    // LINK CONSTANTS
    ////////////////////////////////////////////////
    constexpr char DAC_DATA_IP[]     = "192.168.2.3";
    constexpr char DAC_DATA_PORT[]   = "60000";
    constexpr int  DAC_PACKET_LENGTH = 1472-4;

    constexpr char ADC_DATA_PORT[]   = "50000";
    constexpr char ADC_DATA_TIMEOUT  = 100; // microseconds
    constexpr int  ADC_PACKET_LENGTH = 1472;

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

} // end sysdef

#endif
