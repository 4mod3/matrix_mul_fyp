`timescale 1ns / 1ps

module top #(
    parameter D_WIDTH = 64,
    parameter PE_NUM_WIDTH = 1,
    parameter A_NUM_WIDTH = 3,
    parameter B_NUM_WIDTH = 3,
    parameter N_MAX_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic [D_WIDTH-1 : 0] A_in,
    input logic A_valid_in,
    input logic [D_WIDTH-1 : 0] B_in,
    input logic B_valid_in,
    input logic [N_MAX_WIDTH-1 : 0] N_in
);

localparam PE_NUM = (1<<PE_NUM_WIDTH);
localparam PE_SRAM_ADDR_WIDTH = A_NUM_WIDTH-PE_NUM_WIDTH+B_NUM_WIDTH;

// ------------------------------------------------------------------
// PE moduel instant
wire [PE_NUM : 0] [D_WIDTH-1 : 0] data_A_;
wire [PE_NUM : 0] [D_WIDTH-1 : 0] data_B_;
wire [PE_NUM : 0] PASS_EN_A_;
wire [PE_NUM : 0] PASS_EN_B_;

wire [PE_NUM-1 : 0] res_rd_en_;
wire [PE_NUM-1 : 0] [PE_SRAM_ADDR_WIDTH-1 : 0] res_rd_addr_;
wire [PE_NUM-1 : 0] [D_WIDTH-1 : 0] res_rd_data_;
wire [PE_NUM-1 : 0] output_trigger_;

assign data_A_[0] = A_in;
assign PASS_EN_A_[0] = A_valid_in;
assign data_B_[0] = B_in;
assign PASS_EN_B_[0] = B_valid_in;

genvar i;
for(i=0; i<PE_NUM; i++) begin: PE_gen_block
    read_out_trigger #(
        .D_WIDTH(D_WIDTH),
        .ADDR_WIDTH(PE_SRAM_ADDR_WIDTH)
    ) c_out_tgr (
        .clk, // adopt the top-clock
        .rst,
        .output_trigger_in(output_trigger_[i]),
        .res_rd_en_out(res_rd_en_[i]),
        .res_rd_addr_out(res_rd_addr_[i])
    );

    PE_unit #(
        .D_WIDTH(D_WIDTH),
        .A_NUM_WIDTH(A_NUM_WIDTH),
        .A_PART_WIDTH(A_NUM_WIDTH - PE_NUM_WIDTH),
        .B_NUM_WIDTH(B_NUM_WIDTH),
        .PID(i),
        .N_MAX_WIDTH(N_MAX_WIDTH)
    ) PE_inst (
        .clk,
        .rst,
        .data_A_PE_in(data_A_[i]),
        .PASS_EN_A_PE_in(PASS_EN_A_[i]),
        .data_B_PE_in(data_B_[i]),
        .PASS_EN_B_PE_in(PASS_EN_B_[i]),
        .N_in(N_in),

        .data_A_PE_out(data_A_[i+1]),
        .PASS_EN_A_PE_out(PASS_EN_A_[i+1]),
        .data_B_PE_out(data_B_[i+1]),
        .PASS_EN_B_PE_out(PASS_EN_B_[i+1]),

        .res_clk(clk),
        .res_rd_en_in(res_rd_en_[i]),
        .res_rd_addr_in(res_rd_addr_[i]),
        .res_rd_data_out(res_rd_data_[i]),
        .output_trigger_out(output_trigger_[i])
    );
end
    
endmodule