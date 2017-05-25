// udp_server.h - A connectionless UDP server

#ifndef UDP_SERVER_H_H_H
#define UDP_SERVER_H_H_H

#include <vector>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

class udp_server
{
    int sock_fd;
    struct sockaddr_in target;
    std::vector<char> buf;
    int buflen;
public:
    udp_server(const int port, const char *ip_dest);
    int initialize(void);
    int read(void);
    void copy_to(const char *buffer);
};

#endif
