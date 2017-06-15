// udp_receiver.cpp - A connectionless UDP receiver
#include "udp_receiver.h"
#include <cstring>


udp_transceiver::udp_transceiver(const int port, const int packet_length)
{
    target.sin_family = AF_INET;
    target.sin_port = htons(port);
    target.sin_addr.s_addr = INADDR_ANY; //inet_addr(ip_dest);

    buflen = packet_length;
    buf.resize(buflen+1);
}

int udp_transceiver::initialize(void)
{
    if ((sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == 0)
    {
        perror("socket failed");
        return -1;
    }

    if (bind(sock_fd, (struct sockaddr *)&target, sizeof(target)) < 0)
    {
        perror("bind failed");
        return -2;
    }

    return 0;
}

int udp_transceiver::read(void)
{
    int valread;

    valread = recvfrom(sock_fd, &buf[0], buflen, 0, 0, 0);

    if (valread) {
        // perror("recvfrom");
        return -1;
    }

    return 0;
}

void udp_transceiver::copy_rx_data_to_buffer(const char *buffer)
{
    std::memcpy((void*)buffer, (void*)&buf[0], buflen);
}

int udp_transceiver::write(void)
{
    int valread;

    valread = send(sock_fd, &buf[0], buflen, 0, 0, 0);

    if (valread) {
        // perror("recvfrom");
        return -1;
    }

    return 0;
}

void udp_transceiver::copy_rx_data_to_buffer(const char *buffer)
{
    std::memcpy((void*)buffer, (void*)&buf[0], buflen);
}
