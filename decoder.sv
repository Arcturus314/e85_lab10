module decoder(input logic clk, reset,
               input logic [3:0] Rd,
               input logic [1:0] Op,
               input logic [5:0] Funct,
               output logic pcs, RegW, MemW, IRWrite, NextPC, AdrSrc, ALUSrcA,
               output logic [1:0] ResultSrc,
               output logic [1:0] AluSrcB,
               output logic [1:0] ALUControl,
               output logic [1:0] FlagW,
               output logic [1:0] ImmSrc,
               output logic [1:0] RegSrc);

    logic ALUOp, Branch; 

    controllersm    smachine(clk, reset, Op, Funct[5], Funct[0], AdrSrc, ALUSrcA, AluSrcB, ALUOp, IRWrite, NextPC, MemW, RegW, Branch, ResultSrc);
    pclogic         pcl(Rd, Branch, RegW, pcs);
    aludecode       alud(Funct, ALUOp, ALUControl, FlagW);
    instrdecode     instrd(Op, Funct, RegSrc, ImmSrc);

endmodule