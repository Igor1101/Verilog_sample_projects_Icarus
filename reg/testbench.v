`include "../defs.v"
module test ;
parameter N=10;
    reg clk, reset;
    wire [N-1:0] q;
    reg [N-1:0] sig;
    rg #(.N(N)) d(.clk(clk), .reset(reset), .o(q), .i(sig));
    initial begin
       clk = 0;
       reset = 0; 
       forever begin 
           #1 clk = ~clk;
       end
    end
    always begin
        $monitor($time, 
        "::\tclk %b,\treset %b,\t sig %0h,\tout %b, q %b,",
        clk, reset, , sig, q );
        #5 reset = 1;
        #6 reset = 0;
        #7 sig = 32;
        #8 sig = 0;
        #9 sig = 21;
        #10 $finish;
    end
      // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,clk);
        $dumpvars(0,reset);
        $dumpvars(0,q);
        $dumpvars(0,sig);
    end
endmodule