// udp_transmitter.cpp - A connectionless UDP receiver
#include "udp_transmitter.h"
#include <iostream>
#include <cstring>


udp_transmitter::udp_transmitter(const char dest_ip_addr[], const char dest_port[], const int packet_length)
{
    // Note that nothing is initialized yet
    successfully_initialized = 0;

    // Initialize the hints object
    std::memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_DGRAM;

    // Store IP address and port information
    std::strcpy(dest_ip, dest_ip_addr);
    std::strcpy(port, dest_port);

    // Create local buffer for data transmission and initialize to zeros
    buflen = packet_length;
    buf.resize(buflen+1);
    for(auto buf_iter = buf.begin(); buf_iter != buf.end(); ++buf_iter) {
        *buf_iter = 0;
    }

    // Default transmit length is same as buffer length
    txlen = buflen;
}

int udp_transmitter::initialize(void)
{
    int rvalue;

    if (!successfully_initialized) {
        rvalue = getaddrinfo(dest_ip, port, &hints, &servinfo);
        if (rvalue != 0) {
            std::cerr << "getaddrinfo: " << gai_strerror(rvalue) << std::endl;
            return -1;
        }

        for (p = servinfo; p != nullptr; p = p->ai_next) {
            sock_fd = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
            if (sock_fd == -1) {
                perror("socket");
                continue;
            }
            break;
        }

        if (p == nullptr) {
            std::cerr << "socket creation failed!" << std::endl;
            return -2;
        }
    }

    successfully_initialized = 1;
    return 0;
}

int udp_transmitter::cleanup(void)
{
    freeaddrinfo(servinfo);
    close(sock_fd);

    successfully_initialized = 0;
    return 0;
}

int udp_transmitter::write(void)
{
    int valread;

    valread = sendto(sock_fd, &buf[0], txlen, 0, p->ai_addr, p->ai_addrlen);

    if (valread != txlen) {
        perror("sendto");
        return -1;
    }

    return 0;
}

void udp_transmitter::copy_from(const char *buffer)
{
    std::memcpy((void*)&buf[0], (void*)buffer, buflen);
    txlen = buflen;
}

void udp_transmitter::copy_from(const unsigned char *buffer)
{
    std::memcpy((void*)&buf[0], (void*)buffer, buflen);
    txlen = buflen;
}

void udp_transmitter::copy_from(const char *buffer, const int len)
{
    std::memcpy((void*)&buf[0], (void*)buffer, len);
    txlen = len;
}

void udp_transmitter::copy_from(const unsigned char *buffer, const int len)
{
    std::memcpy((void*)&buf[0], (void*)buffer, len);
    txlen = len;
}
