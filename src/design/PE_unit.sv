`timescale 1ns / 1ps

module PE_unit #(
    parameter D_WIDTH = 64,
    parameter A_NUM_WIDTH = 1,
    parameter A_PART_WIDTH = 1,
    parameter B_NUM_WIDTH = 1,
    parameter PID = 0,
    parameter N_MAX_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    
    // A PE in
    input logic [D_WIDTH-1 : 0] data_A_PE_in,
    input logic PASS_EN_A_PE_in,
    // A PE out
    output logic [D_WIDTH-1 : 0] data_A_PE_out,
    output logic PASS_EN_A_PE_out,
    // B PE in
    input logic [D_WIDTH-1 : 0] data_B_PE_in,
    input logic PASS_EN_B_PE_in,
    // B PE out
    output logic [D_WIDTH-1 : 0] data_B_PE_out,
    output logic PASS_EN_B_PE_out,

    // N
    input logic [N_MAX_WIDTH-1 : 0] N_in,
    // write out ports
    input logic res_clk,
    input logic res_rd_en_in,
    input logic [A_PART_WIDTH + B_NUM_WIDTH-1 : 0] res_rd_addr_in,
    output logic [D_WIDTH-1 : 0] res_rd_data_out,
    output logic output_trigger_out
);

localparam A_NUM = (1 << A_NUM_WIDTH);

// FIFO - load AB
logic valid_A_FIFO;
logic valid_B_FIFO;
logic empty_B_FIFO;

// load AB - MAC pipeline
logic [D_WIDTH-1 : 0] data_A_load_out;
logic [D_WIDTH-1 : 0] data_B_load_out;
logic valid_AB_load_out;

// MAC - control C
logic load_valid;
logic store_valid;
logic error_flag;
logic [D_WIDTH-1 : 0] store_data;
logic [D_WIDTH-1 : 0] load_data;

sync_fifo #(
    .FIFO_LEN((A_NUM<<8)),
    .DATA_WTH(D_WIDTH),
    .ADDR_WTH(A_NUM_WIDTH+8),
    .EMPTY_NEGATE_VALUE(1)
) fifo_A_inst (
    .clk_i(clk),
    .rst_i(rst),
    .wr_data_i(data_A_PE_in),
    .wr_en_i(PASS_EN_A_PE_in),
    .rd_data_o(data_A_PE_out),
    .rd_en_i(PASS_EN_A_PE_out),
    .a_empty_o(valid_A_FIFO)
);

sync_fifo #(
    .FIFO_LEN((A_NUM<<8)),
    .DATA_WTH(D_WIDTH),
    .ADDR_WTH(A_NUM_WIDTH+8),
    .EMPTY_NEGATE_VALUE(1)
) fifo_B_inst (
    .clk_i(clk),
    .rst_i(rst),
    .wr_data_i(data_B_PE_in),
    .wr_en_i(PASS_EN_B_PE_in),
    .rd_data_o(data_B_PE_out),
    .rd_en_i(PASS_EN_B_PE_out),
    .a_empty_o(valid_B_FIFO),
    .empty_o(empty_B_FIFO)
);

load_AB #(
    .D_WIDTH(D_WIDTH),
    .A_NUM_WIDTH(A_NUM_WIDTH),
    .A_PART_WIDTH(A_PART_WIDTH),
    .B_NUM_WIDTH(B_NUM_WIDTH),
    .PID(PID)
) load_AB_inst (
    .clk,
    .rst,
    .data_A_out(data_A_load_out),
    .data_B_out(data_B_load_out),
    .valid_AB_out(valid_AB_load_out),

    .data_A_FIFO_in(data_A_PE_out),
    .valid_A_FIFO_in(valid_A_FIFO),
    .PASS_EN_A_FIFO_out(PASS_EN_A_PE_out),

    .data_B_FIFO_in(data_B_PE_out),
    .valid_B_FIFO_in(~valid_B_FIFO),
    .empty_B_FIFO_in(empty_B_FIFO),
    .PASS_EN_B_FIFO_out(PASS_EN_B_PE_out)
);

// 64 bit floating-point MAC
MAC_pipeline MAC_pipeline_inst(
    .clk,
    .rst,
    .valid_in(valid_AB_load_out),
    .TA_in(data_A_load_out),
    .TB_in(data_B_load_out),

    .C_in(load_data),
    .res_out(store_data),
    .load_valid(load_valid),
    .store_valid(store_valid),
    .error_flag(error_flag)
);

control_C #(
    .D_WIDTH(64),
    .A_PART_WIDTH(A_PART_WIDTH),
    .B_NUM_WIDTH(B_NUM_WIDTH),
    .N_MAX_WIDTH(N_MAX_WIDTH)
) control_C_inst (
    .clk,
    .rst,
    .load_pos_bit_in(load_valid),
    .store_pos_bit_in(store_valid),
    .wr_data_in(store_data),
    .rd_data_out(load_data),
    .N_in,
    .*
);

endmodule
