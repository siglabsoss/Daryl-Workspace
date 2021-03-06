`timescale 10ps / 10ps

`default_nettype none

module ddc_ddsx2 (
    input  wire logic [32-1:0] i_phase_inc,
    input  wire logic          i_phase_inc_valid,
    output      logic [36-1:0] o_cosine_data,
    output      logic [36-1:0] o_sine_data,
    output      logic [36-1:0] o_cosine_delay_data,
    output      logic [36-1:0] o_sine_delay_data,
    input       logic          i_ready,
    input  wire logic          i_clock,
    input  wire logic          i_reset
);

// Phase increment
logic [32-1:0] phase_inc_reg;
logic [32-1:0] phase_accum;
logic [32-1:0] phase_accum_delay;
logic          phase_written_reg;

always_ff @ (posedge i_clock) begin
    // Read input phase increment
    if (i_phase_inc_valid == 1'b1) begin
        phase_inc_reg <= i_phase_inc;
        phase_written_reg <= 1'b1;
    end else begin
        phase_written_reg <= 1'b0;
    end
    // Increment phase whenever an output is requested
    if (phase_written_reg == 1'b1) begin
        phase_accum <= {32{1'b0}};
        phase_accum_delay <= phase_inc_reg;
    end else if (i_ready == 1'b1) begin
        phase_accum <= phase_accum + {phase_inc_reg, 1'b0};
        phase_accum_delay <= phase_accum_delay + {phase_inc_reg, 1'b0};
    end
end

// Sine/Cosine Look Up Table
localparam integer WIDTH = 36;

logic        [2*WIDTH-1:0]    sincos_reg0;
logic        [2*WIDTH-1:0]    sincos_delay_reg0;
logic signed [WIDTH-1:0]      cosine_reg0;
logic signed [WIDTH-1:0]      sine_reg0;
logic signed [WIDTH-1:0]      cosine_delay_reg0;
logic signed [WIDTH-1:0]      sine_delay_reg0;

localparam logic [2*WIDTH-1:0] all_zeros = {(2*WIDTH){1'b0}};

// Pipeline Stage 0
logic [2*WIDTH-1:0] sincos_lut_ram [0:16384-1] /* synthesis syn_ramstyle="block_ram" */;
initial begin
    $readmemb("ddc_sincos.mif", sincos_lut_ram);
end
always_ff @ (posedge i_clock) begin
    if (i_ready == 1'b1) begin
        sincos_reg0 <= sincos_lut_ram[phase_accum[32-1:32-14]];
        sincos_delay_reg0 <= sincos_lut_ram[phase_accum_delay[32-1:32-14]];
    end
end

assign sine_reg0 = sincos_reg0[2*WIDTH-1:WIDTH];
assign cosine_reg0 = sincos_reg0[WIDTH-1:0];
assign sine_delay_reg0 = sincos_delay_reg0[2*WIDTH-1:WIDTH];
assign cosine_delay_reg0 = sincos_delay_reg0[WIDTH-1:0];

// Perform Correction
logic signed [WIDTH-1:0] cosine_reg1;
logic signed [WIDTH-1:0] sine_reg1;
logic signed [WIDTH-1:0] cosine_delay_reg1;
logic signed [WIDTH-1:0] sine_delay_reg1;

logic signed [WIDTH-1:0] cosine_reg2;
logic signed [WIDTH-1:0] sine_reg2;
logic signed [WIDTH-1:0] cosine_delay_reg2;
logic signed [WIDTH-1:0] sine_delay_reg2;

always_ff @ (posedge i_clock) begin
    if (i_ready == 1'b1) begin
        // Pipeline Stage 1
        cosine_reg1 <= cosine_reg0;
        sine_reg1 <= sine_reg0;
        cosine_delay_reg1 <= cosine_delay_reg0;
        sine_delay_reg1 <= sine_delay_reg0;

        // Pipeline Stage 2
        cosine_reg2 <= cosine_reg1;
        sine_reg2 <= sine_reg1;
        cosine_delay_reg2 <= cosine_delay_reg1;
        sine_delay_reg2 <= sine_delay_reg1;

        // Pipeline Stage 3
        o_cosine_data <= cosine_reg2;
        o_sine_data <= sine_reg2;
        o_cosine_delay_data <= cosine_delay_reg2;
        o_sine_delay_data <= sine_delay_reg2;
    end
end

endmodule: ddc_ddsx2

`default_nettype wire
