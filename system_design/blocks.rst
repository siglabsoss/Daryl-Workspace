#############################
Interface/Format Descriptions
#############################

**************************
Port Direction Inference
**************************

Port directions are inferred by their suffix. A suffix of *_i*
indicates that the port is an input. A suffix of *_o* indicates
that the port is an output. A suffix of *_io* indicates an inout
port.

Here is an example::

    module test {
        logic wire          clock_i;
        logic wire          reset_i;
        logic wire [15:0]   data_i;
        logic wire          valid_i;
        logic               ready_o;
        logic      [31:0]   data_o;
        logic               valid_o;
        logic wire          ready_i;
    };

**************************
Polarity Inference
**************************

Port polarity is inferred by a suffix or a lack thereof. The suffix
*_n* indicates an active low signal. The optional suffix *_p* indicates
an active high signal. This is optional, since by default, we assume
all signals are active high.

The polarity inference suffix is applied before the port direction
suffix. For example, if we had a module with an active low reset, we
would declare it as follows::

    module test {
        logic wire          clock_i;
        logic wire          reset_n_i;
        logic wire [15:0]   data_i;
        logic wire          valid_i;
        logic               ready_o;
        logic      [31:0]   data_o;
        logic               valid_o;
        logic wire          ready_y;
    }


**************************
Default Net Type
**************************

It is preferable to use code that invokes the SystemVerilog directive
to change the default net type to nothing. This is to avoid typos that
can lead to undesired behavior when a net is inferred but has not been
defined. We also follow the idea that explicit declaration of the nets
we want is a good idea from a debugging and code maintenance
point-of-view.

An example of invoking this on an empty module is::

    `default_nettype none

    module name();
    endmodule: name

    `default_nettype wire

**************************
Complex-Valued Conventions
**************************

When bundling together complex-valued data, there are two fields.
In rectangular format, these are the real and imaginary parts.
In polar format, these are the magnitude and angle. The convention
that we follow for bundling under rectangular format is that the
real part should occupy the least significant word and the
imaginary part should occupy the most significant word. The
convention that we follow for polar format is that the magnitude
should occupy the least significant word and the angle should
occupy the most significant word. For example, if we had a 16-bit
real and a 16-bit imaginary part, we would use the following
representation:

+------------------------+------------------------+
| Bits 31 down to 16     | Bits 15 down to 0      |
+========================+========================+
| 16-bit imaginary part  | 16-bit real part       |
+------------------------+------------------------+

The choice of 32-bit numbers here was arbitrary. It is not a
requirement. The numbers could other lengths, and they need
not be symmetrical. For example, the following representation
still adheres to the convention:

+------------------------+------------------------+
| Bits 20 down to 16     | Bits 15 down to 0      |
+========================+========================+
| 4-bit imaginary part   | 16-bit real part       |
+------------------------+------------------------+

If we had a 24-bit magnitude and an 8-bit angle, we would
represent this as:

+------------------------+------------------------+
| Bits 31 down to 24     | Bits 23 down to 0      |
+========================+========================+
| 8-bit angle            | 24-bit magnitude       |
+------------------------+------------------------+

This convention only applies when bundling these fields together
in the HDL. It doesn't apply if they are defined as separate
fields for example::

    logic [15:0] inph;
    logic [15:0] quad;

This still follows the convention since these are individual
signals. If these were going to be concatenated, then we would
use the following to adhere to the convention::

    logic [31:0] complex_sample;
    assign complex_sample = {
        quad, inph
    };

**********************
Valid/Ready Handshake
**********************

This method of transfer allows for flow control (i.e.,
regulation of the data transfer) to occur in either
direction. It is possible and acceptable to associate
multiple data fields with a single valid/ready handshake.
For example, if there is an in_phase and quadrature field
on a complex baseband signal, then both are likely to be
associated with the same valid/ready handshake.

Why we need common interfaces:

    We need common interfaces to ensure interoperability of our
    blocks. This will also aid in reordering them if required.
    Plus, it helps us as developers share a common language for
    the design. This helps us to avoid ambiguity and hand-waving
    when we are talking about the design. Ambiguity is the enemy.

The basic idea of the valid/ready handshake is that data is
transferred on a clock cycle when valid and ready are both
high. Data is not transferred on a clock cycle when this is
not true. If the valid signal is asserted, it must remain
asserted until the ready signal is asserted. The ready signal
may wait for the valid signal to go high before being asserted,
but the valid signal may not wait for the ready signal to go
high before being asserted. These conditions prevent lock up
from occurring. Lock up is a state when both the upstream and
downstream blocks are waiting to hear from each other, but
neither takes the initiative. The upstream block is always
responsible to initiate transactions (although the downstream
block may advertise itself as ready or not). This handshake
is modeled after the AXI Stream standard, but we don't require
that data fields are multiples of bytes, and we have limited
the number of fields to three: data, valid, and ready.

**Note:** A valid/ready handshake indicates a single transfer may
take place. If on the next cycle, the valid or ready signal is
driven low, then a transfer does not occur on that clock cycle.
For bursting behavior see the valid/ready burst interface.

A SystemVerilog interface that exemplifies this is given next::

    interface intf_vr();

        parameter integer WIDTH = 16;

        logic [WIDTH-1:0]   data;
        logic               valid;
        logic               ready;

        modport upstream(
            output valid, data,
            input  ready
        );

        modport downstream(
            input  valid, data,
            output ready
        );

    endinterface: intf_vr

