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

parameter PE_NUM_WIDTH = 1;
parameter A_NUM_WIDTH = 3;
parameter B_NUM_WIDTH = 3;
parameter N_MAX_WIDTH = 32;
parameter PE = (1<<PE_NUM_WIDTH);
parameter Si = (1<<A_NUM_WIDTH);
parameter Sj = (1<<B_NUM_WIDTH);
parameter N = 16;

// 16x16 matrix
logic full_flag;
logic [N_MAX_WIDTH-1:0] N_in;
logic [63:0] matrix_tuple [31:0] [15:0];
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

integer i, j, ii, n;
initial begin
    $readmemh("AB.out", matrix_tuple);
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
                    B = matrix_tuple[N+n][j*Sj+ii];
                    A_valid = 1'b1;
                    B_valid = 1'b1;
                    #CLK_PERIOD;
                end
            end
        end
    end
    A_valid = 0;
    B_valid = 0;
    # 18000;
    // for(i=0; i<16;i++)begin
    //     $display("%X", matrix_tuple[31][i]);
    // end
    $finish;
end


initial begin
    $dumpfile("./build/top_wave.vcd");
    $dumpvars(0,top_tb);
    // $dumpvars(1,matrix_tuple );s
end

always #(CLK_PERIOD/2) clk = ~clk;

endmodule