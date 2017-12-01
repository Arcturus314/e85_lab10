module controllersm(input logic  clk,
                    input logic  reset,
                    input logic  [1:0] op,
                    input logic  im,
                    input logic  s,
                    output logic AdrSrc,
                    output logic AluSrcA,
                    output logic [1:0] AluSrcB,
                    output logic AluOp,
                    output logic IRWrite,
                    output logic NextPC,
                    output logic MemW,
                    output logic RegW,
                    output logic Branch,
                    output logic [1:0] ResultSrc);

    typedef enum logic [3:0] {fetch, decode, memadr, executer, executei, branchs, memread, memwrite, aluwb, memwb} statetype;
    statetype state, nextstate;
    //state register
    always_ff @(posedge clk, posedge reset)
        begin
            if (reset) state <= fetch;
            else       state <= nextstate;
        end
    //next state logic
    always_comb
    begin
        case (state)
            fetch:                                   nextstate = decode;

            decode:     if (op == 2'b01)             nextstate = memadr;
                        else if (op == 2'b00 & ~im)  nextstate = executer;
                        else if (op == 2'b00 & im)   nextstate = executei;
                        else if (op == 2'b10)        nextstate = branchs;
                        else                         nextstate = decode;
            
            memadr:     if (s)                       nextstate = memread;
                        else if (~s)                 nextstate = memwrite;   
                        else                         nextstate = memadr;

            executer:                                nextstate = aluwb;
            executei:                                nextstate = aluwb;
            memread:                                 nextstate = memwb;
            branchs:                                 nextstate = fetch;
            memwrite:                                nextstate = fetch;
            aluwb:                                   nextstate = fetch;        
            default:                                 nextstate = fetch;
        endcase
        AdrSrc  = (state==memread | state==memwrite);
        AluSrcA = (state==fetch | state==decode);
        AluOp   = (state==executei | state==executer);
        IRWrite = (state==fetch);
        NextPC  = (state==fetch);
        MemW    = (state==memwrite);
        RegW    = (state==aluwb | state==memwb);
        Branch  = (state==branchs);
        if (state==fetch | state==decode)                           AluSrcB = 2'b10;
        else if (state==memadr | state==executei | state==branchs)   AluSrcB = 2'b01;
        else                                                        AluSrcB = 2'b00; 
        if (state==fetch | state==decode | state==branchs)           ResultSrc = 2'b10;
        else if (state==memwb)                                      ResultSrc = 2'b01;
        else                                                        ResultSrc = 2'b00;
    end
endmodule       