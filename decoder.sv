/* Written by SD Asif Hossein, released under GPL-3 license. */

module decoder(
    input  logic [6:0] opcode,

    /* Whether the control writes to a register file. */
    output logic reg_write,
    /* What type of immediate we are dealing with: i-type, s-type or b-type. */
    output logic [1:0] imm_src,
    /* Should ALU use register or immediate? */
    output logic alu_src,
    /* Should write deta to memory */
    output logic mem_write,
    /* Feed into the mux for ALU result or memory result (for load instructions). */
    output logic result_src,
    /* Tell control unit that current instruction is a branch. */
    output logic branch,
    /* What kind of ALU operation do we need */
    output logic [1:0] alu_op
);
    /* Operational codes used by this processor. */
    localparam logic [6:0] OP_LOAD   = 7'b0000011;
    localparam logic [6:0] OP_STORE  = 7'b0100011;
    localparam logic [6:0] OP_RTYPE  = 7'b0110011;
    localparam logic [6:0] OP_ITYPE  = 7'b0010011;
    localparam logic [6:0] OP_BRANCH = 7'b1100011;

    always_comb begin
        reg_write  = 1'b0;
        /* i-type: load immediate type, s-type: store immediate type and
          b-type: branch immediate type. */
        imm_src    = 2'b00;
        alu_src    = 1'b0;
        mem_write  = 1'b0;
        result_src = 1'b0;
        branch     = 1'b0;
        alu_op     = 2'b00;

        case(opcode)
            /* LOAD instructions, e.g.: LW x5, 8(x6) */
            OP_LOAD: begin
                reg_write  = 1'b1;
                imm_src    = 2'b00;
                alu_src    = 1'b1;
                mem_write  = 1'b0;
                result_src = 1'b1;
                branch     = 1'b0;
                alu_op     = 2'b00;
            end

            /* STORE instructions, e.g.: SW x5, 8(x6) */
            OP_STORE: begin
                reg_write  = 1'b0;
                imm_src    = 2'b01;
                alu_src    = 1'b1;
                mem_write  = 1'b1;
                result_src = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b00;
            end

            /* R-type instructions, e.g.: ADD x5, x6, x7 */
            OP_RTYPE: begin
                reg_write  = 1'b1;
                imm_src    = 2'b00;
                alu_src    = 1'b0;
                mem_write  = 1'b0;
                result_src = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b10;
            end

            /* I-type ALU instructions, e.g.: ADDI x5, x6, 10 */
            OP_ITYPE: begin
                reg_write  = 1'b1;
                imm_src    = 2'b00;
                alu_src    = 1'b1;
                mem_write  = 1'b0;
                result_src = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b10;
            end

            /* Branch instructions, e.g.: BEQ x5, x6, label */
            OP_BRANCH: begin
                reg_write  = 1'b0;
                imm_src    = 2'b10;
                alu_src    = 1'b0;
                mem_write  = 1'b0;
                result_src = 1'b0;
                branch     = 1'b1;
                alu_op     = 2'b01;
            end

            /* Unsupported / illegal opcode */
            default: begin
                reg_write  = 1'b0;
                imm_src    = 2'b00;
                alu_src    = 1'b0;
                mem_write  = 1'b0;
                result_src = 1'b0;
                branch     = 1'b0;
                alu_op     = 2'b00;
            end

        endcase
    end

endmodule
