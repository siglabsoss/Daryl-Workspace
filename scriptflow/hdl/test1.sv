`timescale 1ps / 1ps

`default_nettype none

module test1 (
    input  logic a,
    output logic b);

assign b = ~a;

endmodule: test1

`default_nettype wire
