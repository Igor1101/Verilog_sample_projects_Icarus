/**
FIR( Finite Impulse Response) filter
*/

module fir ( clk, coefs, in, out );
//input data\signal width
parameter INPUT_SZ = 16;	
//registers coef data width (should be less then 32 bit)
parameter COEF_SZ = 16;	
//number of filter registers
parameter REGS_NUM   = 2;	
//width of multiplication
localparam MULT_SZ = (INPUT_SZ+COEF_SZ); 
//filter result width
localparam RESULT_SZ = (MULT_SZ+REGS_NUM-1); 

input  wire clk;
input  wire [INPUT_SZ-1:0]in;
//all input coefficient concatineted
input  wire [REGS_NUM*32-1:0]coefs; 
//output takes only top bits part of result
output wire [RESULT_SZ-1:0]out; 

genvar i;
generate
	for( i=0; i<REGS_NUM; i=i+1 )
	begin:registers
		//make *registers* register chain
		reg [INPUT_SZ-1:0]r=0;
		if(i==0) begin
			//1st registers takes signal from input
			always @(posedge clk)
				r <= in;
		end
		else begin
			//registers reg takes signal from prev registers reg
			always @(posedge clk)
				registers[i].r <= registers[i-1].r;
		end

		//get registers multiplication constant coef
		wire [COEF_SZ-1:0]c;
		assign c = coefs[((REGS_NUM-1-i)*32+COEF_SZ-1):(REGS_NUM-1-i)*32];

		//calculate multiplication and fix result in register
		reg [MULT_SZ-1:0]m;
		// m = r * c
		always @(posedge clk)
			m <= $signed(r) * $signed( c );
			
		//make combinatorial adders
		reg [MULT_SZ-1+i:0]a;
		// i==0: a[0] = reg[0].m
		if(i==0) begin
			// a[i] = m[i]
			always @*
				registers[i].a = $signed(registers[i].m);
		end
		else
		begin
			// a[i] = m[i] + a[i-1]
			always @*
				registers[i].a = $signed(registers[i].m)+$signed(registers[i-1].a);
		end
	end
endgenerate

//fix calculated summa in register
reg [RESULT_SZ-1:0]result;
// res = a[last]
always @(posedge clk)
	result <= registers[REGS_NUM-1].a;

//deliver output
assign out = result;

endmodule