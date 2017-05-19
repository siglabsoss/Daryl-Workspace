#include <iostream>

#include "udp_server.h"

int main(int argc, char **argv)
{
    const char ip_addr[] = "127.0.0.1";
    char buffer[1464];
    udp_server udp(50000, ip_addr);

    if (udp.initialize()) {
        perror("udp.initialize");
        return -1;
    }

    udp.read();
    udp.copy_to(buffer);

    for (int i = 0; i < 100; i++) {
        std::cout << buffer[i] << ", ";
    }
    std::cout << buffer[100] << std::endl;

    return 0;
}
