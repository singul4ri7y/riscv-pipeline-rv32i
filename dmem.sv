/* Written by SD Asif Hossein, released under GPL-3 license. */

module dmem(
    input logic clk,
    input logic reset,

    input logic we,
    input logic [31:0] wd,
    input logic [31:0] a,

    output logic [31:0] rd
);

    logic [31:0] mem [0:1023];

    /* Write to memory on the rising clock edge. */
    always_ff @(posedge clk) begin
        if (we)
            mem[a] <= wd;
    end

    /* Read memory combinationally. */
    always_comb begin
        if(reset)
            rd = 32'b0;
        else
            rd = mem[a];
    end

    initial begin
        mem[0] = 32'h00000000;
    end

endmodule
