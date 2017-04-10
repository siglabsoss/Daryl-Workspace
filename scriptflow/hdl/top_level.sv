`timescale 1ps / 1ps

`default_nettype none

module top_level (
    input  wire logic clock,
    output wire logic led_pin
);

logic read_value;
logic led_value = 1'b0;

always_ff @(posedge clock) begin
    led_value <= ~led_value | read_value;
end

test1 test1_inst (
    .a(led_value),
    .b(led_pin  ));

testmem testmem_inst (
    .testmem1_Data     (led_value ),
    .testmem1_Q        (read_value),
    .testmem1_RdAddress(led_value ),
    .testmem1_WrAddress(led_value ),
    .testmem1_RdClock  (clock     ),
    .testmem1_RdClockEn(~led_value),
    .testmem1_Reset    (1'b0      ),
    .testmem1_WE       (led_value ),
    .testmem1_WrClock  (clock     ),
    .testmem1_WrClockEn(1'b1      ));

endmodule: top_level

`default_nettype wire
