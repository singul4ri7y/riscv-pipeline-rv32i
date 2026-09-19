/* Written by SD Asif Hossein, released under GPL-3 license. */

module imem(
    input  logic reset,
    input  logic [31:0] A,
    output logic [31:0] RD
);
    logic [31:0] mem [0:1023];  /* memory in big endian bit order, 4kb. */

    /* Address is always 4-byte aligned, hence we don't need last 2 bits. */
    assign RD = reset ? 32'b0 : mem[A[31:2]];

    initial begin
        $readmemh("instrmem.hex", mem);
    end

endmodule
