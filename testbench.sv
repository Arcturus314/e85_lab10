module testbench();
    logic clk, reset;
    logic [19:0] instr;
    logic [3:0] aluflags;
    logic pcwrite, memwrite, regwrite, irwrite, adrsrc, alusrca;
    logic [1:0] regsrc;
    logic [1:0] alusrcb;
    logic [1:0] resultsrc;
    logic [1:0] immsrc;
    logic [1:0] alucontrol;
    logic [31:0] vectornum, errors;
    logic [40:0] testvectors[10000:0];

    logic [15:0] outputemp;
    logic [15:0] outputexp;

    reg lastreset;

    controller dut (clk, reset, instr, aluflags, pcwrite, memwrite, regwrite, irwrite, adrsrc, regsrc, alusrca, alusrcb, resultsrc, immsrc, alucontrol);
    assign outputemp = {pcwrite, memwrite, regwrite, irwrite, adrsrc, regsrc, alusrca, alusrcb, resultsrc, immsrc, alucontrol};
    

    always
        begin
            clk = 1; #5; clk = 0; #5;
        end

    initial
        begin
            $readmemb("testvectors.tv", testvectors);
            vectornum = 0; errors = 0;
            $display("resetting....");
            reset = 1; #22; reset = 0;
            $display("reset complete");
        end

    always @(posedge clk)
        begin
            {instr, aluflags, outputexp} = testvectors[vectornum];
            $display("entering vector num %d...%b", vectornum, {instr, aluflags, outputexp}); 
            lastreset <= 0;
            if (vectornum==4 | vectornum==9 | vectornum==14 | vectornum==19 | vectornum==25)
            begin
                lastreset <= 1;
                reset = 1; #22; reset = 0;
                vectornum = vectornum + 1;
            end
        end
    
    always @(negedge clk)
        if (~reset) begin
            $display("not reset");

            if ((outputemp !== outputexp) & ~lastreset) begin
                $display("Error: inputs %b", {instr, aluflags});
                $display(" outputs = %b (%b expected)", {outputemp}, {outputexp});
                errors = errors + 1;
            end
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 41'bx) begin
                $display("%d tests completed with %d errors", vectornum ,errors);
                $stop;
            end
        end
endmodule