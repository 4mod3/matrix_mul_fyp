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
    parameter D_WIDTH = 64,
    parameter A_NUM_WIDTH = 1, // S_i width
    // parameter A_NUM = 1; // S_i
    parameter A_PART_WIDTH = 1, // S_i/P width
    parameter A_PART = 1, // S_i/P
    parameter B_NUM_WIDTH = 1, // S_j width
    // parameter B_NUM = 1; // S_j
    parameter PID = 0
)
(
    input logic clk,
    input logic rst,
    output logic [D_WIDTH-1 : 0] data_A_out,
    output logic [D_WIDTH-1 : 0] data_B_out,
    output logic valid_AB_out,

    // FIFOA port
    // from the-previous
    input logic [D_WIDTH-1 : 0] data_A_FIFO_in,
    input logic valid_A_FIFO_in, // high-available(!almost_empty)
    // output logic RD_EN_A_FIFO_out,
    output logic PASS_EN_A_FIFO_out,
    // to the-behind
    // output logic [D_WIDTH-1 : 0] data_A_FIFO_out,
    // output logic valid_A_FIFO_out,
    // input logic RD_EN_A_FIFO_in,
    // output logic WR_EN_A_FIFO_out,

    // FIFOB port
    //from the-previous
    input logic [D_WIDTH-1 : 0] data_B_FIFO_in,
    input logic valid_B_FIFO_in,
    // output logic RD_EN_B_FIFO_out,
    output logic PASS_EN_B_FIFO_out
    // to the-behind
    // output logic [D_WIDTH-1 : 0] data_B_FIFO_out,
    // output logic valid_B_FIFO_out,
    // input logic RD_EN_B_FIFO_in
);

//-------------------------------------------------
//  Load Valid Control
//-------------------------------------------------
logic TA_0_valid = 0;
logic TA_1_valid = 0;
logic load_valid_index = 0;
wire load_valid_next;
logic read_valid_next;
logic load_valid;
logic read_valid;

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
assign read_valid = load_valid_index?TA_0_valid:TA_1_valid;


//-------------------------------------------------
//  Load A
//-------------------------------------------------
// *** variable defination ***
//stage 1
logic load_flag = 0;
logic flush_flag;
//stage 2
logic [D_WIDTH-1 : 0] data_A_stg_2 = '0;
logic [A_NUM_WIDTH-1 : 0] count_A = '0;
logic [A_PART_WIDTH-1 : 0] load_address = '0;
logic load_flag_stg_2 = 0;
logic WR_EN_RAM_A_reg = 0;
wire WR_EN_RAM_A;

// *** procedure defination ***
// stage 1
always_ff @( posedge clk or posedge rst ) begin : load_A_stg_1
    if(rst || flush_flag)begin
        load_flag <= 0;
    end
    else begin
        load_flag <= ~(load_valid_next || valid_A_FIFO_in);
    end
end

//stage 2
assign PASS_EN_A_FIFO_out = load_flag;
always_ff @( posedge clk or posedge rst ) begin : load_A_stg_2
    if(rst)begin
        load_flag_stg_2 <= 0;
        data_A_stg_2 <= '0;
        count_A <= '0;
        load_address <= '0;
        WR_EN_RAM_A_reg <= 0;
    end
    else begin
        load_flag_stg_2 <= load_flag;
        data_A_stg_2 <= data_A_FIFO_in;
        // count A ++ (prefer 2^n)
        if(load_flag)begin
            count_A <= count_A + 1'b1;
        end else begin
            count_A <= count_A;
        end

        // range check
        if(count_A >= PID * A_PART && count_A < (PID+1) * A_PART)begin
            load_address <= count_A - PID * A_PART;
            WR_EN_RAM_A_reg <= 1'b1;
        end else begin
            load_address <= load_address;
            WR_EN_RAM_A_reg <= 1'b0;
        end
    end
end

// stage 3
// assign WR_EN_A_FIFO_out = load_flag_stg_2;
// assign data_A_FIFO_out = data_A_stg_2;

assign WR_EN_RAM_A = load_flag_stg_2 ? WR_EN_RAM_A_reg : 0;

sdp_sram #(
    .WR_ADDR_WTH(A_PART_WIDTH + 1),
    .WR_DATA_WTH(D_WIDTH),
    .RD_ADDR_WTH(A_PART_WIDTH + 1),
    .RD_DATA_WTH(D_WIDTH),
    .RD_DELAY(2)
) sram_inst(
    .wr_clk_i(clk),
    .we_i(WR_EN_RAM_A),
    .waddr_i({load_valid_index, load_address}),
    .wdata_i(data_A_stg_2),
    .rd_clk_i(clk),
    .re_i(read_valid),
    .raddr_i({~load_valid_index, pipe_out_index}),
    .rdata_o(data_A_out)
);

