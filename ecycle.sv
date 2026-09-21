/* Written by SD Asif Hossein, released under GPL-3 license. */

module execute_cycle(
    input logic clk,
    input logic reset,  /* active low async reset */

    /* Input from decode stage for execute stage. */
    input logic e_register_write,
    input logic e_alu_src,
    input logic e_mem_write,
    input logic e_result_src,
    input logic e_branch,

    input logic [2:0] e_alu_control,

    input logic [31:0] e_RD1,
    input logic [31:0] e_RD2,
    input logic [31:0] e_imm_ext,

    input logic [4:0] e_RD,

    input logic [31:0] e_pc,
    input logic [31:0] e_pc_plus_4,

    /* Input from writeback stage for execute stage. */
    input logic [31:0] w_result,

    /* Input from forwarding unit. */
    input logic [1:0] e_forward_a,
    input logic [1:0] e_forward_b,

    /* Output for memory stage. */
    output logic m_register_write,
    output logic m_mem_write,
    output logic m_result_src,

    output logic [4:0] m_RD,

    output logic [31:0] m_pc_plus_4,
    output logic [31:0] m_write_data,
    output logic [31:0] m_alu_result,

    /* Output for fetch stage. */
    output logic e_pc_src,
    output logic [31:0] e_pc_target
);
    logic [31:0] src_a;
    logic [31:0] src_b_interim;
    logic [31:0] src_b;

    logic [31:0] alu_result;
    logic zero;

    /* Handle forwarding in 3x1 mux. */
    assign src_a = (e_forward_a == 2'b00) ? e_RD1 :
        (e_forward_a == 2'b01) ? w_result :
        (e_forward_a == 2'b10) ? m_alu_result : e_RD1;

    /* Handle forwarding in 3x1 mux. */
    assign src_b_interim = (e_forward_b == 2'b00) ? e_RD2 :
        (e_forward_b == 2'b01) ? w_result :
        (e_forward_b == 2'b10) ? m_alu_result :
        e_RD2;

    assign src_b = e_alu_src ? e_imm_ext : src_b_interim;

    /* potato. */
    alu arithmetic_logic_unit(
        .a(src_a),
        .b(src_b),
        .result(alu_result),
        .alu_control(e_alu_control),

        .overflow(),
        .carry(),
        .zero(zero),
        .negative()
    );

    assign e_pc_target = e_pc + e_imm_ext;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            /* reset memory stages. */
            m_register_write <= 1'b0;
            m_mem_write <= 1'b0;
            m_result_src <= 1'b0;

            m_RD <= 5'b0;

            m_pc_plus_4 <= 32'b0;
            m_write_data <= 32'b0;
            m_alu_result <= 32'b0;
        end
        else begin
            /* control signals */
            m_register_write <= e_register_write;
            m_mem_write <= e_mem_write;
            m_result_src <= e_result_src;

            /* destination register */
            m_RD <= e_RD;

            /* PC information */
            m_pc_plus_4 <= e_pc_plus_4;

            /* data to be written to memory */
            m_write_data <= src_b_interim;

            /* ALU result */
            m_alu_result <= alu_result;
        end
    end

    /* branch decision. */
    assign e_pc_src = zero & e_branch;

endmodule
