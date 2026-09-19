module cu(
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    output logic reg_write,
    output logic [1:0] imm_src,
    output logic alu_src,
    output logic mem_write,
    output logic result_src,
    output logic branch,
    output logic [2:0] alu_control
);
    /* What kind of ALU operation. */
    logic [1:0] alu_op;

    /* Main decoder */
    decoder d(
        .opcode(opcode),

        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .alu_op(alu_op)
    );

    /* Figures out the ALU control combination for specific instructions. */
    alu_decoder ad(
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),

        .alu_control(alu_control)
    );

endmodule