// always_comb begin : update_load_valid
//     if(load_flag && (~count_A == 0))begin
//         load_valid_next = 1'b1; 
//     end else begin
//         load_valid_next = load_valid;
//     end
// end
assign load_valid_next = (load_flag && (~count_A == '0))?1'b1:load_valid;

// flush
always_comb begin : flush_block
    if(load_flag && (~count_A == '0))begin
        flush_flag = 1'b1;
    end else begin
        flush_flag = 1'b0;
    end
end


//-------------------------------------------------
//  Pipe out A and Load B
//-------------------------------------------------
logic [A_PART_WIDTH-1 : 0] pipe_out_index = '0;
logic [B_NUM_WIDTH-1 : 0] count_B = '0;
logic [D_WIDTH-1 :0] data_B_stg_1 = '0;
// logic [D_WIDTH-1 :0] data_B_stg_2 = '0;
logic B_valid_flag = 0;
logic load_valid_index_next;
logic pipe_out_index_rst;
logic count_B_ctl_from_valid;
logic valid_AB_stg_1 = 0;
logic count_B_ctl;
logic halt_flag;
// logic valid_AB_stg_2 = 0;


always_ff @( posedge clk or posedge rst ) begin : index_block
    if(rst)begin
        pipe_out_index <= '0;
        valid_AB_stg_1 <= '0;
        valid_AB_out <= '0;
    end else begin
        if(read_valid && !pipe_out_index_rst)begin
            pipe_out_index <= pipe_out_index + 1'b1;
        end else begin
            pipe_out_index <= pipe_out_index;
        end

        valid_AB_stg_1 <= read_valid && B_valid_flag;
        // valid_AB_stg_2 <= valid_AB_stg_1;
        valid_AB_out <= valid_AB_stg_1;
    end
end

always_comb begin : B_update_block
    // if((~pipe_out_index == 0) && (~count_B == 0))begin
    //     read_valid_next = 0;
    //     pipe_out_index_rst = ~load_valid;
    //     count_B_ctl_from_valid = load_valid;
    // end 
    // else if(~pipe_out_index == 0)begin
    //     read_valid_next = read_valid;
    //     pipe_out_index_rst = 0;
    //     count_B_ctl_from_valid = read_valid;
    // end else begin
    //     read_valid_next = read_valid;
    //     pipe_out_index_rst = 0;
    //     count_B_ctl_from_valid = read_valid;
    // end

    if(~pipe_out_index == '0)begin
        if(~count_B == '0)begin
            // update A and B
            read_valid_next = 0;
            pipe_out_index_rst = ~load_valid;
            count_B_ctl_from_valid = load_valid;
            load_valid_index_next = load_valid?(~load_valid_index):load_valid_index;
            halt_flag = (!load_valid) && read_valid;
        end else begin
            // update B only
            read_valid_next = read_valid;
            count_B_ctl_from_valid = read_valid;
            pipe_out_index_rst = 0;
            load_valid_index_next = load_valid_index;
            halt_flag = 0;
        end
    end else begin
        // rolling
        read_valid_next = read_valid;
        count_B_ctl_from_valid = 0;
        pipe_out_index_rst = 0;
        load_valid_index_next = (load_valid && (~read_valid))?(~load_valid_index):load_valid_index;
        halt_flag = 0;
    end
    
    // load_valid_index_next = (pipe_out_index_rst && (~pipe_out_index == 0))?load_valid_index:(~load_valid_index);
    count_B_ctl = valid_B_FIFO_in?count_B_ctl_from_valid:0;
end

assign PASS_EN_B_FIFO_out = halt_flag?1'b1:count_B_ctl;

always_ff @( posedge clk or posedge rst ) begin : B_control_block
    if(rst)begin
        count_B <= '0;
        data_B_stg_1 <= '0;
        data_B_out <= '0;
    end else begin
        count_B <= count_B_ctl?(count_B + 1):count_B;
        if(count_B_ctl || (valid_B_FIFO_in && load_valid && (~read_valid)))begin
            B_valid_flag <= 1'b1;
        end else begin
            B_valid_flag <= (~pipe_out_index == '0)?0:B_valid_flag;
        end
        load_valid_index <= load_valid_index_next;

        // clk delay
        data_B_stg_1 <= data_B_FIFO_in;
        data_B_out <= data_B_stg_1;
    end
end

endmodule
