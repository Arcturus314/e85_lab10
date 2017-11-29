module pclogic(input logic [3:0] Rd,
               input logic branch, RegW,
               output logic pcs);
    assign pcs = ((Rd == 4'b1111) & RegW) | branch;
endmodule 