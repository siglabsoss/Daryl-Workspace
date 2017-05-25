// udp_server.cpp - A connectionless UDP server
#include "udp_server.h"
#include <cstring>


udp_server::udp_server(const int port, const char *ip_dest)
{
    target.sin_family = AF_INET;
    target.sin_port = htons(port);
    target.sin_addr.s_addr = INADDR_ANY; //inet_addr(ip_dest);

    buflen = 1464;
    buf.resize(buflen);
}

int udp_server::initialize(void)
{
    if ((sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == 0)
    {
        // perror("socket failed");
        return -1;
    }

    if (bind(sock_fd, (struct sockaddr *)&target, sizeof(target)) < 0)
    {
        // perror("bind failed");
        return -2;
    }

    return 0;
}

int udp_server::read(void)
{
    int valread;

    valread = recvfrom(sock_fd, &buf[0], buflen, 0, 0, 0);

    if (valread) {
        // perror("recvfrom");
        return -1;
    }

    return 0;
}

void udp_server::copy_to(const char *buffer)
{
    std::memcpy((void*)buffer, (void*)&buf[0], buflen);
}