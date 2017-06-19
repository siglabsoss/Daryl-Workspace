#!/bin/bash

# Force the network card settings for communicating with FPGA

sudo ifconfig enx00051bd0e55b 192.168.2.1
sudo arp -s 192.168.2.3 06:07:08:09:0a:0b
# sudo iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j DROP

