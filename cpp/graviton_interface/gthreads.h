/* This file defines the entry points for the threads used in the graviton interface. */
#ifndef GTHREADS_H_H_H
#define GTHREADS_H_H_H

#include "udp_transmitter.h"
#include "udp_receiver.h"

struct signal_params
{
    unsigned mode;
    double frequency;
    double sweep_rate;
    double amplitude;
};

struct dsp_stats
{
    unsigned long long iteration;
    unsigned adc_sequence_number;
    unsigned adc_failed_read_cnt;
    unsigned dac_sequence_number;
    unsigned dac_buffer_almost_full_count;
    unsigned dac_buffer_underflow_count;
    unsigned dac_buffer_overflow_count;
    unsigned dac_udp_sequence_error_count;
};

void txrxl(udp_transmitter dac_data_tx, udp_receiver adc_data_rx);
void repl(void);

#endif