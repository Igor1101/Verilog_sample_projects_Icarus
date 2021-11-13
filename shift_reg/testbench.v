`include "../defs.v"
module test ;
parameter N=10;
reg reset;
reg [N-1:0] i;
reg clk; 
reg data; 

// control 
reg shift;
reg wri; 
reg set;

wire [N-1:0] o;

shrg #(.N(N)) d(
    .clk(clk), 
    .data(data), 
    .o(o), .i(i), 
    .reset(reset), 
    .set(set), 
    .shift(shift), 
    .wri(wri));
    initial begin
       clk = 0;
       reset = 0; 
       forever begin 
           #1 clk = ~clk;
       end
    end
    always begin
        $monitor($time, 
        "::\tclk %b data %h o %h i %h reset %b set %b shift %b wri %b",
        clk, data, o, i, reset, set, shift, wri );
        #1 reset = 1;
        #1 reset = 0;
        #8 i = 10'h10;
        #9 wri = 1;
        #1 wri = 0;
        #9 set = 1;
        #1 set = 0;

        #10 data = 1;
        #1 shift =1;
        #4 data = 0;
        #3 shift =0;

        #1 set = 1;
        #1 set = 0;
        #10 reset = 1;

        #10 $finish;

    end
      // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,  test);
    end
endmodule