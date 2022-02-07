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
iir #( .REGSA_NUM(12), .REGSB_NUM(12) ) iir_inst(
	.clk(clk),
	.coefsA( { 
		 32'd2048,
		 -32'd707,
		 32'd212,
		 32'd2048,
		 -32'd1099,
		 32'd699,
		 32'd1024,
		 -32'd805,
		 32'd743,
		 32'd2048,
		 -32'd276,
		 32'd0
		} ),
		.coefsB(
			{
				32'd30,
				32'd40,
				32'd30,
				32'd2048,
				32'd988,
				32'd2048,
				32'd1024,
				32'd52,
				32'd1024,
				32'd2048,
				32'd2048,
				32'd0
			}
		),
	.in(sin16),
	.out(out_moving_average)
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