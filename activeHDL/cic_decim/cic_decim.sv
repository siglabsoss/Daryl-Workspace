`timescale 10ps / 10ps

`default_nettype none

module cic_decim #(
    parameter integer WIDTH = 16,
    parameter integer FACTOR = 313,
    parameter integer DELAY = 2,
    parameter integer STAGES = 5
) (
    input  wire logic [WIDTH-1:0] i_inph_data,
    input  wire logic [WIDTH-1:0] i_quad_data,
    input  wire logic             i_valid,
    output      logic [WIDTH-1:0] o_inph_data,
    output      logic [WIDTH-1:0] o_quad_data,
    output      logic             o_valid,
    input  wire logic             i_clock,
    input  wire logic             i_reset
);

wire [(STAGES+1)*WIDTH-1:0] inph_integ_data;
wire [(STAGES+1)*WIDTH-1:0] quad_integ_data;
wire [STAGES:0]             integ_valids;

logic [WIDTH-1:0] sample_inph;
logic [WIDTH-1:0] sample_quad;
logic             sample_valid;

genvar stage;
generate

assign inph_integ_data[WIDTH-1:0] = i_inph_data;
assign quad_integ_data[WIDTH-1:0] = i_quad_data;
assign integ_valids[0] = i_valid;

for(stage = 0; stage < STAGES; stage++) begin
    cic_integrator #(
        .WIDTH(WIDTH))
    cic_integrator_inst (
        .i_inph_data(inph_integ_data[(stage+1)*WIDTH-1-:WIDTH]),
        .i_quad_data(quad_integ_data[(stage+1)*WIDTH-1-:WIDTH]),
        .i_valid    (integ_valids[stage]                      ),
        .o_inph_data(inph_integ_data[(stage+2)*WIDTH-1-:WIDTH]),
        .o_quad_data(quad_integ_data[(stage+2)*WIDTH-1-:WIDTH]),
        .o_valid    (integ_valids[stage+1]                    ),
        .i_clock    (i_clock                                  ),
        .i_reset    (i_reset                                  ));
end
endgenerate

logic [$clog2(FACTOR)-1:0] upsample_counter;

always_ff @(posedge i_clock) begin
    if(i_reset == 1'b1) begin
        upsample_counter <= '0;
        sample_inph <= '0;
        sample_quad <= '0;
        sample_valid <= 1'b0;
    end else begin
        if (integ_valids[STAGES] == 1'b1) begin
            if (upsample_counter == FACTOR-1) begin
                upsample_counter <= '0;
                sample_inph <= inph_integ_data[(STAGES+1)*WIDTH-1-:WIDTH];
                sample_quad <= quad_integ_data[(STAGES+1)*WIDTH-1-:WIDTH];
                sample_valid <= 1'b1;
            end else begin
                upsample_counter <= upsample_counter + 1;
                sample_valid <= 1'b0;
            end
        end else begin
            sample_valid <= 1'b0;
        end
    end
end

wire [(STAGES+1)*WIDTH-1:0] inph_comb_data;
wire [(STAGES+1)*WIDTH-1:0] quad_comb_data;
wire [STAGES:0]             comb_valids;
generate

assign inph_comb_data[WIDTH-1:0] = sample_inph;
assign quad_comb_data[WIDTH-1:0] = sample_quad;
assign comb_valids[0] = sample_valid;

for(stage = 0; stage < STAGES; stage++) begin
    cic_comb #(
        .WIDTH(WIDTH),
        .DELAY(DELAY))
    cic_comb_inst (
        .i_inph_data(inph_comb_data[(stage+1)*WIDTH-1-:WIDTH]),
        .i_quad_data(quad_comb_data[(stage+1)*WIDTH-1-:WIDTH]),
        .i_valid    (comb_valids[stage]                    ),
        .o_inph_data(inph_comb_data[(stage+2)*WIDTH-1-:WIDTH]),
        .o_quad_data(quad_comb_data[(stage+2)*WIDTH-1-:WIDTH]),
        .o_valid    (comb_valids[stage+1]                    ),
        .i_clock    (i_clock                                 ),
        .i_reset    (i_reset                                 ));
end
endgenerate

assign o_inph_data = inph_comb_data[(STAGES+1)*WIDTH-1-:WIDTH];
assign o_quad_data = quad_comb_data[(STAGES+1)*WIDTH-1-:WIDTH];
assign o_valid = comb_valids[STAGES];

endmodule: cic_decim

`default_nettype wire
