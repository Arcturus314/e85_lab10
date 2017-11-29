module condlogic(input logic clk, reset,
                 input logic pcs, nextpc,
                 input logic regw,
                 input logic memw,
                 input logic [1:0] flagw,
                 input logic [3:0] cond,
                 input logic [3:0] aluflags,
                 output logic pcsrc, regwrite, memwrite);
    logic [1:0] FlagWrite;
    logic [3:0] Flags;
    logic CondEx;

    flopenr #(2)flagreg1(clk, reset, FlagWrite[1], aluflags[3:2], Flags[3:2]);
    flopenr #(2)flagreg0(clk, reset, FlagWrite[0], aluflags[1:0], Flags[1:0]);
    flopenr #(1)condex(clk, reset, 1'b1, CondEx, CondExOut);

    //write controls are conditional
    condcheck cc(cond, Flags, CondEx);

    assign FlagWrite = flagw & {2{CondExOut}};
    assign regwrite  = regw  & CondExOut;
    assign memwrite  = memw  & CondExOut;
    assign pcsrc     = (pcs  & CondExOut) | nextpc;
endmodule

module flopenr #(parameter WIDTH = 8)
 (input logic clk, reset, en,
 input logic [WIDTH-1:0] d,
 output logic [WIDTH-1:0] q);
 always_ff @(posedge clk)
 if (reset) q <= 0;
 else if (en) q <= d;
endmodule



