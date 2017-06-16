#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <cstring>

#include "gthreads.h"
#include "udp_transmitter.h"
#include "udp_receiver.h"
#include "sysdef.h"
using namespace sysdef;

////////////////////////////////
// Inter-thread communication
////////////////////////////////
extern std::mutex m_global_quit;
extern bool global_quit;

extern std::mutex m_send_magic;
extern int magic_value;

////////////////////////////////
// Local constants
////////////////////////////////
// Maximum number of UDP reads to try each iteration
constexpr int MAX_READ_ATTEMPTS = 1024;

///////////////////////////////////////////////////////////
// Graviton transmit/receive thread entry point
///////////////////////////////////////////////////////////
void txrxl(udp_transmitter dac_data_tx, udp_receiver adc_data_rx)
{
    bool local_quit = false;

    bool dac_buffer_almost_full = false;
    bool dac_buffer_underflow = false;
    bool dac_buffer_overflow = false;
    bool dac_udp_sequence_error = false;

    unsigned adc_sequence_number = 0;
    unsigned dac_sequence_number = 0;

    unsigned failed_read_count = 0;

    unsigned char local_rx_bytes[ADC_PACKET_LENGTH] { 0 };
    unsigned char local_tx_bytes[DAC_PACKET_LENGTH] { 0 };

    for (int i = 0; i < DAC_PACKET_LENGTH; i += 4) {
        local_tx_bytes[i] = 4*i + 0;
        local_tx_bytes[i] = 4*i + 1;
        local_tx_bytes[i] = 4*i + 2;
        local_tx_bytes[i] = 4*i + 3;
    }

    while (!local_quit) {
        // Sleep to simulate some kind of work/rest scenario
        int read_attempts = 0;
        while (adc_data_rx.read() != 0) {
            std::this_thread::sleep_for(std::chrono::microseconds(4));
            if (++read_attempts == MAX_READ_ATTEMPTS) {
                break;
            }
        }
        if (read_attempts < MAX_READ_ATTEMPTS) {
            // Read succeed, copy data to local buffer
            adc_data_rx.copy_to(local_rx_bytes);

            // Extract little endian sequence number
            unsigned new_adc_sequence_number = local_rx_bytes[0];
            new_adc_sequence_number += unsigned(local_rx_bytes[1]) << 8;
            new_adc_sequence_number += unsigned(local_rx_bytes[2]) << 16;
            new_adc_sequence_number += unsigned(local_rx_bytes[3]) << 24;

            // Compare to current sequence number
            if (adc_sequence_number != new_adc_sequence_number) {
                std::cerr << "ADC SEQUENCE NUMBER ERROR " << adc_sequence_number;
                std::cerr << " != " << new_adc_sequence_number << std::endl;
                adc_sequence_number = new_adc_sequence_number;
            }
            adc_sequence_number++;

            // TODO: convert this information into a header file definitions somewhere
            dac_buffer_almost_full = local_rx_bytes[7] & 0x01;
            dac_buffer_underflow   = local_rx_bytes[7] & 0x02;
            dac_buffer_overflow    = local_rx_bytes[7] & 0x04;
            dac_udp_sequence_error = local_rx_bytes[7] & 0x08;

            if (dac_buffer_almost_full) {
                std::cerr << "DAC buffer almost full!" << std::endl;
            }
            if (dac_buffer_underflow) {
                std::cerr << "DAC buffer underflow!" << std::endl;
            }
            if (dac_buffer_overflow) {
                std::cerr << "DAC buffer overflow!" << std::endl;
            }
            if (dac_udp_sequence_error) {
                std::cerr << "DAC UDP sequence error!" << std::endl;
            }
        }
        else {
            std::cerr << "Maximum number of read attempts failed on current iteration." << std::endl;
            std::cerr << "Total iterations of failure: " << ++failed_read_count << std::endl;
        }
        // Attempt to transmit if dac has room
        if (!dac_buffer_almost_full) {
            // Write little endian sequence number
            local_tx_bytes[0] = dac_sequence_number & 0xFF;
            local_tx_bytes[1] = (dac_sequence_number >> 8) & 0xFF;
            local_tx_bytes[2] = (dac_sequence_number >> 16) & 0xFF;
            local_tx_bytes[3] = (dac_sequence_number >> 24) & 0xFF;
            // Transmit to FPGA
            dac_data_tx.copy_from((char *)local_tx_bytes, DAC_PACKET_LENGTH);
            dac_data_tx.write();
            // Increment sequence number
            dac_sequence_number++;
            // std::cerr << "DAC SEQ NUM = " << dac_sequence_number << std::endl;
            // std::cerr << "            = { " << std::hex;
            // std::cerr << "0x" << unsigned(local_tx_bytes[3]);
            // std::cerr << "0x" << unsigned(local_tx_bytes[2]);
            // std::cerr << "0x" << unsigned(local_tx_bytes[1]);
            // std::cerr << "0x" << unsigned(local_tx_bytes[0]) << std::dec;
            // std::cerr << " };" << std::endl;
        }
        else {
            std::cerr << "Skipped DAC frame" << std::endl;
        }
        // Verify that no one has signaled us to quit.
        {
            std::unique_lock<std::mutex>(m_global_quit);
            if (global_quit != 0) {
                local_quit = global_quit;
            }
        }
    }
}