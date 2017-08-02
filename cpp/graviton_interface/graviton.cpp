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
std::mutex m_global_quit;
bool global_quit;

std::mutex m_magic_value;
unsigned magic_value;

std::mutex m_signal_data;
signal_params signal_data;

std::mutex m_statistics;
dsp_stats statistics;

std::mutex m_dumper;
dump_params dump_data;

////////////////////////////////
// Main program entry point
////////////////////////////////
int main(int argc, char const * argv[])
{
    // Tell user that their parameters were ignored
    if (argc > 1) {
        std::cerr << "Unused parameters..." << std::endl;
        for (int i = 1; i < argc; ++i) {
            std::cerr << "    " << i << ". " << argv[i] << std::endl;
        }
    }

    ///////////////////////////////////////////////
    // Initializing Inter Thread Data Structures
    ///////////////////////////////////////////////

    // Global quit signal to false
    global_quit = false;

    // Magic value to zero for no magic
    magic_value = NOMAGIC;

    // Signal generator values to zeros
    signal_data.needs_update = 1;
    signal_data.mode = SIGNAL_ZERO;
    signal_data.frequency = 0.0;
    signal_data.sweep_rate = 0.0;
    signal_data.amplitude = 0.0;

    // Statistics to zeros
    statistics.iteration = 0ULL;
    statistics.adc_sequence_number = 0U;
    statistics.adc_failed_read_count = 0U;
    statistics.dac_sequence_number = 0U;
    statistics.dac_buffer_almost_full_count = 0U;
    statistics.dac_buffer_underflow_count = 0U;
    statistics.dac_buffer_overflow_count = 0U;
    statistics.dac_udp_sequence_error_count = 0U;

    // Dump data
    dump_data.needs_update = 1;
    dump_data.reset_file = 0;
    dump_data.dumps_left = 0ULL;

    // Create UDP communication objects
    std::cout << "Creating UDP sockets..." << std::endl;
    auto adc_data_rx = udp_receiver(ADC_DATA_PORT, ADC_PACKET_LENGTH, ADC_DATA_TIMEOUT);
    auto dac_data_tx = udp_transmitter(DAC_DATA_IP, DAC_DATA_PORT, DAC_PACKET_LENGTH);
    auto cc_rx = udp_receiver(CCRX_DATA_PORT, CCRX_PACKET_LENGTH, CCRX_DATA_TIMEOUT);
    auto cc_tx = udp_transmitter(CCTX_DATA_IP, CCTX_DATA_PORT, CCTX_PACKET_LENGTH);

    // Initialize DAC data socket and verify that initialization worked
    std::cout << "Initializing DAC data UDP socket..." << std::endl;
    dac_data_tx.initialize();
    if (!dac_data_tx.initialized()) {
        std::cout << "Error in initialization..." << std::endl;
        return -1;
    }

    // Initialize ADC data socket
    std::cout << "Initializing ADC data UDP socket..." << std::endl;
    adc_data_rx.initialize();

    // Launch the threads
    std::cout << "Launching TX/RX thread..." << std::endl;
    auto txrx_thread = std::thread(txrxl, dac_data_tx, adc_data_rx);
    std::cout << "Launching REPL thread..." << std::endl;
    auto repl_thread = std::thread(repl);

    // Wait for the threads to finish
    txrx_thread.join();
    repl_thread.join();

    // Perform clean up
    if (dac_data_tx.cleanup() != 0) {
        std::cout << "Error in TX cleanup." << std::endl;
    }
    if (adc_data_rx.cleanup() != 0) {
        std::cout << "Error in RX cleanup." << std::endl;
    }

    // Report that we are done.
    std::cout << "Finished!" << std::endl << std::endl;

    return 0;
}

