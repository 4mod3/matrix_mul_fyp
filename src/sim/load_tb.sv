`timescale 1ns / 1ps

module load_tb;

reg clk;
reg rst;
parameter CLK_PERIOD = 10;
// Si=8, P=2, Sj=8
logic [63:0] A [15:0];
logic [63:0] B [15:0];
// gen DATA
logic [63:0] A_in;
bit A_IN_WR_EN;
logic [63:0] B_in;
bit B_IN_WR_EN;
// def module port
logic A_valid;
logic B_valid;
logic [63:0] A_FIFO_out;
logic [63:0] B_FIFO_out;
logic A_rd_en;
logic B_rd_en;
logic [63:0] A_MAC_in;
logic [63:0] B_MAC_in;
logic valid_MAC_in;

logic temp;
assign temp = (~3'b111 == '0);

initial begin
    clk = 0;
    rst = 1'b1;
    # 10;
    rst = 0;
    for(int i=0; i<16; i++)begin
        A_in = i;
        A_IN_WR_EN = 1;
        B_in = i;
        B_IN_WR_EN = 1;
        # 10;
    end
    A_IN_WR_EN = 0;
    B_IN_WR_EN = 0;
    # 1000;
    $finish;
end

initial begin
    $dumpfile("load_wave.vcd");
    $dumpvars(0,load_tb);
end

sync_fifo #(
    .FIFO_LEN(16),
    .DATA_WTH(64),
    .ADDR_WTH(4),
    .EMPTY_ASSERT_VALUE(1)
) fifo_A_inst (
    .clk_i(clk),
    .rst_i(rst),
    .wr_data_i(A_in),
    .wr_en_i(A_IN_WR_EN),
    .rd_data_o(A_FIFO_out),
    .rd_en_i(A_rd_en),
    .a_empty_o(A_valid)
);

sync_fifo #(
    .FIFO_LEN(16),
    .DATA_WTH(64),
    .ADDR_WTH(4),
    .EMPTY_ASSERT_VALUE(1)
) fifo_B_inst (
    .clk_i(clk),
    .rst_i(rst),
    .wr_data_i(B_in),
    .wr_en_i(B_IN_WR_EN),
    .rd_data_o(B_FIFO_out),
    .rd_en_i(B_rd_en),
    .a_empty_o(B_valid)
);

load_AB #(
    .A_NUM_WIDTH(3),
    .A_PART(4),
    .A_PART_WIDTH(2),
    .B_NUM_WIDTH(3),
    .PID(0)
) load_inst (
    .clk,
    .rst,
    .data_A_out(A_MAC_in),
    .data_B_out(B_MAC_in),
    .valid_AB_out(valid_MAC_in),

    .data_A_FIFO_in(A_FIFO_out),
    .valid_A_FIFO_in(A_valid),
    .PASS_EN_A_FIFO_out(A_rd_en),

    .data_B_FIFO_in(B_FIFO_out),
    .valid_B_FIFO_in(~B_valid),
    .PASS_EN_B_FIFO_out(B_rd_en)
);

always #(CLK_PERIOD/2) clk = ~clk;

endmodule