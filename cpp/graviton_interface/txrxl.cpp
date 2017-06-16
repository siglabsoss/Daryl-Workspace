#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <cstring>
#include <cmath>

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

extern std::mutex m_magic_value;
extern unsigned magic_value;

extern std::mutex m_send_value;
extern unsigned send_mode;
extern double send_frequency;
extern double send_sweep_rate;
extern double send_amplitude;
////////////////////////////////
// Local constants
////////////////////////////////
// Maximum number of UDP reads to try each iteration
constexpr int MAX_READ_ATTEMPTS = 1024;


////////////////////////////////
// Marsaglia's 64-bit KISS PRNG
////////////////////////////////
static unsigned long long
x=1234567890987654321ULL,c=123456123456123456ULL,
y=362436362436362436ULL,z=1066149217761810ULL,t;

#define KISS_MWC (t=(x<<58)+c, c=(x>>6), x+=t, c+=(x<t), x)
#define KISS_XSH ( y^=(y<<13), y^=(y>>17), y^=(y<<43) )
#define KISS_CNG ( z=6906969069LL*z+1234567 )
#define KISS     (KISS_MWC + KISS_XSH + KISS_CNG )

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

    unsigned long long iteration_count = 0;
    unsigned adc_sequence_number = 0;
    unsigned dac_sequence_number = 0;

    unsigned failed_read_count = 0;

    unsigned char local_rx_bytes[ADC_PACKET_LENGTH] { 0 };
    unsigned char local_tx_bytes[DAC_PACKET_LENGTH] { 0 };

    unsigned signal_mode = SIGNAL_ZERO;
    double signal_amplitude = DAC_FULL_SCALE;
    double signal_freq = 0.0;
    double signal_sweep_rate = 0.0;
    double signal_phase = 0.0;

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

        // Check if we need to change the dac signal mode
        if (m_send_value.try_lock()) {
            if (signal_mode != send_mode) {
                std::cerr << "<< Update! >>" << std::endl;
                signal_mode       = send_mode;
                signal_amplitude  = send_amplitude;
                signal_freq       = send_frequency;
                signal_sweep_rate = send_sweep_rate;
                signal_phase      = 0.0;
            }
            m_send_value.unlock();
        }

        // Attempt to transmit if dac has room
        if (!dac_buffer_almost_full) {
            // Write little endian sequence number to local buffer
            local_tx_bytes[0] = dac_sequence_number & 0xFF;
            local_tx_bytes[1] = (dac_sequence_number >> 8) & 0xFF;
            local_tx_bytes[2] = (dac_sequence_number >> 16) & 0xFF;
            local_tx_bytes[3] = (dac_sequence_number >> 24) & 0xFF;
            // Write the new data samples to the local buffer
            switch (signal_mode) {
                case SIGNAL_RAMP: {
                    for (int i = 4; i < DAC_PACKET_LENGTH; i += 4) {
                        // Simple Ramp Signal
                        local_tx_bytes[i]   = i - 4 + 0;
                        local_tx_bytes[i+1] = i - 4 + 1;
                        local_tx_bytes[i+2] = i - 4 + 2;
                        local_tx_bytes[i+3] = i - 4 + 3;
                    }
                    break;
                }
                case SIGNAL_RANDOM: {
                    for (int i = 4; i < DAC_PACKET_LENGTH; i += 4) {
                        // Random Values (generated via kiss64)
                        unsigned long long kiss_value = KISS;
                        local_tx_bytes[i]   = kiss_value & 0xFF;
                        local_tx_bytes[i+1] = (kiss_value >> 8) & 0xFF;
                        local_tx_bytes[i+2] = (kiss_value >> 16) & 0xFF;
                        local_tx_bytes[i+3] = (kiss_value >> 24) & 0xFF;
                    }
                    break;
                }
                case SIGNAL_SINE: // fall through
                case SIGNAL_SWEEP: {
                    for (int i = 4; i < DAC_PACKET_LENGTH; i += 4) {
                        // Calculate sinusoidal samples
                        int inph_value = signal_amplitude * std::cos(signal_phase);
                        int quad_value = signal_amplitude * std::sin(signal_phase);
                        // Store as little endian values in local buffer
                        local_tx_bytes[i]   = inph_value & 0xFF;
                        local_tx_bytes[i+1] = (inph_value >> 8) & 0xFF;
                        local_tx_bytes[i+2] = quad_value & 0xFF;
                        local_tx_bytes[i+3] = (quad_value >> 8) & 0xFF;
                        // Update phase for sine computation
                        signal_phase += signal_freq;
                        signal_phase = signal_phase > PI ? signal_phase - (2*PI) : signal_phase;
                    }
                    // Update frequency for sine computation
                    if (signal_mode == SIGNAL_SWEEP) {
                       signal_freq += signal_sweep_rate;
                        signal_freq = signal_freq > PI ? signal_freq - (2*PI) : signal_freq;
                    }
                    break;
                }
                default: {
                    // Default is SIGNAL_ZERO
                    for (int i = 4; i < DAC_PACKET_LENGTH; i += 4) {
                        local_tx_bytes[i] = 0;
                        local_tx_bytes[i+1] = 0;
                        local_tx_bytes[i+2] = 0;
                        local_tx_bytes[i+3] = 0;
                    }
                    break;
                }
            } // end switch

            // Check for a Magic Number Insertion Event
            // Right now magic causes a used sample to be replaced with an
            // unused sample (thus the total sample count is off by one
            // after a magic sample is sent)
            if (m_magic_value.try_lock()) {
                m_magic_value.unlock();
                if (magic_value != 0) {
                    // Write little endian sequence number to local buffer
                    local_tx_bytes[4+0] = magic_value & 0xFF;
                    local_tx_bytes[4+1] = (magic_value >> 8) & 0xFF;
                    local_tx_bytes[4+2] = (magic_value >> 16) & 0xFF;
                    local_tx_bytes[4+3] = (magic_value >> 24) & 0xFF;
                }
                // Reset magic to no magic
                magic_value = NOMAGIC;
            }
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
        // Increment the iteration counter
        iteration_count++;
    }
}