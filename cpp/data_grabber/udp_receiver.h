// udp_receiver.h - A connectionless UDP receiver

#ifndef UDP_RECEIVER_H_H_H
#define UDP_RECEIVER_H_H_H

#include <vector>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

class udp_receiver
{
    int sock_fd;
    struct sockaddr_in target;
    std::vector<char> buf;
    int buflen;
public:
    udp_receiver(const int port, const int packet_length);
    int initialize(void);
    int read(void);
    void copy_to(const char *buffer);
};

#endif
