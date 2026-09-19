/* Written by SD Asif Hossein, released under GPL-3 license. */

module pltb;
    logic clk, reset, e_pc_src;
    logic [31:0] e_pc_target, d_instr, d_pc, d_pc_plus_4;

    fetch_cycle uut(
        .clk(clk),
        .reset(reset),
        .e_pc_src(e_pc_src),
        .e_pc_target(e_pc_target),

        .d_instr(d_instr),
        .d_pc(d_pc),
        .d_pc_plus_4(d_pc_plus_4)
    );

    /* clock */
    always #50 clk = ~clk;

    initial begin
        /* Initialize the signals. */
        clk = 1'b1;
        reset = 1'b0;
        e_pc_src = 1'b0;
        e_pc_target = 32'b0;

        #100;
        reset = 1'b1;
        e_pc_target = 32'b0;

        #300;
        reset = 1'b0;

        #500;
        $finish;
    end

    // Value Change Dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0);
    end
endmodule
