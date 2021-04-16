`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 07:23:09 PM
// Design Name: 
// Module Name: CLZ
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

module CLZ #(
    parameter W_IN = 64, // Must be power of 2, >=2
    parameter W_OUT = $clog2(W_IN) // Let this default
)
(
    input logic  [W_IN-1:0] in,
    output logic [W_OUT-1:0] out
);

generate
if (W_IN == 2) begin: base
    assign out = !in[1];
end else begin: recurse
    wire [W_OUT-2:0] half_count;
    wire [W_IN / 2-1:0] lhs = in[W_IN / 2 +: W_IN / 2];
    wire [W_IN / 2-1:0] rhs = in[0        +: W_IN / 2];
    wire left_empty = ~|lhs;

    CLZ #(
        .W_IN (W_IN / 2)
    ) inner (
        .in  (left_empty ? rhs : lhs),
        .out (half_count)
    );

    assign out = {left_empty, half_count};
end
endgenerate

endmodule


// module CLZ #(
//     parameter W_IN = 64, // Must be power of 2, >=2
//     parameter W_OUT = $clog2(W_IN) // Let this default
// ) (
//     input wire  [W_IN-1:0] in,
//     output wire [W_OUT-1:0] out
// );

// generate
//     for(genvar i = 0; i < 32; i=i+1) begin : enc_inst
//         enc inst(
//             .d(in[2*i+1 : 2*i]),
//             .q()
//         );
//     end
// endgenerate

// always_comb begin : clz
    
// end
    
// endmodule

// module enc
// (
//    input wire     [1:0]       d,
//    output logic   [1:0]       q
// );

//    always_comb begin
//       case (d[1:0])
//          2'b00    :  q = 2'b10;
//          2'b01    :  q = 2'b01;
//          default  :  q = 2'b00;
//       endcase
//    end

// endmodule // enc

// module clzi #
// (
//    // external parameter
//    parameter   N = 2,
//    // internal parameters
//    parameter   WI = 2 * N,
//    parameter   WO = N + 1
// )
// (
//    input wire     [WI-1:0]    d,
//    output logic   [WO-1:0]    q
// );

//    always_comb begin
//       if (d[N - 1 + N] == 1'b0) begin
//          q[WO-1] = (d[N-1+N] & d[N-1]);
//          q[WO-2] = 1'b0;
//          q[WO-3:0] = d[(2*N)-2 : N];
//       end else begin
//          q[WO-1] = d[N-1+N] & d[N-1];
//          q[WO-2] = ~d[N-1];
//          q[WO-3:0] = d[N-2 : 0];
//       end
//    end

// endmodule // clzi


