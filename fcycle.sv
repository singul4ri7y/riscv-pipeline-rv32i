/* Written by SD Asif Hossein, released under GPL-3 license. */

module fetch_cycle(
    input logic clk,
    input logic reset,

    input logic e_pc_src,            /* mux switch: branch or next instruction */
    input logic [31:0] e_pc_target,  /* target branch instr. index if we are branching */

    output logic [31:0] d_instr,     /* 4-byte instruction */
    output logic [31:0] d_pc,        /* instruction addr. */
    output logic [31:0] d_pc_plus_4  /* following instruction addr. */
);
    /* Interim bus. */
    logic [31:0] f_pc_tmp, f_pc, f_pc_plus_4;
    logic [31:0] f_instr;

    /* Fetch registers. */
    logic [31:0] f_instr_reg, f_pc_reg, f_pc_plus_4_reg;

    /* 2x1 mux to choose whether to use branch instruction or following instruction. */
    assign f_pc_tmp = e_pc_src ? e_pc_target : f_pc_plus_4;

    /* Program counter. */
    pc pcounter(.clk(clk), .reset(reset), .pc_next(f_pc_tmp), .pc(f_pc));

    /* Instruction memory construct. */
    imem mem(.reset(reset), .A(f_pc), .RD(f_instr));
    
    /* Next instruction location. */
    assign f_pc_plus_4 = f_pc + 32'd4;

    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            f_instr_reg <= 32'b0;
            f_pc_reg <= 32'b0;
            f_pc_plus_4_reg <= 32'b0;
        end
        else begin
            f_instr_reg <= f_instr;
            f_pc_reg <= f_pc;
            f_pc_plus_4_reg <= f_pc_plus_4;
        end
    end

    /* Decode stage outputs. */
    assign d_instr = reset ? 32'b0 : f_instr_reg;
    assign d_pc = reset ? 32'b0 : f_pc_reg;
    assign d_pc_plus_4 = reset ? 32'b0 : f_pc_plus_4_reg;
endmodule


