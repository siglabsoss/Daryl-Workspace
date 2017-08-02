/* This file defines the entry points for the threads used in the graviton interface. */
#ifndef GTHREADS_H_H_H
#define GTHREADS_H_H_H

#include "udp_transmitter.h"
#include "udp_receiver.h"

struct signal_params
{
    bool needs_update;
    unsigned mode;
    double frequency;
    double sweep_rate;
    double amplitude;
};

struct dsp_stats
{
    unsigned long long iteration;
    // ADC stream stats
    unsigned adc_sequence_number;
    unsigned adc_failed_read_count;
    unsigned adc_udp_sequence_error_count;
    // DAC stream stats
    unsigned dac_sequence_number;
    unsigned dac_buffer_almost_full_count;
    unsigned dac_buffer_underflow_count;
    unsigned dac_buffer_overflow_count;
    unsigned dac_udp_sequence_error_count;
};

struct dump_params
{
    bool needs_update;
    bool reset_file;
    unsigned long long dumps_left;
};

// Transmit/Receive Loop (send samples)
void txrxl(udp_transmitter dac_data_tx, udp_receiver adc_data_rx);

// Read/Eval/Print Loop (simple user interface)
void repl(void);

// Command and Control Loop (read/write regs)
void cncl(udp_transmitter cc_tx, udp_receiver cc_rx);

#endif