#!/bin/bash

# Force the network card settings for communicating with FPGA

sudo ifconfig enx00051bd0e55b down
sudo ifconfig enx00051bd0e55b hw ether 00:05:1b:d0:e4:ec
sudo ifconfig enx00051bd0e55b up
sudo ifconfig enx00051bd0e55b 192.168.2.1

