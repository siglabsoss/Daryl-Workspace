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

extern std::mutex m_signal_data;
extern signal_params signal_data;

extern std::mutex m_statistics;
extern dsp_stats statistics;

extern std::mutex m_dumper;
extern dump_params dump_data;

////////////////////////////////
// Local constants
////////////////////////////////
// Maximum number of UDP reads to try each iteration
constexpr int MAX_READ_ATTEMPTS = 1024;


////////////////////////////////
// Marsaglia's 64-bit KISS PRNG
////////////////////////////////
static unsigned long long
kiss_x=1234567890987654321ULL,kiss_c=123456123456123456ULL,
kiss_y=362436362436362436ULL,kiss_z=1066149217761810ULL,kiss_t;

#define KISS_MWC (kiss_t=(kiss_x<<58)+kiss_c, kiss_c=(kiss_x>>6), kiss_x+=kiss_t, kiss_c+=(kiss_x<kiss_t), kiss_x)
#define KISS_XSH (kiss_y^=(kiss_y<<13), kiss_y^=(kiss_y>>17), kiss_y^=(kiss_y<<43))
#define KISS_CNG (kiss_z=6906969069LL*kiss_z+1234567)
#define KISS     (KISS_MWC + KISS_XSH + KISS_CNG)

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
    unsigned adc_failed_read_count = 0;
    unsigned adc_udp_sequence_error_count = 0;
    unsigned dac_sequence_number = 0;
    unsigned dac_buffer_almost_full_count = 0;
    unsigned dac_buffer_underflow_count = 0;
    unsigned dac_buffer_overflow_count = 0;
    unsigned dac_udp_sequence_error_count = 0;

    unsigned char local_rx_bytes[ADC_PACKET_LENGTH] { 0 };
    unsigned char local_tx_bytes[DAC_PACKET_LENGTH] { 0 };

    unsigned signal_mode = SIGNAL_ZERO;
    double signal_amplitude = DAC_FULL_SCALE;
    double signal_freq = 0.0;
    double signal_sweep_rate = 0.0;
    double signal_phase = 0.0;

    unsigned dumps_left;
    std::ofstream adcfile("adcdata.bin", std::ofstream::binary);

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
                adc_udp_sequence_error_count++;
            }
            adc_sequence_number++;

            // Update statistics based on incoming data packet
            if ((dac_buffer_almost_full = (local_rx_bytes[7] & 0x01))) {
                std::cerr << "DAC buffer almost full!" << std::endl;
                dac_buffer_almost_full_count++;
            }
            if ((dac_buffer_underflow = (local_rx_bytes[7] & 0x02))) {
                std::cerr << "DAC buffer underflow!" << std::endl;
                dac_buffer_underflow_count++;
            }
            if ((dac_buffer_overflow = (local_rx_bytes[7] & 0x04))) {
                std::cerr << "DAC buffer overflow!" << std::endl;
                dac_buffer_overflow_count++;
            }
            if ((dac_udp_sequence_error = (local_rx_bytes[7] & 0x08))) {
                std::cerr << "DAC UDP sequence error!" << std::endl;
                dac_udp_sequence_error_count++;
            }

            // Dump data if dumping is active
            if (dumps_left > 0) {
                std::cerr << "Dumping packet... (";
                std::cerr << dumps_left << ")" << std::endl;
                adcfile.write((char *)(local_rx_bytes + 8), ADC_PACKET_LENGTH - 8);
                dumps_left--;
            }

        }
        else {
            std::cerr << "Maximum number of read attempts failed on current iteration." << std::endl;
            std::cerr << "Total iterations of failure: " << ++adc_failed_read_count << std::endl;
        }

        // Check if we need to change the dac signal mode
        if (m_signal_data.try_lock()) {
            if (signal_data.needs_update) {
                std::cerr << "<< Update signal parameters >>" << std::endl;
                signal_mode              = signal_data.mode;
                signal_amplitude         = signal_data.amplitude;
                signal_freq              = signal_data.frequency;
                signal_sweep_rate        = signal_data.sweep_rate;
                signal_phase             = 0.0;
                signal_data.needs_update = 0;
            }
            m_signal_data.unlock();
        }

        // Update global variables with statistics
        if (m_statistics.try_lock()) {
            statistics.iteration = iteration_count;
            statistics.adc_sequence_number = adc_sequence_number;
            statistics.adc_failed_read_count = adc_failed_read_count;
            statistics.adc_udp_sequence_error_count = adc_udp_sequence_error_count;
            statistics.dac_sequence_number = dac_sequence_number;
            statistics.dac_buffer_almost_full_count = dac_buffer_almost_full_count;
            statistics.dac_buffer_underflow_count = dac_buffer_underflow_count;
            statistics.dac_buffer_overflow_count = dac_buffer_overflow_count;
            statistics.dac_udp_sequence_error_count = dac_udp_sequence_error_count;
            m_statistics.unlock();
        }

        // Update dump parameters if necessary
        if (m_dumper.try_lock()) {
            if (dump_data.needs_update) {
                dumps_left = dump_data.dumps_left;
                dump_data.needs_update = 0;
            }
            m_dumper.unlock();
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