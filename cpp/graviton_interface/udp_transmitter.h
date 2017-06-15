// udp_transmitter.h - A connectionless UDP receiver

#ifndef UDP_TRANSMITTER_H_H_H
#define UDP_TRANSMITTER_H_H_H

#include <vector>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>

class udp_transmitter
{
    int sock_fd;
    char dest_ip[256];
    char port[256];
    struct addrinfo hints;
    struct addrinfo *servinfo;
    struct addrinfo *p;
    bool successfully_initialized;
    std::vector<char> buf;
    int buflen;
public:
    udp_transmitter(const char dest_ip_addr[], const char dest_port[], const int packet_length);
    int initialize(void);
    int cleanup(void);
    int write(void);
    void copy_from(const char *buffer);
    void copy_from(const char *buffer, const int len);
    bool initialized(void) { return successfully_initialized; }
};

#endif
