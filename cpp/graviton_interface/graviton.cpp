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

////////////////////////////////
// Inter-thread communication
////////////////////////////////
std::mutex m_global_quit;
bool global_quit;

////////////////////////////////
// Local constants
////////////////////////////////
const int MAX_LENGTH = 1024;
const char DAC_DATA_IP[] = "192.168.2.3";
const char DAC_DATA_PORT[] = "60000";
const char ADC_DATA_PORT[] = "50001";

////////////////////////////////
// Main program entry point
////////////////////////////////
int main(int argc, char const * argv[])
{
    // Initialize the quit signal to false
    global_quit = false;

    // Initialize UDP communication objects
    std::cout << "Creating UDP sockets..." << std::endl;
    auto adc_data_rx = udp_receiver(ADC_DATA_PORT, MAX_LENGTH, 100);
    auto dac_data_tx = udp_transmitter(DAC_DATA_IP, DAC_DATA_PORT, MAX_LENGTH);

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
        std::cout << "Error in TX cleanup()." << std::endl;
    }
    if (adc_data_rx.cleanup() != 0) {
        std::cout << "Error in RX cleanup()." << std::endl;
    }

    // Report that we are done.
    std::cout << "Finished!" << std::endl << std::endl;

    return 0;
}
