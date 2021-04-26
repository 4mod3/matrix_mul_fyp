`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2021 11:29:35 PM
// Design Name: 
// Module Name: Load
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module load_AB
#(
    parameter D_WIDTH = 64;
    parameter A_NUM_WIDTH = 1; // S_i width
    parameter PE_NUM_WIDTH = 1; // S_i/P width
    parameter PE_NUM = 1; // S_i/P
    parameter B_NUM_WIDTH = 1; // S_j width
    parameter PID = 0;
)
(
    input logic clk,
    input logic rst,
    output logic [D_WIDTH-1 : 0] data_A_out,
    output logic [D_WIDTH-1 : 0] data_B_out,
    output logic valid_AB_out,

    // FIFOA port
    input logic [D_WIDTH-1 : 0] data_A_FIFO_in,
    input logic valid_A_FIFO_in, // high-available(!almost_empty)
    output logic RD_EN_A_FIFO_out,
    output logic [D_WIDTH-1 : 0] data_A_FIFO_out,
    output logic WR_EN_A_FIFO_out,

    // FIFOB port
    input logic [D_WIDTH-1 : 0] data_B_FIFO_in,
    input logic valid_B_FIFO_in,
    output logic RD_EN_B_FIFO_out,
    output logic [D_WIDTH-1 : 0] data_B_FIFO_out,
    output logic WR_EN_B_FIFO_out
);

//-------------------------------------------------
//  Load Valid Control
//-------------------------------------------------
logic TA_0_valid = 0;
logic TA_1_valid = 0;
logic load_valid_index = 0;
wire load_valid_next;
wire load_valid_next;
wire load_valid;
wire read_valid;

always_ff @( posedge clk or posedge rst ) begin : update
    if(rst)begin
        TA_0_valid <= 0;
        TA_1_valid <= 0;
    end
    else if(load_valid_index == 1'b0)begin
        TA_0_valid <= load_valid_next;
        TA_1_valid <= read_valid_next;
    end
    else begin
        TA_0_valid <= read_valid_next;
        TA_1_valid <= load_valid_next;
    end
    // 高阻态？
end

assign load_valid = load_valid_index?TA_1_valid:TA_0_valid;
assign read_valid = load_valid_index?TA0_valid:TA_1_valid;


//-------------------------------------------------
//  Load A
//-------------------------------------------------
// *** variable defination ***
//stage 1
logic load_flag = 0；
logic flush_flag = 0;
//stage 2
logic [D_WIDTH-1 : 0] data_A_stg_2 = '0;
logic [A_NUM_WIDTH-1 : 0] count_A = '0;
logic [PE_NUM_WIDTH-1 : 0] load_address = '0;
logic WR_EN_A_FIFO_stg_2 = 0;
logic WR_EN_RAM_A_reg = 0;
wire WR_EN_RAM_A;

// *** procedure defination ***
// stage 1
always_ff @( posedge clk or posedge rst ) begin : load_A_stg_1
    if(rst || flush_flag)begin
        load_flag <= 0;
    end
    else begin
        load_flag <= ~(load_valid || valid_A_FIFO_in);
    end
end

//stage 2
assign RD_EN_A_FIFO_out = load_flag;
always_ff @( posedge clk or posedge rst ) begin : load_A_stg_1
    if(rst)begin
        WR_EN_B_FIFO_stg_2 <= 0;
        data_A_stg_2 <= '0;
        count_A <= '0;
        load_address <= '0;
        WR_EN_RAM_A_reg <= 0;
    end
    else begin
        WR_EN_A_FIFO_stg_2 <= load_flag;
        // count A ++
        if(load_flag)begin
            count_A <= count_A + 1'b1;
        end else begin
            count_A <= count_A;
        end

        // range check
        if(count_A >= PID * PE_NUM && count_A < (PID+1) * PE_NUM)begin
            load_address <= count_A - PID * PE_NUM;
            WR_EN_RAM_A_reg <= 1'b1;
        end else begin
            load_address <= load_address;
            WR_EN_RAM_A_reg <= 1'b0;
        end
    end
end

// stage 3
assign WR_EN_A_FIFO_out = WR_EN_A_FIFO_stg_2;
assign WR_EN_RAM_A = WR_EN_A_FIFO_stg_2 ? WR_EN_RAM_A_reg : 0;

// TODO:BRAM Instant




endmodule