If SystemVerilog interfaces are not well supported by the tools,
then we will just mimic them by using the names with prefixes. For
example::

    module upstream_module(
        input  logic wire          clock_i,
        input  wire logic               clock_o,
        output logic      [7:0]    sample_data_o,
        output logic               sample_valid_o,
        input  logic wire          ready
    );
    endmodule;

    module downstream_module(
        input  logic wire          clock_i,
        output logic               clock_o,
        output logic      [7:0]    sample_data_o,
        output logic               sample_valid_o,
        input  logic wire          ready
    );
    endmodule;

Some blocks will only support flow regulation in one way direction
or the other (either upstream or downstream only). These can be
implemented by tying a ready/valid signal high or by simply leaving
it off the port map. Anything left off the port map is assumed to
be driven by a constant high value. The preferred implementation is
to leave the port off of the port map.

Do not name signals valid and ready unless they have the semantics
indicated in this section. It will just confuse us.

**********************
Valid/Ready Bursting
**********************

The Valid/Ready Bursting interface allows complete blocks to be
transferred contiguously between blocks. For example, the FFT output
and a buffering mechanism used to add the cyclic prefix might use
this type of bursting interface.

The signals are analogous the simple valid/ready handshake described
above, but we have changed their names to indicate that they are part
of the burst interface. We prefixed their names with a *b* to set them
apart from the handshaking signals. This is to avoid developer confusion.

The

A SystemVerilog interface that exemplifies this is given next::

    interface intf_burst();

        parameter integer WIDTH = 16;

        logic [WIDTH-1:0]   bdata;
        logic               bvalid;
        logic               bready;

        modport upstream(
            output bvalid, bdata,
            input  bready
        );

        modport downstream(
            input  bvalid, bdata,
            output bready
        );

    endinterface: intf_burst

##################
Block Descriptions
##################

******************
Generic Blocks
******************

This section describes blocks that belong neither to the
transmitter nor the receiver, but are still a part of the
overall system design.

==================
System Timer
==================

The system clock continuously increments until it is reset
by the dedicated reset. There is an independent system timer
in each FPGA, but they should all share a common reset and
should therefore be synchronous giving us a global reference
for event scheduling.

Ports:

* clock_i (clock)

* reset_i (1-bit input)

* enable_i (1-bit input)

* timer_count_o (64-bit output)

Associated Registers:

* LSBs

    * Use this register to read out the least significant bits of the system timer without side effects. Only use this register if you do not need the MSBs as well.

* MSBs

    * Use this register to read out the most significant bits of the system timer without side effects. Only use this register if you do not need the LSBs as well.

* MSBs then LSBs

    * Read this register twice in succession to first read the MSBs, and then the associated LSBs. The LSBs are frozen when the MSBs are read until the register is read again. This is done to guarantee a synchronous read of both registers. This is the register to use if you need both LSBs and MSBs read synchronously.

******************
Transmitter Blocks
******************

This section describes blocks that are part of the transmitter design.

==================
Packet Buffers
==================

The purpose of the packet buffers is to delay the transmit chain
processing until a complete packet is ready to be consumed to avoid
starving any stage of the design while waiting for more data to
arrive. This is important in order to meet the real-time constraints
of the DAC.

Ports:

* clock_i (clock)

* reset_i (active-high reset)

* byte_i (8-bit input)

* byte_valid_i (1-bit input)

* byte_ready_o (1-bit output)

* byte_o (8-bit input)

* byte_valid_o (1-bit output)

* byte_ready_i (1-bit output)

Associated Registers:

* Bytes per Packet Less One (32-bit)

    * A register that indicates how many bytes can be stuffed into a single packet. The number of bytes is actually the value of the register plus one. So, zero corresponds to one, 999 corresponds to 1000, and so on.

==================
Scrambler
==================

The scrambler scrambles the input data sequence to ensure that it
appears to be more random when it is transmitted over the channel.
This improves the signal Peak-to-Average Power Ratio (PAPR).

The scrambler design that we will use takes 8-bit inputs and
scrambles them to produce 8-bit outputs.

Ports:

* clock_i (clock)

* reset_i (active-high reset)

* byte_i (8-bit input)

* byte_valid_i (1-bit input)

* byte_ready_o (1-bit output)

* byte_o (8-bit output)

* byte_valid_o (1-bit output)

* byte_ready_i (1-bit input)

==================
LDPC Encoder
==================

==================
QAM Symbol Mapper
==================

==================
Subcarrier Mapper
==================

==============================
Inverse Fast Fourier Transform
==============================

===============
Cyclic Prefixer
===============

================
Sample Turnstile
================

Like a turnstile, this block will apply back pressure
on the upstream blocks and pass only zeros until a set
of conditions is met. There is a condition to turn it
on at a specific count of the system clock. There is a
condition to turn it off after it has been on for a
specific set of clock counts.

The sample turnstile assumes that data is always ready
for its consumption. In general, this should be true if
the system doesn't raise the enable right away.

Ports:

* sample_inph_i (16-bit input)

* sample_quad_i (16-bit input)

* sample_ready_o (1-bit output)

* sample_inph_o (16-bit output)

* sample_quad_o (16-bit output)

* enable_i (1-bit input)

* reset_i (1-bit input)

Associated registers:

* Trigger Time (in units of the system clock)

    * When System Clock equals Trigger Time, samples pass through the block

* On-Air Time (in units of the system clock)

    * If samples are passing through the block and System Clock equals On-Air Time, then the turnstile is locked and samples stop passing through.

* Bypass

    * If bypass is set to one and the turnstile is enabled, samples pass through unimpeded.

* Enable (active high)

    * If enable is high, the turnstile is enabled. If enable is low, the turnstile is disabled. If the turnstile is disabled, it outputs zeros and advertises to upstream blocks that it is not ready to accept data.

******************
Receiver Blocks
******************

This section describes blocks that are part of the receiver design.

**To be completed...**