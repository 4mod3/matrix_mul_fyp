`timescale 1ns / 1ps

module control_C #(
    parameter D_WIDTH = 64,
    parameter A_PART_WIDTH = 1, // Si/P
    parameter B_NUM_WIDTH = 1, // Sj
    parameter N_MAX_WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input wire load_pos_bit_in,
    input wire store_pos_bit_in,
    input logic [D_WIDTH-1:0] wr_data_in,
    output logic [D_WIDTH-1:0] rd_data_out,
    input logic [N_MAX_WIDTH-1 : 0] N_in,

    // write out ports
    input logic res_clk,
    input logic res_rd_en_in,
    input logic [A_PART_WIDTH + B_NUM_WIDTH-1 : 0] res_rd_addr_in,
    output logic [D_WIDTH-1 : 0] res_rd_data_out,
    output logic output_trigger_out

);

localparam MEM_ADDR_WTH = A_PART_WIDTH + B_NUM_WIDTH;

// // SRAM Inst 0
// logic we_i_0;
// logic [MEM_ADDR_WTH-1 : 0] waddr_i_0;
// logic [D_WIDTH-1 : 0] wdata_i_0;
// logic rd_clk_i_0;
// logic re_i_0;
// logic [MEM_ADDR_WTH-1 : 0] raddr_i_0;
// logic [D_WIDTH-1 : 0] rdata_o_0;
// sdp_sram #(
//     .WR_ADDR_WTH(MEM_ADDR_WTH),
//     .WR_DATA_WTH(D_WIDTH),
//     .RD_ADDR_WTH(MEM_ADDR_WTH),
//     .RD_DATA_WTH(D_WIDTH),
//     .RD_DELAY(2)
// ) TC_RAM_0_inst (
//     .wr_clk_i(clk),
//     .we_i(we_i_0),
//     .waddr_i(waddr_i_0),
//     .wdata_i(wdata_i_0),
//     .rd_clk_i(rd_clk_i_0),
//     .re_i(re_i_0),
//     .raddr_i(raddr_i_0),
//     .rdata_o(rdata_o_0)
// );

// // SRAM Inst 1
// logic we_i_1;
// logic [MEM_ADDR_WTH-1 : 0] waddr_i_1;
// logic [D_WIDTH-1 : 0] wdata_i_1;
// logic rd_clk_i_1;
// logic re_i_1;
// logic [MEM_ADDR_WTH-1 : 0] raddr_i_1;
// logic [D_WIDTH-1 : 0] rdata_o_1;
// sdp_sram #(
//     .WR_ADDR_WTH(MEM_ADDR_WTH),
//     .WR_DATA_WTH(D_WIDTH),
//     .RD_ADDR_WTH(MEM_ADDR_WTH),
//     .RD_DATA_WTH(D_WIDTH),
//     .RD_DELAY(2)
// ) TC_RAM_1_inst (
//     .wr_clk_i(clk),
//     .we_i(we_i_1),
//     .waddr_i(waddr_i_1),
//     .wdata_i(wdata_i_1),
//     .rd_clk_i(rd_clk_i_1),
//     .re_i(re_i_1),
//     .raddr_i(raddr_i_1),
//     .rdata_o(rdata_o_1)
// );

// SRAM Inst
logic [1:0] we_i;
logic [1:0] [MEM_ADDR_WTH-1 : 0] waddr_i;
logic [1:0] [D_WIDTH-1 : 0] wdata_i;
logic [1:0] rd_clk_i;
logic [1:0] re_i;
logic [1:0] [MEM_ADDR_WTH-1 : 0] raddr_i;
logic [1:0] [D_WIDTH-1 : 0] rdata_o;

sdp_sram #(
    .WR_ADDR_WTH(MEM_ADDR_WTH),
    .WR_DATA_WTH(D_WIDTH),
    .RD_ADDR_WTH(MEM_ADDR_WTH),
    .RD_DATA_WTH(D_WIDTH),
    .RD_DELAY(2)
) TC_RAM_0_inst (
    .wr_clk_i(clk),
    .we_i(we_i[0]),
    .waddr_i(waddr_i[0]),
    .wdata_i(wdata_i[0]),
    .rd_clk_i(rd_clk_i[0]),
    .re_i(re_i[0]),
    .raddr_i(raddr_i[0]),
    .rdata_o(rdata_o[0])
);

sdp_sram #(
    .WR_ADDR_WTH(MEM_ADDR_WTH),
    .WR_DATA_WTH(D_WIDTH),
    .RD_ADDR_WTH(MEM_ADDR_WTH),
    .RD_DATA_WTH(D_WIDTH),
    .RD_DELAY(2)
) TC_RAM_1_inst (
    .wr_clk_i(clk),
    .we_i(we_i[1]),
    .waddr_i(waddr_i[1]),
    .wdata_i(wdata_i[1]),
    .rd_clk_i(rd_clk_i[1]),
    .re_i(re_i[1]),
    .raddr_i(raddr_i[1]),
    .rdata_o(rdata_o[1])
);

// ---------------------------------------------------
// Load C
// ---------------------------------------------------
reg [MEM_ADDR_WTH-1 : 0] load_addr = '0;
reg [N_MAX_WIDTH-1 : 0] load_count = '0;
reg load_index = 0;
logic [D_WIDTH-1 : 0] ram_rd_data;
logic zero_flag_stg_1;
logic zero_flag_stg_2;
logic load_index_stg_1;
logic load_index_stg_2;
// logic load_index_next;
// logic [MEM_ADDR_WTH-1 : 0] load_addr_next;
// logic [N_MAX_WIDTH-1 : 0] load_count_next;

// // load comb signal
// always_comb begin : load_C_comb_block
//     if(load_pos_bit_in && (~load_addr == '0))begin
//         if(load_count == N_in - 1'b1)begin
//             load_index_next = !load_index;
//             load_count_next = '0;
//         end else begin
//             load_index_next = load_index;
//             load_count_next = load_count + 1'b1;
//         end
//     end else begin
//         load_index_next = load_index;
//         load_count_next = load_count;
//     end
// end

always_ff @( posedge clk or posedge rst ) begin : load_C_block
    if(rst)begin
        load_addr <= '0;
        load_count <= '0;
        load_index <= 0;
    end else begin
        load_addr <= load_pos_bit_in?(load_addr + 1'b1):load_addr;
        // load_count <= load_count_next;
        // load_index <= load_index_next;

        if(load_pos_bit_in && (~load_addr == '0))begin
            if(load_count == N_in - 1'b1)begin
                load_index <= !load_index;
                load_count <= '0;
            end else begin
                load_index <= load_index;
                load_count <= load_count + 1'b1;
            end
        end else begin
            load_index <= load_index;
            load_count <= load_count;
        end

        // delay zero-flag (without rst RAM)
        zero_flag_stg_1 <= load_count == '0;
        zero_flag_stg_2 <= zero_flag_stg_1;
        // delay load_index
        load_index_stg_1 <= load_index;
        load_index_stg_2 <= load_index_stg_1;
    end
end

assign rd_data_out = zero_flag_stg_2?'0:ram_rd_data;

// ---------------------------------------------------
// Store C
// ---------------------------------------------------
reg [MEM_ADDR_WTH-1 : 0] store_addr = '0;
reg [N_MAX_WIDTH-1 : 0] store_count = '0;
reg store_index = 0;
logic [D_WIDTH-1 : 0] ram_wr_data;
// logic store_index_next;
// logic [MEM_ADDR_WTH-1 : 0] store_addr_next;
// logic [N_MAX_WIDTH-1 : 0] store_count_next;

// // store comb signal
// always_comb begin : store_C_comb_block
//     if(store_pos_bit_in && (~store_addr == '0))begin
//         if(store_count == N_in - 1'b1)begin
//             store_index_next = !store_index;
//             store_count_next = '0;
//         end else begin
//             store_index_next = store_index;
//             store_count_next = store_count + 1'b1;
//         end
//     end else begin
//         store_index_next = store_index;
//         store_count_next = store_count;
//     end
// end

always_ff @( posedge clk or posedge rst ) begin : store_C_block
    if(rst)begin
        store_addr <= '0;
        store_count <= '0;
        store_index <= 0;
    end else begin
        store_addr <= store_pos_bit_in?(store_addr + 1'b1):store_addr;
        // store_count <= store_count_next;
        // store_index <= store_index_next;
        if(store_pos_bit_in && (~store_addr == '0))begin
            if(store_count == N_in - 1'b1)begin
                store_index = !store_index;
                store_count = '0;
            end else begin
                store_index = store_index;
                store_count = store_count + 1'b1;
            end
        end else begin
            store_index = store_index;
            store_count = store_count;
        end
    end
end

// ---------------------------------------------------
// SRAM port distru
// ---------------------------------------------------
assign output_trigger_out = store_index;

always_comb begin : SRAM_port
    // load port
    rd_clk_i[load_index] = clk;
    re_i[load_index] = load_pos_bit_in;
    raddr_i[load_index] = load_addr;
    ram_rd_data = rdata_o[load_index_stg_2];

    rd_clk_i[!load_index] = res_clk;
    re_i[!load_index] = res_rd_en_in;
    raddr_i[!load_index] = res_rd_addr_in;
    res_rd_data_out = rdata_o[!load_index];

    // store port
    we_i[store_index] = store_pos_bit_in;
    waddr_i[store_index] = store_addr;
    wdata_i[store_index] = wr_data_in;

    we_i[!store_index] = 0;
    // waddr_i[!store_index] = store_addr;
    // wdata_i[!store_index] = wr_data_in;

end

endmodule

// interface res_out#(
//     parameter D_WIDTH = 64,
//     parameter ADDR_WTH = 2
// )(input logic clk);
//     logic rd_en;
//     logic [ADDR_WTH-1 : 0] rd_addr;
//     logic [D_WIDTH-1 : 0] rd_data;
//     logic output_trigger;

//     modport out (
//         input rd_en,
//         input rd_addr,
//         output rd_data,
//         output output_trigger
//     );
// endinterface //res_out