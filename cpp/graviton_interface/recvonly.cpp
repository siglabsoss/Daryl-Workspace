#include <iostream>
#include <fstream>
#include <thread>
#include <mutex>
#include <condition_variable>

#include "udp_receiver.h"

void write_data(void);

constexpr const char PORT[] = "50000";
constexpr int BUFLEN = 1472;
constexpr int CAPTURE_LENGTH = 147200;

// eventually make an array of structs of these things
// and access them with a for loop...
char buffer1[BUFLEN+1];
bool buffer1_full;
std::mutex mutex_buffer1_full;
std::condition_variable cv_buffer1_full;

char buffer2[BUFLEN+1];
bool buffer2_full;
std::mutex mutex_buffer2_full;
std::condition_variable cv_buffer2_full;

char buffer3[BUFLEN+1];
bool buffer3_full;
std::mutex mutex_buffer3_full;
std::condition_variable cv_buffer3_full;

int global_quit;
std::mutex mutex_global_quit;

int main(int argc, char **argv)
{
    udp_receiver udp(PORT, BUFLEN);

    if (udp.initialize()) {
        perror("udp.initialize");
        return -1;
    }

    buffer1_full = buffer2_full = buffer3_full = false;
    std::thread writing_thread(write_data);

    int byte_count = 0;
    while (byte_count < CAPTURE_LENGTH) {
        udp.read();
        udp.copy_to(buffer1);
        {
            std::unique_lock<std::mutex> b1_lock(mutex_buffer1_full);
            buffer1_full = true;
            cv_buffer1_full.notify_one();
        }

        udp.read();
        udp.copy_to(buffer2);
        {
            std::unique_lock<std::mutex> b2_lock(mutex_buffer2_full);
            buffer2_full = true;
            cv_buffer2_full.notify_one();
        }

        udp.read();
        udp.copy_to(buffer3);
        {
            std::unique_lock<std::mutex> b3_lock(mutex_buffer3_full);
            buffer3_full = true;
            cv_buffer3_full.notify_one();
        }
    }
    // Set global quit
    {
        std::unique_lock<std::mutex> q_lock(mutex_global_quit);
        global_quit = 1;
    }
    // Notify any conditions that it is time to check for quit signal
    {
        std::unique_lock<std::mutex> b1_lock(mutex_buffer1_full);
        cv_buffer1_full.notify_one();
    } {
        std::unique_lock<std::mutex> b2_lock(mutex_buffer2_full);
        cv_buffer2_full.notify_one();
    } {
        std::unique_lock<std::mutex> b3_lock(mutex_buffer3_full);
        cv_buffer3_full.notify_one();
    }
    // Join threads
    writing_thread.join();

    return 0;
}

void write_data(void)
{
    unsigned expected_seq_num = 0;
    int quit = 0;
    std::ofstream fout("datadump.bin", std::ios::binary);
    std::ofstream fsout("sequence.txt");

    while (!quit) {
        // Wait until each buffer is full, then write it to the file
        {
            std::unique_lock<std::mutex> b1_lock(mutex_buffer1_full);
            while(!buffer1_full & !global_quit) cv_buffer1_full.wait(b1_lock);
            if (!global_quit) {
                // Test sequence number
                //unsigned seq_num = (unsigned char)buffer1[0];
                //seq_num |= ((unsigned)(unsigned char)buffer1[1]) << 8;
                //seq_num |= ((unsigned)(unsigned char)buffer1[2]) << 16;
                //seq_num |= ((unsigned)(unsigned char)buffer1[3]) << 24;
                //if (seq_num != expected_seq_num) {
                //    std::cout << "Expected sequence " << expected_seq_num;
                //    std::cout << " but received " << seq_num << std::endl;
                //    expected_seq_num = seq_num + 1;
                //}
                //else {
                //    expected_seq_num++;
                //}
                // Write sequence numbers
                //fsout << seq_num << std::endl;
                // copy to file
                //fout.write(buffer1+4, BUFLEN-4);
                // copy to file
                fout.write(buffer1, BUFLEN);
                // Update status variable
                buffer1_full = false;
            }
        } {
            std::unique_lock<std::mutex> b2_lock(mutex_buffer2_full);
            while(!buffer2_full & !global_quit) cv_buffer2_full.wait(b2_lock);
            if (!global_quit) {
                // copy to file
                fout.write(buffer2, BUFLEN);
                // Update status variable
                buffer2_full = false;
            }
        } {
            std::unique_lock<std::mutex> b3_lock(mutex_buffer3_full);
            while(!buffer3_full & !global_quit) cv_buffer3_full.wait(b3_lock);
            if (!global_quit) {
                // copy to file
                fout.write(buffer3, BUFLEN);
                // Update status variable
                buffer3_full = false;
            }
        }
        // Update local quit signal
        {
            std::unique_lock<std::mutex> q_lock(mutex_global_quit);
            quit = global_quit;
        }
    }
}
