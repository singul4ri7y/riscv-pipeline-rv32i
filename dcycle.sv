/* Written by SD Asif Hossein, released under GPL-3 license. */

module decode_cycle(
    input logic clk,
    input logic reset,  /* active high async reset */

    /* Input from fetch stage for decode stage. */
    input logic [31:0] d_intr,
    input logic [31:0] d_pc,
    input logic [31:0] d_pc_plus_4,

    /* Input from writeback stage for decode stage. */
    input logic w_reg_write,
    input logic [4:0] w_rd,
    input logic [31:0] w_result,

    /* Output for execute stage. */
    output logic e_register_write,
    output logic e_alu_src,
    output logic e_mem_write,
    output logic e_result_src,
    output logic e_branch,

    output logic [2:0] e_alu_control,

    output logic [31:0] e_RD1,
    output logic [31:0] e_RD2,
    output logic [31:0] e_imm_ext,

    output logic [4:0] e_RD,
    output logic [4:0] e_RS1,
    output logic [4:0] e_RS2,

    output logic [31:0] e_pc,
    output logic [31:0] e_pc_plus_4
);
    /* Internal signals, immediates */
    logic d_reg_write;
    logic d_alu_src;
    logic d_mem_write;
    logic d_result_src;
    logic d_branch;

    logic [1:0]  d_imm_src;
    logic [2:0]  d_alu_control;

    logic [31:0] d_RD1;
    logic [31:0] d_RD2;
    logic [31:0] d_imm_ext;

    /* Figure out what the instruction does. */
    cu control_unit(
        .opcode(d_intr[6:0]),    /* instruction category. */
        .funct3(d_intr[14:12]),  /* minor op code, distinguishes ALU operation. */
        .funct7(d_intr[31:25]),  /* sub op code, might not be needed for i-type. */

        .reg_write(d_reg_write),
        .imm_src(d_imm_src),
        .alu_src(d_alu_src),
        .mem_write(d_mem_write),
        .result_src(d_result_src),
        .branch(d_branch),
        .alu_control(d_alu_control)
    );

    regfile register_file(
        .clk(clk),
        .reset(reset),

        .we3(w_reg_write),
        .wd3(w_result),
        .a1(d_intr[19:15]),  // rs1
        .a2(d_intr[24:20]),  // rs2
        .a3(w_rd),           // destination register

        .rd1(d_RD1),
        .rd2(d_RD2)
    );

    /* converts immediate instruction value to full 32-bit value. */
    immextnd immediate_extender(
        .instr(d_intr),
        .imm_src(d_imm_src),

        .imm_ext(d_imm_ext)
    );

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            // Reset all Execute-stage outputs.
            e_register_write <= 1'b0;
            e_alu_src <= 1'b0;
            e_mem_write <= 1'b0;
            e_result_src<= 1'b0;
            e_branch <= 1'b0;

            e_alu_control <= 3'b000;

            e_RD1 <= 32'b0;
            e_RD2 <= 32'b0;
            e_imm_ext <= 32'b0;

            e_RD <= 5'b0;
            e_RS1 <= 5'b0;
            e_RS2 <= 5'b0;

            e_pc <= 32'b0;
            e_pc_plus_4 <= 32'b0;
        end
        else begin
            /* control signals */
            e_register_write <= d_reg_write;
            e_alu_src <= d_alu_src;
            e_mem_write <= d_mem_write;
            e_result_src <= d_result_src;
            e_branch <= d_branch;

            e_alu_control <= d_alu_control;

            /* register operands. */
            e_RD1 <= d_RD1;
            e_RD2 <= d_RD2;

            /* sign extend immediate. */
            e_imm_ext <= d_imm_ext;

            /* register numbers. */
            e_RD  <= d_intr[11:7];   // rd
            e_RS1 <= d_intr[19:15];  // rs1
            e_RS2 <= d_intr[24:20];  // rs2

            /* dunno why this is provided, but yeah. */
            e_pc <= d_pc;
            e_pc_plus_4 <= d_pc_plus_4;
        end
    end

endmodule
