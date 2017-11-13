#include <iostream>
#include <thread>
#include <cstring>

#include "udp_transmitter.h"
#include "udp_receiver.h"

void tx_string(udp_transmitter udp_tx);
void rx_string(udp_receiver udp_tx);

int main(int argc, char const * argv[])
{
    int max_length = 1024;
    char loopback_ip[] = "127.0.0.1";
    char loopback_port[] = "60000";

    // Tell user that their parameters were ignored
    if (argc > 1) {
        std::cerr << "Unused parameters..." << std::endl;
        for (int i = 1; i < argc; ++i) {
            std::cerr << "    " << i << ". " << argv[i] << std::endl;
        }
    }

    auto udp_rx = udp_receiver(loopback_port, max_length);
    auto udp_tx = udp_transmitter(loopback_ip, loopback_port, max_length);

    std::cout << "Initializing TX" << std::endl;
    udp_tx.initialize();
    if (!udp_tx.initialized()) {
        std::cout << "Error in initialization..." << std::endl;
        return -1;
    }

    std::cout << "Initializing RX" << std::endl;
    udp_rx.initialize();

    std::cout << "Launching threads..." << std::endl;
    auto tx_thread = std::thread(tx_string, udp_tx);
    auto rx_thread = std::thread(rx_string, udp_rx);

    tx_thread.join();
    rx_thread.join();

    if (udp_tx.cleanup() != 0) {
        std::cout << "Error in TX cleanup()." << std::endl;
    }

    if (udp_rx.cleanup() != 0) {
        std::cout << "Error in RX cleanup()." << std::endl;
    }

    std::cout << "Finished!" << std::endl;

    return 0;
}

void tx_string(udp_transmitter udp_tx)
{
    char tx_str[] = "Hello world!";

    std::cout << "Transmitting string '" << tx_str << "' of length ";
    std::cout << (std::strlen(tx_str)+1) << "." << std::endl;

    udp_tx.copy_from(tx_str, std::strlen(tx_str)+1);
    udp_tx.write();
}

void rx_string(udp_receiver udp_rx)
{
    char rx_str[256] { 0 };

    udp_rx.read();
    udp_rx.copy_to(rx_str, 256);

    std::cout << "Received string '" << rx_str << "'" << std::endl;
}
