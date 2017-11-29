module aludecode(input logic [5:0] Funct,
                 input logic ALUOp,
                 output logic [1:0] ALUControl,
                 output logic [1:0] FlagW);

    always_comb
        if (ALUOp)
        begin
            case(Funct[4:1])
                4'b0100: ALUControl = 2'b00;
                4'b0010: ALUControl = 2'b01;
                4'b0000: ALUControl = 2'b10;
                4'b1100: ALUControl = 2'b11;
                default: ALUControl = 2'bx;
            endcase

            FlagW[1] = Funct[0];
            FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
        end else begin
            ALUControl = 2'b00;
            FlagW      = 2'b00;
        end
endmodule

