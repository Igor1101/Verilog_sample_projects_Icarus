`timescale 1ns / 1ns

module testbench();
parameter PERIOD = 10;

reg clk;
initial begin
	clk = 0;
    forever #(PERIOD/2) clk = ~clk;
end

real PI=3.14159265358979323846;
// sec
real last_time=0; 
// sec
real current_time=0; 
// rad
real angle=0;	
// HZ
real frequency=100; 
// *100kHz
integer freq_x100kHz=0; 
reg signed [15:0]sin16;

task set_freq;
input f;
real f;
begin
	frequency = f;
	freq_x100kHz = f/100000.0;
end
endtask

always @(posedge clk)
begin
	current_time = $realtime;
	angle = angle+(current_time-last_time)*2*PI*frequency/1000000000.0;
	//$display("%f %f",current_time,angle);
	while ( angle > PI*2.0 )
	begin
		angle = angle-PI*2.0;
	end 
	sin16 = 32000*$sin(angle);
	last_time = current_time;
end

//moving average filter
wire [46:0]out_moving_average;
fir #( .REGS_NUM(16) ) fir_ma_inst(
	.clk(clk),
	.coefs( { 
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1,
		 32'd1
		} ),
	.in(sin16),
	.out(out_moving_average)
	);

//band-stop
wire [57:0]out_bandstop;
/*
http://t-filter.engineerjs.com/
from	to	gain	ripple/att.	act. rpl	
0 kHz 800 kHz 0 -40 dB -34.76 dB	
1000 kHz 2000 kHz 1 5 dB 8.01 dB	
3000 kHz 4000 kHz 0 -40 dB -34.76 dB
*/
fir #( .REGS_NUM(27) ) fir_bs_inst(
	.clk(clk),
	.coefs( { 
-32'd441,
32'd2765,
32'd1814,
-32'd7291,
-32'd2145,
32'd9223,
-32'd2888,
-32'd5755,
32'd12740,
32'd237,
-32'd17515,
32'd2829,
32'd8435,
-32'd3418,
32'd8435,
32'd2829,
-32'd17515,
32'd237,
32'd12740,
-32'd5755,
-32'd2888,
32'd9223,
-32'd2145,
-32'd7291,
32'd1814,
32'd2765,
-32'd441
		} ),
	.in(sin16),
	.out(out_bandstop)
	);

integer i;
real f;

initial
begin
	$dumpfile("test.vcd");
	$dumpvars(0,testbench);
	f=100000;
	// freq from 100 KHz to 4 MHz
	for(i=0; i<4000; i=i+1)
	begin
		set_freq(f);
		#1000;
		f=f+1000;
	end
	$finish;
end

endmodule