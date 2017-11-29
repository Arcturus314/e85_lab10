module instrdecode(input logic [1:0] op,
                   input logic [5:0] funct,
                   output logic [1:0] RegSrc,
                   output logic [1:0] ImmSrc);

    always_comb
    begin
        if (op == 2'b01)
        begin 
            ImmSrc = 2'b01;
            if (funct[0] == 1) RegSrc = 2'bx0;
            else               RegSrc = 2'b10;
        end

        if (op == 2'b10)
        begin
            RegSrc = 2'bx1;
            ImmSrc = 2'b10;
        end

        if (op == 2'b00)
        begin  
            ImmSrc = 2'b00;
            if (funct[5] == 1) RegSrc = 2'bx0;
            else               RegSrc = 2'b00;
        end
    end

endmodule