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
    // MAGIC NUMBERS
    ////////////////////////////////////////////////
    constexpr int NOMAGIC = 0x00000000;
    constexpr int TXMAGIC = 0x80018001;
    constexpr int RXMAGIC = 0x7fff7fff;

} // end sysdef

#endif
