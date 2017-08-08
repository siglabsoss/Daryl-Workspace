/* This file defines the entry points for the threads used in the graviton interface. */
#ifndef GTHREADS_H_H_H
#define GTHREADS_H_H_H

#include "sysdef.h"
using namespace sysdef;

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

struct cc_msg
{
    int sequence_number;
    int msg_type;
    int address;
    int value;
};

class cc_msg_queue
{
    cc_msg data[CC_QUEUE_LENGTH];
    int head;
    int tail;
    int seq_num;
public:
    cc_msg_queue() { seq_num = head = tail = 0; }
    bool enqueue_read(int addr) {
        if (head - tail < CC_QUEUE_LENGTH) {
            int head_modulo = head % CC_QUEUE_LENGTH;
            data[head_modulo].sequence_number = seq_num++;
            data[head_modulo].msg_type = REG_READ_REQUEST;
            data[head_modulo].address = addr;
            data[head_modulo].value = 0;
            head++;
            return true;
        }
        return false;
    }
    bool enqueue_write(int addr, int value) {
        if (head - tail < CC_QUEUE_LENGTH) {
            int head_modulo = head % CC_QUEUE_LENGTH;
            data[head_modulo].sequence_number = seq_num++;
            data[head_modulo].msg_type = REG_WRITE_REQUEST;
            data[head_modulo].address = addr;
            data[head_modulo].value = value;
            head++;
            return true;
        }
        return false;
    }
    bool enqueue(cc_msg msg) {
        if (head - tail < CC_QUEUE_LENGTH) {
            int head_modulo = head % CC_QUEUE_LENGTH;
            data[head_modulo].sequence_number = msg.sequence_number;
            data[head_modulo].msg_type = msg.msg_type;
            data[head_modulo].address = msg.address;
            data[head_modulo].value = msg.value;
            head++;
            return true;
        }
        return false;
    }
    bool dequeue(cc_msg & msg) {
        if (head - tail > 0) {
            int tail_modulo = tail % CC_QUEUE_LENGTH;
            msg.sequence_number = data[tail_modulo].sequence_number;
            msg.msg_type = data[tail_modulo].msg_type;
            msg.address = data[tail_modulo].address;
            msg.value = data[tail_modulo].value;
            tail++;
            return true;
        }
        return false;
    }
};

// Transmit/Receive Loop (send samples)
void txrxl(udp_transmitter dac_data_tx, udp_receiver adc_data_rx);

// Read/Eval/Print Loop (simple user interface)
void repl(void);

// Command and Control Loops (read/write regs)
void cctxl(udp_transmitter cc_tx);
void ccrxl(udp_receiver cc_rx);

#endif