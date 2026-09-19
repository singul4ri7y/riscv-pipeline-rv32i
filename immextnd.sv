/* Written by SD Asif Hossein, released under GPL-3 license. */

module immextnd(
    input logic [31:0] instr,
    input logic [1:0]  imm_src,

    output logic [31:0] imm_ext
);
    /* s-type immediates are segregated. */
    always @* begin
        case(imm_src)
            /* i-type immediate */
            2'b00: begin
                imm_ext = {{20{instr[31]}}, instr[31:20]};  /* sign bit is replicated. */
            end

            /* s-type immediate */
            2'b01: begin
                imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end

            /* Unsupported immediate type */
            default: begin
                imm_ext = 32'b0;
            end
        endcase
    end

endmodule
