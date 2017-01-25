`timescale 10ps / 10ps

`default_nettype none

module ebr_ram #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 1024
) (
    // Address + Data interface for input stream
    input  wire logic [WIDTH-1:0]         i_in_data,
    input  wire logic [$clog2(DEPTH)-1:0] i_in_addr,
    input  wire logic                     i_in_valid,
    // Address interface for output stream
    input  wire logic [$clog2(DEPTH)-1:0] i_out_addr,
    input  wire logic                     i_out_addr_valid,
    output      logic                     o_out_addr_ready,
    // Data interface for output stream
    output      logic [WIDTH-1:0]         o_out_data,
    output      logic                     o_out_valid,
    input  wire logic                     i_out_ready,
    input  wire logic                     i_clock,
    input  wire logic                     i_reset
);

logic [WIDTH-1:0] buffer [0:DEPTH-1] /* synthesis syn_ramstyle="block_ram" */;

// Read into buffer
always_ff @(posedge i_clock) begin
    if (i_in_valid == 1'b1) begin
        buffer[i_in_addr] <= i_in_data;
    end
end

// Unregistered read out from buffer
logic [WIDTH-1:0] out_data_reg;
logic             out_data_valid_reg;
always_ff @(posedge i_clock) begin
    if (i_out_addr_valid == 1'b1) begin
        out_data_reg <= buffer[i_out_addr];
    end
    out_data_valid_reg <= (i_out_addr_valid == 1'b1)
        && (o_out_addr_ready == 1'b1);
end

// DON'T TOUCH unless you fix the decoder case statements
localparam integer MAX_SKID = 4;
logic [$clog2(MAX_SKID):0]   front_skid_count;
logic [$clog2(MAX_SKID):0]   back_skid_count;
logic [MAX_SKID*WIDTH-1:0]   skid_data;
logic [$clog2(MAX_SKID)-1:0] in_count;
logic [$clog2(MAX_SKID)-1:0] out_count;

always_ff @ (posedge i_clock) begin
    if (i_reset == 1'b1) begin
        o_out_addr_ready <= 1'b0;
        o_out_valid <= 1'b0;
        skid_data <= '0;
        front_skid_count <= 0;
        back_skid_count <= 0;
        in_count <= 0;
        out_count <= 0;
    end else begin
        // Front Skid Counter
        case ({ i_out_addr_valid, o_out_addr_ready, o_out_valid, i_out_ready })
        4'b1100, 4'b1110, 4'b1101: begin
            // If we've filled the buffer, then halt the input
            if (front_skid_count == MAX_SKID - 1) begin
                o_out_addr_ready <= 1'b0;
            end else begin
                o_out_addr_ready <= 1'b1;
            end
            // Increment skid count
            front_skid_count <= front_skid_count + 1;
        end
        4'b0011, 4'b1011, 4'b0111: begin
            // Something left, nothing entered, there is room in the buffer
            o_out_addr_ready <= 1'b1;
            // Decrement skid count
            front_skid_count <= front_skid_count - 1;
        end
        default: begin
            // If the buffer is full then halt the input
            if (front_skid_count >= MAX_SKID) begin
                o_out_addr_ready <= 1'b0;
            end else begin
                o_out_addr_ready <= 1'b1;
            end
        end
        endcase

        // Back Skid Counter
        case ({ out_data_valid_reg, o_out_valid, i_out_ready })
        4'b100, 4'b110, 4'b101: begin
            // Something entered, nothing left, there is something in the buffer
            o_out_valid <= 1'b1;
            // Increment skid count
            back_skid_count <= back_skid_count + 1;
        end
        4'b011: begin
            if (back_skid_count == 1) begin
                o_out_valid <= 1'b0;
            end else begin
                o_out_valid <= 1'b0;
            end
            // Decrement skid count
            back_skid_count <= back_skid_count - 1;
        end
        default: begin
            // If the buffer is full then halt the input
            if (back_skid_count == 0) begin
                o_out_valid <= 1'b0;
            end else begin
                o_out_valid <= 1'b1;
            end
        end
        endcase

        if (out_data_valid_reg == 1'b1) begin
            case(in_count)
            0:       skid_data[WIDTH-1:0] <= out_data_reg;
            1:       skid_data[2*WIDTH-1:WIDTH] <= out_data_reg;
            2:       skid_data[3*WIDTH-1:2*WIDTH] <= out_data_reg;
            default: skid_data[4*WIDTH-1:3*WIDTH] <= out_data_reg;
            endcase

            if (in_count == MAX_SKID - 1) begin
                in_count <= 0;
            end else begin
                in_count <= in_count + 1;
            end
        end

        if ((o_out_valid == 1'b1) && (i_out_ready == 1'b1)) begin
            if (out_count == MAX_SKID - 1) begin
                out_count <= 0;
            end else begin
                out_count <= out_count + 1;
            end
        end
    end
end

logic [WIDTH-1:0] out_data_buf;

always_comb begin
    case(out_count)
    0:       out_data_buf = skid_data[WIDTH-1:0];
    1:       out_data_buf = skid_data[2*WIDTH-1:WIDTH];
    2:       out_data_buf = skid_data[3*WIDTH-1:2*WIDTH];
    default: out_data_buf = skid_data[4*WIDTH-1:3*WIDTH];
    endcase
end

assign o_out_data = out_data_buf;

endmodule: ebr_ram

`default_nettype wire
