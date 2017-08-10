// udp_receiver.h - A connectionless UDP receiver

#ifndef UDP_RECEIVER_H_H_H
#define UDP_RECEIVER_H_H_H

#include <vector>

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

class udp_receiver
{
    int sock_fd;
    struct sockaddr_in target;
    int timeout_in_microsecs;
    std::vector<char> buf;
    int buflen;
public:
    udp_receiver(const char port[], const int packet_length, const int timeout_us=-1);
    int initialize(void);
    int cleanup(void);
    int read(int bytes=-1);
    void copy_to(const char *buffer);
    void copy_to(const unsigned char *buffer);
    void copy_to(const char *buffer, const int len);
    void copy_to(const unsigned char *buffer, const int len);
    int buffer_size(void) { return buflen; }
};

#endif
