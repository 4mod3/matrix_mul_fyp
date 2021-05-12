`timescale 1ns / 1ps

module top_tb;

logic clk;
logic rst;
parameter CLK_PERIOD = 10;

task automatic rst_task(input [15:0] rst_times);
    rst = 1;
    # rst_times;
    rst = 0;
endtask //rst_task

// hyper parameters
parameter PE_NUM_WIDTH = 2;
parameter A_NUM_WIDTH = 3;
parameter B_NUM_WIDTH = 3;
parameter N = 16;
parameter M = 16;
parameter K = 16;
parameter N_MAX_WIDTH = 32;
parameter PE = (1<<PE_NUM_WIDTH);
parameter Si = (1<<A_NUM_WIDTH);
parameter Sj = (1<<B_NUM_WIDTH);

// 16x16 matrix
logic full_flag;
logic [N_MAX_WIDTH-1:0] N_in;
logic [63:0] matrix_tuple [2*N-1:0] [N-1:0];
logic [63:0] C [M][K];
logic [63:0] A;
logic [63:0] B;
logic A_valid;
logic B_valid;

top #(
    64, PE_NUM_WIDTH, A_NUM_WIDTH, B_NUM_WIDTH, N_MAX_WIDTH 
) top (
    .clk(clk),
    .rst(rst),
    .A_in(A),
    .A_valid_in(A_valid),
    .B_in(B),
    .B_valid_in(B_valid),
    .N_in(N_in)
);

int i, j, ii, jj, n;
initial begin
    $readmemh("./build/AB_16_16_16_10.out", matrix_tuple);
    clk = 0;
    rst = 0;
    A_valid = 0;
    B_valid = 0;
    N_in = N;
    # CLK_PERIOD;
    rst_task(CLK_PERIOD);
    for(i=0; i<N/Si; i++)begin
        for(j=0; j<N/Sj; j++)begin
            for(n=0; n<N; n++)begin
                for(ii=0; ii<Si; ii++)begin
                    A = matrix_tuple[i*Si+ii][n];
                    A_valid = 1'b1;
                    #CLK_PERIOD;
                end
                A_valid = 0;
                for(jj=0; jj<Sj; jj++)begin
                    B = matrix_tuple[N+n][j*Sj+jj];
                    B_valid = 1'b1;
                    #CLK_PERIOD;
                end
                B_valid = 0;
            end
        end
    end
    # 10000;
    // for(i=0; i<16;i++)begin
    //     $display("%X", matrix_tuple[31][i]);
    // end
    $finish;
end

// initial begin
//     wait(top.PE_gen_block[0].PE_inst.res_rd_en_in);
//     #(CLK_PERIOD * 1.5);
//     $display("%016X", top.PE_gen_block[0].PE_inst.res_rd_data_out);
//     #CLK_PERIOD;
//     $display("%016X", top.PE_gen_block[0].PE_inst.res_rd_data_out);
//     #CLK_PERIOD;
//     $display("%016X", top.PE_gen_block[0].PE_inst.res_rd_data_out);
// end

// task automatic read_out_data(integer pe_i);
//     // logic w_sign = top.PE_gen_block[pe_i].PE_inst.res_rd_en_in;
//     wait(top.PE_gen_block[pe_i].PE_inst.res_rd_en_in);
//     #(CLK_PERIOD * 1.5);
//     for(integer res_row_ = 0; res_row_ < M/Si; res_row_++)begin
//         for(integer res_col_ = 0; res_col_ < K/Sj; res_col_++)begin
//             for(integer res_index_ = 0; res_index_ < Sj*Si/PE; res_index_++)begin
//                 C[res_row_*Si + 0*Si/PE + res_index_[0]][res_col_*Sj + (res_index_>>1)] = top.PE_gen_block[0].PE_inst.res_rd_data_out;
//                 #CLK_PERIOD;
//             end
//         end
//     end
// endtask //read_out_data

// for(integer pe_i=0; pe_i<PE; PE_i++)begin: PE_out
//     initial begin
//         wait(top.PE_gen_block[0].PE_inst.res_rd_en_in);
//         #(CLK_PERIOD * 1.5);
//         for(integer 8;)
//     end
// end
// initial begin
//     fork
//         begin
//         for(genvar pe_i=0; pe_i<PE; pe_i++) begin
//             // read_out_data(pe_i);
//             wait(top.PE_gen_block[pe_i].PE_inst.res_rd_en_in);
//             #(CLK_PERIOD * 1.5);
//             for(integer res_row_ = 0; res_row_ < M/Si; res_row_++)begin
//                 for(integer res_col_ = 0; res_col_ < K/Sj; res_col_++)begin
//                     for(integer res_index_ = 0; res_index_ < Sj*Si/PE; res_index_++)begin
//                         C[res_row_*Si + 0*Si/PE + res_index_[0]][res_col_*Sj + (res_index_>>1)] = top.PE_gen_block[0].PE_inst.res_rd_data_out;
//                         #CLK_PERIOD;
//                     end
//                 end
//             end
//         end
//         end
//     join
//     $writememh("C_res.out", C);
// end

// initial begin
//     for(int pe_i=0; pe_i<PE; pe_i++)begin
//         fork
//             int pe_idx = pe_i;
//             wait(top.PE_gen_block[pe_idx].PE_inst.res_rd_en_in);
//             #(CLK_PERIOD * 1.5);
//             for(integer res_row_ = 0; res_row_ < M/Si; res_row_++)begin
//                 for(integer res_col_ = 0; res_col_ < K/Sj; res_col_++)begin
//                     for(integer res_index_ = 0; res_index_ < Sj*Si/PE; res_index_++)begin
//                         C[res_row_*Si + pe_idx*Si/PE + res_index_[0]][res_col_*Sj + (res_index_>>1)] = top.PE_gen_block[pe_idx].PE_inst.res_rd_data_out;
//                         #CLK_PERIOD;
//                     end
//                 end
//             end
//         join
//         $writememh("C_res.out", C);
//     end
// end

initial begin
    fork
        begin
            for(int res_row_ = 0; res_row_ < M/Si; res_row_++)begin
                for(int res_col_ = 0; res_col_ < K/Sj; res_col_++)begin
                    wait(top.PE_gen_block[0].PE_inst.res_rd_en_in);
                    #(CLK_PERIOD * 1.5);
                    for(int res_index_ = 0; res_index_ < Sj*Si/PE; res_index_++)begin
                        // $display("%b, %d", res_index_, Sj*Si/PE);
                        // $display("%d, %d", res_row_*Si + 0*Si/PE + res_index_[0], res_col_*Sj + (res_index_>>1));
                        C[res_row_*Si + 0*Si/PE + res_index_[0]][res_col_*Sj + (res_index_>>1)] = top.PE_gen_block[0].PE_inst.res_rd_data_out;
                        #CLK_PERIOD;
                    end
                end 
            end
        end
        begin
            for(int res_row_ = 0; res_row_ < M/Si; res_row_++)begin
                for(int res_col_ = 0; res_col_ < K/Sj; res_col_++)begin
                    wait(top.PE_gen_block[1].PE_inst.res_rd_en_in);
                    #(CLK_PERIOD * 1.5);
                    for(int res_index_ = 0; res_index_ < Sj*Si/PE; res_index_++)begin
                        C[res_row_*Si + 1*Si/PE + res_index_[0]][res_col_*Sj + (res_index_>>1)] = top.PE_gen_block[1].PE_inst.res_rd_data_out;
                        #CLK_PERIOD;
                    end
                end
            end
        end
        begin
            for(int res_row_ = 0; res_row_ < M/Si; res_row_++)begin
                for(int res_col_ = 0; res_col_ < K/Sj; res_col_++)begin
                    wait(top.PE_gen_block[2].PE_inst.res_rd_en_in);
                    #(CLK_PERIOD * 1.5);
                    for(int res_index_ = 0; res_index_ < Sj*Si/PE; res_index_++)begin
                        C[res_row_*Si + 2*Si/PE + res_index_[0]][res_col_*Sj + (res_index_>>1)] = top.PE_gen_block[2].PE_inst.res_rd_data_out;
                        #CLK_PERIOD;
                    end
                end
            end
        end
        begin
            for(int res_row_ = 0; res_row_ < M/Si; res_row_++)begin
                for(int res_col_ = 0; res_col_ < K/Sj; res_col_++)begin
                    wait(top.PE_gen_block[3].PE_inst.res_rd_en_in);
                    #(CLK_PERIOD * 1.5);
                    for(int res_index_ = 0; res_index_ < Sj*Si/PE; res_index_++)begin
                        C[res_row_*Si + 3*Si/PE + res_index_[0]][res_col_*Sj + (res_index_>>1)] = top.PE_gen_block[3].PE_inst.res_rd_data_out;
                        #CLK_PERIOD;
                    end
                end
            end
        end
    join
    $writememh("./build/C_res_16_16_16_10.out", C);
end

initial begin
    $dumpfile("./build/top_wave.vcd");
    $dumpvars(0,top_tb);
    // $dumpvars(1,matrix_tuple );s
end

always #(CLK_PERIOD/2) clk = ~clk;

endmodule