/* Written by SD Asif Hossein, released under GPL-3 license. */

module pc(
    input  logic clk,
    input  logic reset,
    input  logic [31:0] pc_next,
    output logic [31:0] pc  /* register */
);
    always_ff @(posedge clk) begin
        if(reset)
            pc <= 32'b0;
        else pc <= pc_next;
    end

endmodule
