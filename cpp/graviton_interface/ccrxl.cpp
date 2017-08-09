#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <cstring>
#include <cmath>

#include "gthreads.h"
#include "command.h"
#include "udp_receiver.h"
#include "sysdef.h"
using namespace sysdef;

////////////////////////////////
// Inter-thread communication
////////////////////////////////
extern std::mutex m_global_quit;
extern bool global_quit;

extern std::mutex m_ccrx_msg;
extern cc_msg_queue ccrx_messages;


void ccrxl(udp_receiver cc_rx)
{
    bool local_quit = false;
    char buffer[CCRX_PACKET_LENGTH] {0};

    while (!local_quit) {
        if (cc_rx.read(10) != -1) {
            std::cerr << "Detected a CCRX msg!" << std::endl;
            cc_rx.copy_to(&buffer[0]);

            unsigned sequence;
            unsigned value;
            bool success;

            decode_message(&buffer[0], sequence, value, success);
            std::cerr << "REG MSG RECEIVED:" << std::endl;
            std::cerr << "    SEQ=" << sequence << std::endl;
            std::cerr << "    VAL=" << value << std::endl;
            std::cerr << "    SUCCESS=" << success << std::endl;
        }
        else {
            std::this_thread::sleep_for(std::chrono::microseconds(100));
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
