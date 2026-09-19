/* Written by SD Asif Hossein, released under GPL-3 license. */

module alu(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [2:0] alu_control,

    output logic [31:0] result,
    output logic overflow,
    output logic carry,
    output logic zero,
    output logic negative
);
    logic cout;
    logic [31:0] sum;

    /* Calculate either A + B or A - B depending on alu_control[0]. */
    assign sum = (alu_control[0] == 1'b0) ? (a + b) :
        (a + ((~b) + 1'b1));

    /* Select the final ALU operation. */
    assign {cout, result} =
        (alu_control == 3'b000) ? {cout, sum} :
        (alu_control == 3'b001) ? {cout, sum} :  /* subtraction for branch. */
        (alu_control == 3'b010) ? {1'b0, (a & b)} :
        (alu_control == 3'b011) ? {1'b0, (a | b)} :
        (alu_control == 3'b101) ? {32'b0, sum[31]} :
                                  33'b0;

    /* Calculate signed overflow for addition and subtraction. */
    assign overflow =
        ((sum[31] ^ a[31]) &
        (~(alu_control[0] ^ b[31] ^ a[31])) &
        (~alu_control[1]));

    /* Carry is only meaningful for arithmetic operations. */
    assign carry = (~alu_control[1]) & cout;

    /* Result is zero when all result bits are zero. */
    assign zero = ~|result;

    /* Most-significant bit indicates a negative result (signed bit). */
    assign negative = result[31];
endmodule
