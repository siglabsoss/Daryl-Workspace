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
#include "command.h"
#include "sysdef.h"
using namespace sysdef;

////////////////////////////////
// Inter-thread communication
////////////////////////////////
extern std::mutex m_global_quit;
extern bool global_quit;

extern std::mutex m_cctx_msg;
extern cc_msg_queue cctx_messages;

////////////////////////////////
// Local constants
////////////////////////////////
// Maximum number of UDP reads to try each iteration
constexpr int MAX_READ_ATTEMPTS = 1024;

void cctxl(udp_transmitter cc_tx)
{
    bool local_quit = false;
    cc_msg message;

    char buffer[65536];

    while (!local_quit) {
        // Handle incoming messages from the REPL
        if (cctx_messages.dequeue(message)) {
            if (message.msg_type == REG_READ_REQUEST) {
                form_read_request(&buffer[0], message.sequence_number, message.address);
                cc_tx.copy_from(&buffer[0], READ_REQUEST_LENGTH);
            }
            else {
                form_write_request(&buffer[0], message.sequence_number, message.address, message.value);
                cc_tx.copy_from(&buffer[0], WRITE_REQUEST_LENGTH);
            }
            cc_tx.write();
        }
        else {
            std::this_thread::sleep_for(std::chrono::microseconds(10));
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
