#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <cstring>
#include <cmath>

#include "gthreads.h"
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

////////////////////////////////
// Local constants
////////////////////////////////
// Maximum number of UDP reads to try each iteration
constexpr int MAX_READ_ATTEMPTS = 1024;

void ccrxl(udp_receiver cc_rx)
{
    bool local_quit = false;


}
