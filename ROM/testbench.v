`include "../defs.v"
module test ;
parameter N=8;
parameter SZ=32;
reg reset;
reg clk; 
reg [N-1:0] iaddr;
wire [N-1:0] o;

ROM #( .N(N), .SZ(SZ)) 
d(
    .clk(clk), 
    .o(o), .iaddr(iaddr), 
    .reset(reset)
);
initial begin
    clk = 0;
    reset = 0; 
    forever begin 
        #1 clk = ~clk;
    end
end
always begin
    $monitor($time, 
    "::\tclk %b iaddr %h o %h reset %b ",
    clk, iaddr, o, reset);
    #1 reset = 1;
    #1 reset = 0;
    #8 iaddr = 8'h01;
    #1 iaddr = iaddr + 1; 
    #1 iaddr = iaddr + 1; 
    #1 iaddr = iaddr + 1; 
    #1 iaddr = iaddr + 1; 
    #1 iaddr = iaddr + 1; 
    #1 iaddr = iaddr + 1; 
    #1 $finish;

    end
      // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,  test);
    end
endmodule