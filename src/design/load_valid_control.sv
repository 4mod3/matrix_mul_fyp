`timescale 1ns / 1ps

module valid_control (
    input logic clk,
    input logic rst,
    input logic load_valid_in,
    input logic read_valid_in,
    input bit load_valid_index,
    output logic load_valid_out,
    output logic read_valid_out
);

logic TA_0_valid = 0;
logic TA_1_valid = 0;

always_ff @( posedge clk or posedge rst ) begin : update
    if(rst == 1'b1)begin
        TA_0_valid <= 0;
        TA_1_valid <= 0;
    end
    else if(load_valid_index == 1'b0)begin
        TA_0_valid <= load_valid_in;
        TA_1_valid <= read_valid_in;
    end
    else begin
        TA_0_valid <= read_valid_in;
        TA_1_valid <= load_valid_in;
    end
    // 高阻态？
end

assign load_valid_out = load_valid_index?TA_1_valid:TA_0_valid;
assign read_valid_out = load_valid_index?TA0_valid:TA_1_valid;

endmodule