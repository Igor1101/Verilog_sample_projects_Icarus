`include "../defs.v"
module test ;
    reg clk, reset;
    wire[0:0] q;
    reg inp;
    dff d(.clk(clk), .reset(reset), .o(q), .i(inp));
    initial begin
       clk = 0;
       reset = 0; 
       inp = 0;
       forever begin 
           #1 clk = ~clk;
       end
    end
    always begin
        $monitor($time, 
        "::\tclk %b,\treset %b,\t inp %b,\tq %b",
        clk, reset, inp, q );
        #5 reset = 1;
        #6 reset = 0;
        #7 inp = 1;
        #8 inp = 0;
        #9 inp = 1;
        #10 $finish;
    end
      // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,clk);
        $dumpvars(0,reset);
        $dumpvars(0,q);
        $dumpvars(0,inp);
    end
endmodule