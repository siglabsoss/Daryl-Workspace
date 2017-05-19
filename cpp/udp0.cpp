//#include <stdio.h>
//#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define PORT 50000

int main(int argc, char const *argv[])
{
    int sock_fd, valread;
    struct sockaddr_in address {};
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[1464] {};

    // Creating socket file descriptor
    //printf("Creating socket...\n");
    if ((sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) == 0)
    {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Forcefully attaching socket to the port
    printf("Socket bind...\n");
    if (bind(sock_fd, (struct sockaddr *)&address, sizeof(address)) < 0)
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }

    printf("Read...\n");
    valread = recvfrom(sock_fd, buffer, 1464, 0, 0, 0);
    if (valread) {
        perror("recvfrom");
    }
    printf("%x %x %x %x %x\n", buffer[0], buffer[1], buffer[2], buffer[3], buffer[4]);

    for(int i = 0; i < 1464; ++i) {
        if(buffer[i] != 0) {
            printf("Nonzero value at %d is %d.\n", i, buffer[i]);
        }
    }

    return 0;
}
