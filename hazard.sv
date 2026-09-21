/* Written by SD Asif Hossein, released under GPL-3 license. */

module hazard(
    input logic reset,

    /* Register write status from memory and writeback stages. */
    input logic m_register_write,
    input logic w_register_write,

    input logic [4:0] m_RD,
    input logic [4:0] w_RD,
    input logic [4:0] e_RS1,
    input logic [4:0] e_RS2,

    /* Forwarding control for ALU source operands. */
    output logic [1:0] e_forward_a,
    output logic [1:0] e_forward_b
);
    /* Forward ALU source A from memory or writeback stage. */
    assign e_forward_a = reset ? 2'b00 :
        (m_register_write && (m_RD != 5'h00) && (m_RD == e_RS1)) ? 2'b10 :
        (w_register_write && (w_RD != 5'h00) && (w_RD == e_RS1)) ? 2'b01 :
        2'b00;

    /* Forward ALU source B from memory or writeback stage. */
    assign e_forward_b = reset ? 2'b00 :
        (m_register_write && (m_RD != 5'h00) && (m_RD == e_RS2)) ? 2'b10 :
        (w_register_write && (w_RD != 5'h00) && (w_RD == e_RS2)) ? 2'b01 :
        2'b00;

endmodule
