module controller(input logic clk,
                  input logic reset,
                  input logic [31:12] Instr,
                  input logic [3:0] ALUFlags,
                  output logic PCWrite,
                  output logic MemWrite,
                  output logic RegWrite,
                  output logic IRWrite,
                  output logic AdrSrc,
                  output logic [1:0] RegSrc,
                  output logic ALUSrcA,
                  output logic [1:0] ALUSrcB,
                  output logic [1:0] ResultSrc,
                  output logic [1:0] ImmSrc,
                  output logic [1:0] ALUControl);

    logic [1:0] op;
    logic [5:0] funct;
    logic [3:0] Rd;
    logic [3:0] cond;

    logic [1:0] FlagW;
    logic pcs, nextpc, regw, memw;

    assign op = Instr[27:26];
    assign funct = Instr[25:20];
    assign Rd = Instr[15:12];
    assign cond = Instr[31:28];

    decoder decode(clk, reset, Rd, op, funct, pcs, regw, memw, IRWrite, nextpc, AdrSrc, ALUSrcA, ResultSrc, ALUSrcB, ALUControl, FlagW, ImmSrc, RegSrc);
    condlogic condl(clk, reset, pcs, nextpc, regw, memw, FlagW, cond, ALUFlags, PCWrite, RegWrite, MemWrite);
endmodule

