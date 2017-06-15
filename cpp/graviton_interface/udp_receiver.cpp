// udp_receiver.cpp - A connectionless UDP receiver
#include "udp_receiver.h"
#include <cstring>


udp_receiver::udp_receiver(const int port, const int packet_length)
{
    target.sin_family = AF_INET;
    target.sin_port = htons(port);
    target.sin_addr.s_addr = INADDR_ANY; //inet_addr(ip_dest);

    buflen = packet_length;
    buf.resize(buflen+1);
}

int udp_receiver::initialize(void)
{
    if ((sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == 0)
    {
        // perror("socket failed");
        return -1;
    }

    if (bind(sock_fd, (struct sockaddr *)&target, sizeof(target)) < 0)
    {
        perror("bind failed");
        return -2;
    }

    return 0;
}

int udp_receiver::cleanup(void)
{
    close(sock_fd);

    return 0;
}

int udp_receiver::read(void)
{
    int rvalue;

    rvalue = recvfrom(sock_fd, &buf[0], buflen, 0, 0, 0);

    if (rvalue != buflen) {
        perror("recvfrom");
        return -1;
    }

    return 0;
}

void udp_receiver::copy_to(const char *buffer)
{
    std::memcpy((void*)buffer, (void*)&buf[0], buflen);
}

void udp_receiver::copy_to(const char *buffer, const int len)
{
    std::memcpy((void*)buffer, (void*)&buf[0], len);
}