module testbench2();

logic clk, reset;
logic [19:0] Instr;
logic [3:0] ALUFlags;
logic [15:0] outputs, outputsexpected;
logic [31:0] vectornum, errors;
logic [40:0] testvectors[10000:0];


 logic PCWrite;
 logic MemWrite;
 logic RegWrite;
 logic IRWrite;
 logic AdrSrc;
 logic [1:0] RegSrc;
 logic ALUSrcA;
 logic [1:0] ALUSrcB;
 logic [1:0] ResultSrc;
 logic [1:0] ImmSrc;
 logic [1:0] ALUControl;






// instantiate device under test
controller dut(clk, reset, Instr, ALUFlags, 
PCWrite,
MemWrite,
RegWrite,
IRWrite,
AdrSrc,
RegSrc,
ALUSrcA,
ALUSrcB,
ResultSrc,
ImmSrc,
ALUControl); 

assign outputs = {PCWrite,
MemWrite,
RegWrite,
IRWrite,
AdrSrc,
RegSrc,
ALUSrcA,
ALUSrcB,
ResultSrc,
ImmSrc,
ALUControl};
// generate clock
always
begin
clk = 1; #5; clk = 0; #5;
end
// at start of test, load vectors
// and pulse reset
initial
begin
$readmemb("multi.tv", testvectors);
vectornum = 0; errors = 0;
reset = 1; #27; reset = 0;
end
// apply test vectors on rising edge of clk
always @(posedge clk)
begin
#1; {reset, Instr, ALUFlags, outputsexpected} = testvectors[vectornum];
end
// check results on falling edge of clk
always @(negedge clk)
if (~reset || (reset && vectornum > 1)) begin // skip during reset

if (outputs !== outputsexpected) begin // check result
$display("Error: inputs = %b", {reset, Instr, ALUFlags});
$display(" outputs = %b (%b expected)", outputs, outputsexpected);
errors = errors + 1;
end
vectornum = vectornum + 1;
//$display(" i am in state %d", dut.dec.md.state.name);
if (testvectors[vectornum] === 41'bx) begin
$display("%d tests completed with %d errors",
vectornum, errors);
$finish;
end
end
endmodule