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
extern std::mutex m_global_quit;
extern bool global_quit;

///////////////////////////////////////////////////////////
// Graviton transmit/receive thread entry point
///////////////////////////////////////////////////////////
void txrxl(udp_transmitter dac_data_tx, udp_receiver adc_data_rx)
{
    bool local_quit = false;
    bool dac_buffer_almost_full = false;
    unsigned adc_sequence_number = 0;
    unsigned dac_sequence_number = 0;

    while (!local_quit) {
        // Sleep to simulate some kind of work/rest scenario
        std::this_thread::sleep_for(std::chrono::microseconds(100));

        //if
        //udp_transmitter

        // Verify that no one has signaled us to quit.
        {
            std::unique_lock<std::mutex>(m_global_quit);
            if (global_quit != 0) {
                local_quit = global_quit;
            }
        }
    }
}