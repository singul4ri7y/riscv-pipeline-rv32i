/* Written by SD Asif Hossein, released under GPL-3 license. */

module regfile(
    input logic clk,
    input logic reset,

    /* Write port. */
    input logic we3,
    input logic [31:0] wd3,
    input logic [4:0]  a3,

    /* Read ports. */
    input logic [4:0] a1,
    input logic [4:0] a2,

    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    /* Register file contains 32 registers, each 32 bits wide. */
    logic [31:0] registers [0:31];

    always_ff @(posedge clk) begin
        if(we3 && (a3 != 5'h00))
            registers[a3] <= wd3;
    end

    always_comb begin
        if (reset == 1'b1) begin
            rd1 = 32'b0;
            rd2 = 32'b0;
        end
        else begin
            rd1 = (a1 == 5'h00) ? 32'b0 : registers[a1];
            rd2 = (a2 == 5'h00) ? 32'b0 : registers[a2];
        end
    end

    /* x0 in RISC-V is null register. */
    initial begin
        registers[0] = 32'h00000000;
    end

endmodule
