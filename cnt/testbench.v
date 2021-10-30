`include "../defs.v"
`include "cnt.vh"
module test ;
    reg clk, reset;
    reg [31:0] div;
    reg [2:0] control;
    wire q;
    wire [31:0] dout;
    cnt c(clk, reset, div, control, q, dout);
    initial begin
       clk = 0;
       reset = 0; 
       div = 0;
       control = 0; 
       forever begin 
           #1 clk = ~clk;
       end
    end
    always begin
        $monitor($time, 
        "::\tclk %b,\treset %b,\t div %0h,\tcontrol %b, q %b, dout %0h",
        clk, reset, div, control, q, dout);
        #5 reset = 1;
        #6 reset = 0;
        #10 control = `CTRL_RESET_AND_SIGNAL_IF_EQUAL ;
        #11 div = 2;
        #200 div = 1024;
        #5000 control = `CTRL_COUNTDOWN_AND_SIGNAL_IF_EQUAL;
        #10000 $finish;
    end
      // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,clk);
        $dumpvars(0,reset);
        $dumpvars(0,div);
        $dumpvars(0,control);
        $dumpvars(0,q);
        $dumpvars(0,dout);
    end
endmodule