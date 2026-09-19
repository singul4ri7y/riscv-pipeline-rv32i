/* Written by SD Asif Hossein, released under GPL-3 license. */

module pipeline(
    input logic clk,
    input logic reset
);
    /* Basically plug and play of all the modules. */

    /* Fetch stage to Decode stage. */
    logic [31:0] d_intr;
    logic [31:0] d_pc;
    logic [31:0] d_pc_plus_4;

    /* Decode stage to Execute stage. */
    logic e_register_write;
    logic e_alu_src;
    logic e_mem_write;
    logic e_result_src;
    logic e_branch;
    logic [2:0] e_alu_control;
    logic [31:0] e_RD1;
    logic [31:0] e_RD2;
    logic [31:0] e_imm_ext;
    logic [4:0] e_RD;
    logic [4:0] e_RS1;
    logic [4:0] e_RS2;
    logic [31:0] e_pc;
    logic [31:0] e_pc_plus_4;

    /* Execute stage to Memory stage. */
    logic m_register_write;
    logic m_mem_write;
    logic m_result_src;
    logic [4:0] m_RD;
    logic [31:0] m_pc_plus_4;
    logic [31:0] m_write_data;
    logic [31:0] m_alu_result;

    /* Memory stage to Writeback stage. */
    logic w_register_write;
    logic w_result_src;
    logic [4:0] w_RD;
    logic [31:0] w_pc_plus_4;
    logic [31:0] w_alu_result;
    logic [31:0] w_read_data;
    logic [31:0] w_result;

    /* Execute stage control signals. */
    logic e_pc_src;
    logic [31:0] e_pc_target;

    /* Forwarding control signals. */
    logic [1:0] e_forward_a;
    logic [1:0] e_forward_b;

    /* Fetch stage. */
    fetch_cycle fetch(
        .clk(clk),
        .reset(reset),
        .e_pc_src(e_pc_src),
        .e_pc_target(e_pc_target),

        .d_instr(d_intr),
        .d_pc(d_pc),
        .d_pc_plus_4(d_pc_plus_4)
    );

    /* Decode stage. */
    decode_cycle decode(
        .clk(clk),
        .reset(reset),
        .d_intr(d_intr),
        .d_pc(d_pc),
        .d_pc_plus_4(d_pc_plus_4),
        .w_reg_write(w_register_write),
        .w_rd(w_RD),
        .w_result(w_result),
        .e_register_write(e_register_write),
        .e_alu_src(e_alu_src),
        .e_mem_write(e_mem_write),
        .e_result_src(e_result_src),
        .e_branch(e_branch),
        .e_alu_control(e_alu_control),
        .e_RD1(e_RD1),
        .e_RD2(e_RD2),
        .e_imm_ext(e_imm_ext),
        .e_RD(e_RD),
        .e_RS1(e_RS1),
        .e_RS2(e_RS2),
        .e_pc(e_pc),
        .e_pc_plus_4(e_pc_plus_4)
    );

    /* Execute stage. */
    execute_cycle execute(
        .clk(clk),
        .reset(reset),
        .e_register_write(e_register_write),
        .e_alu_src(e_alu_src),
        .e_mem_write(e_mem_write),
        .e_result_src(e_result_src),
        .e_branch(e_branch),
        .e_alu_control(e_alu_control),
        .e_RD1(e_RD1),
        .e_RD2(e_RD2),
        .e_imm_ext(e_imm_ext),
        .e_RD(e_RD),
        .e_pc(e_pc),
        .e_pc_plus_4(e_pc_plus_4),
        .w_result(w_result),
        .e_forward_a(e_forward_a),
        .e_forward_b(e_forward_b),
        .m_register_write(m_register_write),
        .m_mem_write(m_mem_write),
        .m_result_src(m_result_src),
        .m_RD(m_RD),
        .m_pc_plus_4(m_pc_plus_4),
        .m_write_data(m_write_data),
        .m_alu_result(m_alu_result),
        .e_pc_src(e_pc_src),
        .e_pc_target(e_pc_target)
    );

    /* Memory stage. */
    memory_cycle memory(
        .clk(clk),
        .reset(reset),
        .m_register_write(m_register_write),
        .m_mem_write(m_mem_write),
        .m_result_src(m_result_src),
        .m_RD(m_RD),
        .m_pc_plus_4(m_pc_plus_4),
        .m_write_data(m_write_data),
        .m_alu_result(m_alu_result),
        .w_register_write(w_register_write),
        .w_result_src(w_result_src),
        .w_RD(w_RD),
        .w_pc_plus_4(w_pc_plus_4),
        .w_alu_result(w_alu_result),
        .w_read_data(w_read_data)
    );

    /* Writeback stage. */
    writeback_cycle writeback(
        .clk(clk),
        .reset(reset),
        .w_result_src(w_result_src),
        .w_pc_plus_4(w_pc_plus_4),
        .w_alu_result(w_alu_result),
        .w_read_data(w_read_data),
        .w_result(w_result)
    );

endmodule
