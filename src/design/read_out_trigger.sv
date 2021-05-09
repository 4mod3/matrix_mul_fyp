`timescale 1ns / 1ps

module read_out_trigger #(
    parameter D_WIDTH = 64,
    parameter ADDR_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic output_trigger_in,
    output logic res_rd_en_out = 0,
    output logic [ADDR_WIDTH-1 : 0] res_rd_addr_out
);

logic [ADDR_WIDTH-1 : 0] read_counter = '0;
logic output_trigger_last = 0;

assign res_rd_addr_out = read_counter;

always_ff @( posedge clk or posedge rst) begin : main
    if(rst)begin
        read_counter <= '0;
        output_trigger_last <= 0;
        res_rd_en_out <= 0;
    end else begin
        if(((output_trigger_in ^ output_trigger_last) && (read_counter == '0)) || (read_counter != '0))begin
            read_counter <= read_counter + 1'b1;
            res_rd_en_out <= (!read_counter != '0);
        end else begin
            read_counter <= '0;
            res_rd_en_out <= 0;
        end
        output_trigger_last <= output_trigger_in;
    end
end

endmodule