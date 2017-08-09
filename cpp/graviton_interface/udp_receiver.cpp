// udp_receiver.cpp - A connectionless UDP receiver
#include "udp_receiver.h"

#include <iostream>
#include <cstdio>
#include <cstring>


udp_receiver::udp_receiver(const char port[], const int packet_length, const int timeout_us)
{
    int myport;
    if (std::sscanf(port, "%d", &myport) != 1) {
        std::cerr << "Error converting port " << port << " to an integer." << std::endl;
    }

    target.sin_family = AF_INET;
    target.sin_port = htons(myport);
    target.sin_addr.s_addr = htonl(INADDR_ANY);

    buflen = packet_length;
    buf.resize(buflen+1);
    for(auto buf_iter = buf.begin(); buf_iter != buf.end(); ++buf_iter) {
        *buf_iter = 0;
    }

    // Store the timeout constant (negative or zero means block until data comes)
    timeout_in_microsecs = timeout_us;
}

int udp_receiver::initialize(void)
{
    if ((sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) <= 0)
    {
        perror("socket failed");
        return -1;
    }

    if (timeout_in_microsecs > 0) {
        struct timeval read_timeout;
        read_timeout.tv_sec = 0;
        read_timeout.tv_usec = timeout_in_microsecs;
        if ((setsockopt(sock_fd, SOL_SOCKET, SO_RCVTIMEO, &read_timeout, sizeof(read_timeout))) != 0) {
            perror("setsockopt : timeout");
            return -2;
        }

    }

    if (bind(sock_fd, (struct sockaddr *)&target, sizeof(target)) < 0)
    {
        perror("bind failed");
        return -3;
    }

    return 0;
}

int udp_receiver::cleanup(void)
{
    close(sock_fd);

    return 0;
}

int udp_receiver::read(int bytes) // non-blocking (0 on success)
{
    int rvalue;

    if (bytes < 0) {
        rvalue = recvfrom(sock_fd, &buf[0], buflen, 0, 0, 0);

        if (rvalue != buflen) {
            // This is only an error if timeouts are not active
            if (timeout_in_microsecs <= 0) {
                perror("recvfrom");
            }
            return -1;
        }
    }
    else {
        rvalue = recvfrom(sock_fd, &buf[0], bytes, 0, 0, 0);

        if (rvalue != bytes) {
            // This is only an error if timeouts are not active
            if (timeout_in_microsecs <= 0) {
                perror("recvfrom");
            }
            return -1;
        }
    }

    return 0;
}

void udp_receiver::copy_to(const char *buffer)
{
    std::memcpy((void*)buffer, (void*)&buf[0], buflen);
}

void udp_receiver::copy_to(const unsigned char *buffer)
{
    std::memcpy((void*)buffer, (void*)&buf[0], buflen);
}

void udp_receiver::copy_to(const char *buffer, const int len)
{
    std::memcpy((void*)buffer, (void*)&buf[0], len);
}

void udp_receiver::copy_to(const unsigned char *buffer, const int len)
{
    std::memcpy((void*)buffer, (void*)&buf[0], len);
}
