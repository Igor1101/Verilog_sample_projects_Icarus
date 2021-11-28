`include "../defs.v"
module test ;
parameter N=8;
parameter SZ=32;
reg reset;
reg clk; 
reg [N-1:0] iaddr;
wire [N-1:0] o;
reg [N-1:0] i;
reg rw;

RAM #( .N(N), .SZ(SZ)) 
d(
    .clk(clk), 
    .i(i),
    .rw(rw),
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
    #1 rw = 1;
    #1 
        i = 8'hCA;
        iaddr = iaddr + 1; 
    #1 i = 8'hFE;
     iaddr = iaddr + 1; 
    #1 i = 8'hFE;
     iaddr = iaddr + 1; 
    #1 i = 8'hED;
     iaddr = iaddr + 1; 
    #1 iaddr = iaddr + 1; 
    #1 iaddr = iaddr + 1; 
    #1 iaddr = 8'h00;
       rw = 0;
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