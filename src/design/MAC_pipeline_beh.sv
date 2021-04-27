`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2021 03:41:33 PM
// Design Name: 
// Module Name: MAC_pipeline
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


module MAC_pipeline(
    input logic clk,
    input bit valid_in,
    input logic [63:0] TA_in,
    input logic [63:0] TB_in,
    input logic [63:0] C_in,
    output logic [63:0] res_out,
    // output MAB_mul_res_signed,
    output bit load_valid,
    output bit store_valid,
    output bit error_flag = 0
    );

// -----------------
// Valid Shift Queue
// totally 11 stages
// -----------------
logic [10:0] valid_shift_queue = '0;
assign load_valid = valid_shift_queue[10];
assign store_valid = valid_shift_queue[0];

always_ff @( posedge clk ) begin : valid_queue_in
    valid_shift_queue[10] <= valid_in;
    valid_shift_queue[9:0] <= valid_shift_queue[10:1];
end

// -----------------
// stage 1 
// add exponents and handle partial stage of Mantissas multiplication 
// -----------------

logic [10:0] EAB_stg_1;
logic [8:0] [33:0] mult_out_stg_2 = '0;
logic [1:0] [54:0] glue_logic_out_stg_1  = '0;
bit sign_stg_1;
bit error_flag_stg_1 = 0;

always_ff @( posedge clk ) begin : EAB_gen
    EAB_stg_1 <= TA_in[62 -: 11] + TB_in[62 -: 11] - 11'b01111111111;
    if({1'b0,TA_in[62 -: 11]} + {1'b0,TB_in[62 -: 11]} < 12'b001111111111 || 
        {1'b0,TA_in[62-:11]} + {1'b0,TB_in[62-:11]} > (12'b011111111111 + 12'b001111111111))begin
        error_flag_stg_1 <= 1 & valid_in;
    end
    else begin
        error_flag_stg_1 <= 0;
    end

    // pass sign
    sign_stg_1 <= TA_in[63] ^ TB_in[63];
end

always_ff @( posedge clk ) begin : glue_logic_stg_1
    glue_logic_out_stg_1[0] <= {1'b1, TA_in[51:0]} * {1'b1, TB_in[51]};
    glue_logic_out_stg_1[1] <= {TB_in[50:0]} * {1'b1, TA_in[51]};
end

// mult_gen_0 mult_18_Inst_AlBl (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[16 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[16 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[0])      // output wire [33 : 0] P
// );
// mult_gen_0 mult_18_Inst_AlBm (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[16 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[33 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[1])      // output wire [33 : 0] P
// );
// mult_gen_0 mult_18_Inst_AmBl (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[33 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[16 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[2])      // output wire [33 : 0] P
// );
// mult_gen_0 mult_18_Inst_AlBh (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[16 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[50 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[3])      // output wire [33 : 0] P
// );
// mult_gen_0 mult_18_Inst_AmBm (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[33 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[33 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[4])      // output wire [33 : 0] P
// );
// mult_gen_0 mult_18_Inst_AhBl (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[50 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[16 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[5])      // output wire [33 : 0] P
// );
// mult_gen_0 mult_18_Inst_AhBm (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[50 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[33 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[6])      // output wire [33 : 0] P
// );
// mult_gen_0 mult_18_Inst_AmBh (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[33 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[50 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[7])      // output wire [33 : 0] P
// );
// mult_gen_0 mult_18_Inst_AhBh (
//   .CLK(clk),  // input wire CLK
//   .A(TA_in[50 -: 17]),      // input wire [16 : 0] A
//   .B(TB_in[50 -: 17]),      // input wire [16 : 0] B
//   .P(mult_out_stg_2[8])      // output wire [33 : 0] P
// );

always_ff @( posedge clk ) begin : mult_block
    mult_out_stg_2[0] <= TA_in[16 -: 17] * TB_in[16 -: 17];
    mult_out_stg_2[1] <= TA_in[16 -: 17] * TB_in[33 -: 17];
    mult_out_stg_2[2] <= TA_in[33 -: 17] * TB_in[16 -: 17];
    mult_out_stg_2[3] <= TA_in[16 -: 17] * TB_in[50 -: 17];
    mult_out_stg_2[4] <= TA_in[33 -: 17] * TB_in[33 -: 17];
    mult_out_stg_2[5] <= TA_in[50 -: 17] * TB_in[16 -: 17];
    mult_out_stg_2[6] <= TA_in[50 -: 17] * TB_in[33 -: 17];
    mult_out_stg_2[7] <= TA_in[33 -: 17] * TB_in[50 -: 17];
    mult_out_stg_2[8] <= TA_in[50 -: 17] * TB_in[50 -: 17];
end

// -----------------
// stage 2 
// Output the Mantissas multiplication partial result
// Load C
// -----------------

logic [7:0] [88:0] mult_partial_result_stg_2 = '0;
bit sign_stg_2;
logic [10:0] EAB_stg_2;
bit error_flag_stg_2 = 0;

always_ff @( posedge clk ) begin : glue_logic_stg_2
    mult_partial_result_stg_2[0][88 -: 55] <= glue_logic_out_stg_1[0];
    mult_partial_result_stg_2[0][33:0] <= '0;
    mult_partial_result_stg_2[1][88 -: 55] <= glue_logic_out_stg_1[1];
    mult_partial_result_stg_2[1][33:0] <= '0;

    // pass sign
    sign_stg_2 <= sign_stg_1;

    //pass EAB
    EAB_stg_2 <= EAB_stg_1;
    
    //pass error
    error_flag_stg_2 <= error_flag_stg_1;
end

always_ff @( posedge clk ) begin : mul_res_distru
    mult_partial_result_stg_2[2][17*1-1 -: 17] <= mult_out_stg_2[0]; // AlBl
    mult_partial_result_stg_2[2][17*5-1 -: 34] <= mult_out_stg_2[8]; // AhBh
    mult_partial_result_stg_2[2][88 : 17*5] <= '0;
    mult_partial_result_stg_2[2][17*3-1 -: 34] <= '0;

    mult_partial_result_stg_2[3][17*2-1 -: 34] <= mult_out_stg_2[1]; // AlBm
    mult_partial_result_stg_2[3][17*4-1 -: 34] <= mult_out_stg_2[6]; // AhBm
    mult_partial_result_stg_2[3][88 : 17*4] <= '0;
    
    mult_partial_result_stg_2[4][17*2-1 -: 34] <= mult_out_stg_2[2]; // AmBl
    mult_partial_result_stg_2[4][17*4-1 -: 34] <= mult_out_stg_2[7]; // AmBh
    mult_partial_result_stg_2[4][88 : 17*4] <= '0;

    mult_partial_result_stg_2[5][17*3-1 -: 34] <= mult_out_stg_2[3]; // AlBh
    mult_partial_result_stg_2[5][88 : 17*3] <= '0;
    mult_partial_result_stg_2[5][16 : 0] <= '0;

    mult_partial_result_stg_2[6][17*3-1 -: 34] <= mult_out_stg_2[4]; // AmBm
    mult_partial_result_stg_2[6][88 : 17*3] <= '0;
    mult_partial_result_stg_2[6][16 : 0] <= '0;

    mult_partial_result_stg_2[7][17*3-1 -: 34] <= mult_out_stg_2[5]; // AhBl
    mult_partial_result_stg_2[7][88 : 17*3] <= '0;
    mult_partial_result_stg_2[7][16 : 0] <= '0;
end

// Now it's time to Load C

// -----------------
// stage 3
// First level adder-tree 
// -----------------

//logic [88:0] adder_tree_level_0_res [3:0];
logic [88:0] adder_tree_level_0_reg [3:0];
logic [10:0] EAB_stg_3;
bit sign_stg_3;
bit error_flag_stg_3 = 0;

// c_addsub_0 adder_0_0 (
//   .A(mult_partial_result_stg_2[0]),  // input wire [88 : 0] A
//   .B(mult_partial_result_stg_2[1]),  // input wire [88 : 0] B
//   .S(adder_tree_level_0_res[0])  // output wire [88 : 0] S
// );

// c_addsub_0 adder_0_1 (
//   .A(mult_partial_result_stg_2[2]),  // input wire [88 : 0] A
//   .B(mult_partial_result_stg_2[3]),  // input wire [88 : 0] B
//   .S(adder_tree_level_0_res[1])  // output wire [88 : 0] S
// );

// c_addsub_0 adder_0_2 (
//   .A(mult_partial_result_stg_2[4]),  // input wire [88 : 0] A
//   .B(mult_partial_result_stg_2[5]),  // input wire [88 : 0] B
//   .S(adder_tree_level_0_res[2])  // output wire [88 : 0] S
// );

// c_addsub_0 adder_0_3 (
//   .A(mult_partial_result_stg_2[6]),  // input wire [88 : 0] A
//   .B(mult_partial_result_stg_2[7]),  // input wire [88 : 0] B
//   .S(adder_tree_level_0_res[3])  // output wire [88 : 0] S
// );

always_ff @( posedge clk ) begin : adder_tree_level_0

    // adder_tree_level_0_reg[0] <= adder_tree_level_0_res[0];
    // adder_tree_level_0_reg[1] <= adder_tree_level_0_res[1];
    // adder_tree_level_0_reg[2] <= adder_tree_level_0_res[2];
    // adder_tree_level_0_reg[3] <= adder_tree_level_0_res[3];

    adder_tree_level_0_reg[0] <= mult_partial_result_stg_2[0] + mult_partial_result_stg_2[1];
    adder_tree_level_0_reg[1] <= mult_partial_result_stg_2[2] + mult_partial_result_stg_2[3];
    adder_tree_level_0_reg[2] <= mult_partial_result_stg_2[4] + mult_partial_result_stg_2[5];
    adder_tree_level_0_reg[3] <= mult_partial_result_stg_2[6] + mult_partial_result_stg_2[7];

    //pass sign
    sign_stg_3 <= sign_stg_2;

    //pass EAB
    EAB_stg_3 <= EAB_stg_2;

    //pass error
    error_flag_stg_3 <= error_flag_stg_2;
end

// -----------------
// stage 4
// Second level adder-tree 
// -----------------

//logic [88:0] adder_tree_level_1_res[1:0];
logic [88:0] adder_tree_level_1_reg[1:0];
logic [10:0] EAB_stg_4;
bit sign_stg_4;
bit error_flag_stg_4 = 0;

// c_addsub_0 adder_1_0 (
//   .A(adder_tree_level_0_reg[0]),  // input wire [88 : 0] A
//   .B(adder_tree_level_0_reg[1]),  // input wire [88 : 0] B
//   .S(adder_tree_level_1_res[0])  // output wire [88 : 0] S
// );

// c_addsub_0 adder_1_1 (
//   .A(adder_tree_level_0_reg[2]),  // input wire [88 : 0] A
//   .B(adder_tree_level_0_reg[3]),  // input wire [88 : 0] B
//   .S(adder_tree_level_1_res[1])  // output wire [88 : 0] S
// );

always_ff @( posedge clk ) begin : adder_tree_level_1
    // adder_tree_level_1_reg[0] <= adder_tree_level_1_res[0];
    // adder_tree_level_1_reg[1] <= adder_tree_level_1_res[1];

    adder_tree_level_1_reg[0] <= adder_tree_level_0_reg[0] + adder_tree_level_0_reg[1];
    adder_tree_level_1_reg[1] <= adder_tree_level_0_reg[2] + adder_tree_level_0_reg[3];

    //pass sign
    sign_stg_4 <= sign_stg_3;
    //pass EAB
    EAB_stg_4 <= EAB_stg_3;
    //pass error
    error_flag_stg_4 <= error_flag_stg_3;
end

// -----------------
// stage 5
// Third level adder-tree 
// Recode the Mantissas of C and Compare EAB with EC
// -----------------

logic [88:0] adder_tree_level_2_res;
logic signed [55:0] MAB_mul_res_signed;
// C-relative registers
logic signed [55:0] MC_signed;
logic [10:0] exp_diff;
logic [10:0] exp_larger_stg_5;
bit shift_C_flag;
bit error_flag_stg_5 = 0;

// Read from stage_3
// logic [63:0] C_in;

// c_addsub_0 adder_2_0 (
//   .A(adder_tree_level_1_reg[0]),  // input wire [88 : 0] A
//   .B(adder_tree_level_1_reg[1]),  // input wire [88 : 0] B
//   .S(adder_tree_level_2_res)  // output wire [88 : 0] S
// );

assign adder_tree_level_2_res = adder_tree_level_1_reg[0] + adder_tree_level_1_reg[1];

always_ff @( posedge clk ) begin : error_passer
    error_flag_stg_5 <= error_flag_stg_4;
end

always_ff @( posedge clk ) begin : recoder
    // recode MAB to 2'complement
    if(sign_stg_4)begin
        MAB_mul_res_signed <= {1'b1, 1'b1, ~adder_tree_level_2_res[88 -: 54]} + 1'b1;
    end
    else begin
        MAB_mul_res_signed <= {1'b0, 1'b0, adder_tree_level_2_res[88 -: 54]};
    end

    // recode MC to 2'complement
    if(C_in[63])begin
        MC_signed <= {1'b1, 3'b110, ~C_in[51:0]} + 1'b1;
    end
    else begin
        MC_signed <= {1'b0, 3'b001, C_in[51:0]};
    end
    // MC_signed[34:0] <= '0;
end

always_ff @( posedge clk ) begin : exp_comparison
    if(EAB_stg_4 < C_in[62 -: 11])begin
        shift_C_flag <= 0;
        exp_diff <= C_in[62 -: 11] - EAB_stg_4;
        exp_larger_stg_5 <= C_in[62 -: 11];
    end
    else begin
        shift_C_flag <= 1;
        exp_diff <= EAB_stg_4 - C_in[62 -: 11];
        exp_larger_stg_5 <= EAB_stg_4;
    end
end

// -----------------
// stage 6
// Shift
// -----------------
logic signed [55:0] MC_signed_shifted;
logic signed [55:0] MAB_signed_shifted;
logic [10:0] exp_larger_stg_6;
bit error_flag_stg_6 = 0;


always_ff @( posedge clk ) begin : shift_handler
    if(shift_C_flag)begin
        MC_signed_shifted <= MC_signed >>> exp_diff;
        MAB_signed_shifted <= MAB_mul_res_signed;
    end
    else begin
        MC_signed_shifted <= MC_signed;
        MAB_signed_shifted <= MAB_mul_res_signed >>> exp_diff;
    end

    //pass exp_larger
    exp_larger_stg_6 <= exp_larger_stg_5;
    //pass error
    error_flag_stg_6 <= error_flag_stg_5;
end

// -----------------
// stage 7
// Add MAB and MC
// -----------------
logic signed [55:0] MAB_C_sum_signed_orign;
logic signed [55:0] MAB_C_add_res;
logic [10:0] exp_larger_stg_7;
bit error_flag_stg_7 = 0;

// c_addsub_1 accumulate_adder (
//   .A(MAB_signed_shifted),  // input wire [55 : 0] A
//   .B(MC_signed_shifted),  // input wire [55 : 0] B
//   .S(MAB_C_add_res)  // output wire [55 : 0] S
// );
assign MAB_C_add_res = MAB_signed_shifted + MC_signed_shifted;

always_ff @( posedge clk ) begin : MAB_MC_adder
    MAB_C_sum_signed_orign <= MAB_C_add_res;

    //pass exp_larger
    exp_larger_stg_7 <= exp_larger_stg_6;
    //pass error
    error_flag_stg_7 <= error_flag_stg_6;
end

// -----------------
// stage 8
// Recoding
// -----------------
logic [54:0] MAB_C_sum_unsigned_orign;
bit MAB_C_sign_stg_8;
logic [10:0] exp_larger_stg_8;
bit error_flag_stg_8 = 0;

always_ff @( posedge clk ) begin : reverse_recoder
    MAB_C_sign_stg_8 <= MAB_C_sum_signed_orign[55];
    
    if(MAB_C_sum_signed_orign[55])begin
        MAB_C_sum_unsigned_orign <= ~MAB_C_sum_signed_orign[54:0] + 1'b1;
    end
    else begin
        MAB_C_sum_unsigned_orign <= MAB_C_sum_signed_orign[54:0];
    end
    
    //pass exp_larger
    exp_larger_stg_8 <= exp_larger_stg_7;
    //pass error
    error_flag_stg_8 <= error_flag_stg_7;
end

// -----------------
// stage 9
// Count leading zero
// -----------------
logic [10:0] exp_larger_stg_9;
logic [54:0] MAB_C_sum_unsigned_orign_stg_9;
logic [5:0] clz_times;
logic [5:0] shift_times;
bit MAB_C_sign_stg_9;
bit error_flag_stg_9 = 0;

CLZ clz_instant(
    .in({MAB_C_sum_unsigned_orign, 9'b1}),
    .out(clz_times)
);

always_ff @( posedge clk ) begin : clz_gen
    shift_times <= clz_times;
    exp_larger_stg_9 <= exp_larger_stg_8;
    MAB_C_sum_unsigned_orign_stg_9 <= MAB_C_sum_unsigned_orign;

    //pass sign
    MAB_C_sign_stg_9 <= MAB_C_sign_stg_8;
    //pass error
    error_flag_stg_9 <= error_flag_stg_8;
end

// -----------------
// stage 10
// Normalize
// -----------------
logic [54:0] MAB_C_sum_unsigned_shifted;
logic [10:0] EAB_C;
bit MAB_C_sign_stg_10;
bit error_flag_stg_10 = 0;

always_ff @( posedge clk ) begin : MAB_C_shift
    MAB_C_sum_unsigned_shifted <= MAB_C_sum_unsigned_orign_stg_9 <<< shift_times;

    if(exp_larger_stg_9 + 2'd2 < shift_times)begin
        // 负上溢
        error_flag_stg_10 <= 1 & valid_shift_queue[2];
    end
    else begin
        EAB_C <= exp_larger_stg_9 + 2'd2 - shift_times;
        error_flag_stg_10 <= error_flag_stg_9;
    end

    //pass sign
    MAB_C_sign_stg_10 <= MAB_C_sign_stg_9;
end

// -----------------
// stage 11
// Round
// -----------------
always_ff @( posedge clk ) begin : round
    res_out[63] <= MAB_C_sign_stg_10;

    // round to the nestest, tie to even
    // handle overflow when round-add
    if(MAB_C_sum_unsigned_shifted[53:1] == ~0)begin
        res_out[62 -: 11] <= EAB_C + 1'b1;
        res_out[51:0] <= '0;
    end
    else begin
        res_out[62 -: 11] <= EAB_C;
        if(MAB_C_sum_unsigned_shifted[1:0] > 2'b10)begin
            res_out[51:0] <= MAB_C_sum_unsigned_shifted[53 -: 52] + 1'b1;
        end
        else if(MAB_C_sum_unsigned_shifted < 2'b10)begin
            res_out[51:0] <= MAB_C_sum_unsigned_shifted[53 -: 52];
        end
        else begin
            res_out[51:0] <= MAB_C_sum_unsigned_shifted[53 -: 52] + MAB_C_sum_unsigned_shifted[3];
        end
    end

    //error output
    error_flag <= error_flag_stg_10;
end

endmodule : MAC_pipeline
