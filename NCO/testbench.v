`timescale 1ns / 1ps

module testbench;

parameter PERIOD = 10;

reg         clk; 
reg         reset;
reg  [9:0]  i_freq_step;
wire [3:0]  o_dac;

transmitter tr_inst(.clk (clk), 
                .reset(reset),
                .dac (o_dac)
                );

initial begin
    clk = 0;
    forever #(PERIOD/2) clk = ~clk;
end

initial begin
    clk = 0;
    reset = 0; 
    forever begin 
        #1 clk = ~clk;
    end
end
always  begin
    #2 reset = 1;
    #8000 $finish;  
end
    // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,  testbench);
    end
endmodule
