/* Written by SD Asif Hossein, released under GPL-3 license. */

module writeback_cycle(
    input logic clk,
    input logic reset,
    input logic w_result_src,
    input logic [31:0] w_pc_plus_4,
    input logic [31:0] w_alu_result,
    input logic [31:0] w_read_data,

    output logic [31:0] w_result
);
    assign w_result = w_result_src ? w_read_data : w_alu_result;

endmodule
