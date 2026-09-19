/* Written by SD Asif Hossein, released under GPL-3 license. */

module pltb;
    logic clk, reset;

    initial begin
        clk = 1'b0;
        reset = 1'b0;
    end

    always begin
        clk = !clk;
        #50;
    end

    initial begin
        reset = 1'b1;
        #200;
        reset = 1'b0;
        #1000;
        $finish;
    end

    pipeline DUT(.clk(clk), .reset(reset));

    // Value Change Dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0);
    end
endmodule
