/* Written by SD Asif Hossein, released under GPL-3 license. */

module memory_cycle(
    input logic clk,
    input logic reset,  /* active high async reset */

    /* Input from execute stage for memory stage. */
    input logic m_register_write,
    input logic m_mem_write,
    input logic m_result_src,

    input logic [4:0] m_RD,
    input logic [31:0] m_pc_plus_4,
    input logic [31:0] m_write_data,
    input logic [31:0] m_alu_result,

    /* Output for writeback stage. */
    output logic w_register_write,
    output logic w_result_src,

    output logic [4:0] w_RD,
    output logic [31:0] w_pc_plus_4,
    output logic [31:0] w_alu_result,
    output logic [31:0] w_read_data
);
    /* Data read from memory during Memory stage. */
    logic [31:0] m_read_data;

    /* Declaration of Data Memory. */
    dmem data_memory(
        .clk(clk),
        .reset(reset),
        .we(m_mem_write),
        .wd(m_write_data),
        .a(m_alu_result),
        .rd(m_read_data)
    );

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            /* Reset all Writeback-stage outputs. */
            w_register_write <= 1'b0;
            w_result_src <= 1'b0;

            w_RD <= 5'b0;

            w_pc_plus_4 <= 32'b0;
            w_alu_result <= 32'b0;
            w_read_data <= 32'b0;
        end
        else begin
            /* Transfer control signals. */
            w_register_write <= m_register_write;
            w_result_src <= m_result_src;

            /* Transfer destination register. */
            w_RD <= m_RD;

            /* Transfer PC information. */
            w_pc_plus_4 <= m_pc_plus_4;

            /* Transfer ALU result. */
            w_alu_result <= m_alu_result;

            /* Transfer data read from memory. */
            w_read_data <= m_read_data;
        end
    end

endmodule
