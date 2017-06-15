/* This file defines the entry points for the threads used in the graviton interface. */
#ifndef GTHREADS_H_H_H
#define GTHREADS_H_H_H

#include "udp_transmitter.h"
#include "udp_receiver.h"

void txrxl(udp_transmitter dac_data_tx, udp_receiver adc_data_rx);
void repl(void);

#endif