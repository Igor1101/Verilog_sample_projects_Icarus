/**
IIR( Infinite Impulse Response) filter
*/

module iir ( clk, coefsA, coefsB, in, out );
//input data\signal width
parameter INPUT_SZ = 16;	
//registers coef data width (should be less then 32 bit)
parameter COEFA_SZ = 16;	
parameter COEFB_SZ = 16;	
//number of filter registers
parameter REGSA_NUM = 2;	
parameter REGSB_NUM = 2;	
//width of multiplication
localparam MULTA_SZ = (INPUT_SZ+COEFA_SZ); 
localparam MULTB_SZ = (INPUT_SZ+COEFB_SZ); 
//filter result width
localparam RESULT_SZ = (MULTA_SZ+REGSA_NUM-1); 

input  wire clk;
input  wire [INPUT_SZ-1:0]in;
//all input coefficient concatinated
input  wire [REGSA_NUM*32-1:0]coefsA; 
input  wire [REGSB_NUM*32-1:0]coefsB; 
//output takes only top bits part of result
output wire [RESULT_SZ-1:0]out; 
// saved prev results
reg [RESULT_SZ-1:0]yi = 0;
//fifo  #(.PTR_WIDTH($clog2(RESULT_SZ)), .DATA_WIDTH(RESULT_SZ), .DEPTH(REGSB_NUM)) 
//	ffy(.clk(clk), .rstn(1), .pop(0), .push(1),.din(yi));
genvar i;
generate
	for( i=0; i<REGSA_NUM; i=i+1 )
	begin:registers
		//make *registers* register chain
		reg [INPUT_SZ-1:0]r=0;
		if(i==0) begin
			//1st registers takes signal from input
			always @(posedge clk)
				r <= in;
		end
		else begin
			//registers take signal from prev registers regs
			always @(posedge clk)
				registers[i].r <= registers[i-1].r;
		end

		//get registers multiplication constant coef
		wire [COEFA_SZ-1:0]c;
		assign c = coefsA[((REGSA_NUM-1-i)*32+COEFA_SZ-1):(REGSA_NUM-1-i)*32];

		//calculate multiplication and fix result in register
		reg [MULTA_SZ-1:0]m;
		// m = r * c
		always @(posedge clk)
			m <= $signed(r) * $signed( c );
			
		//combinatorial adders
		reg [MULTA_SZ-1+i:0]a;
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

genvar k;
generate
	for( k=0; k<REGSB_NUM; k=k+1 )
	begin:registersy
		//make *registers* register chain
		reg [INPUT_SZ-1:0]r=0;
		if(k==0) begin
			//1st registers takes signal from input
			always @(posedge clk)
				r <= in;
		end
		else begin
			//registers take signal from prev registers regs
			always @(posedge clk)
				registersy[k].r <= registersy[k-1].r;
		end

		//get registers multiplication constant coef
		wire [COEFA_SZ-1:0]c;
		assign c = coefsB[((REGSB_NUM-1-k)*32+COEFB_SZ-1):(REGSB_NUM-1-k)*32];

		//calculate multiplication and fix result in register
		reg [MULTB_SZ-1:0]m;
		// m = r * c
		always @(posedge clk)
			m <= $signed(r) * $signed( c );
			
		//combinatorial adders
		reg [MULTB_SZ-1+k:0]a;
		// i==0: a[0] = reg[0].m
		if(k==0) begin
			// a[i] = m[i]
			always @*
				registersy[k].a = $signed(registersy[k].m);
		end
		else
		begin
			// a[i] = m[i] + a[i-1]
			always @*
				registersy[k].a = $signed(registersy[k].m)+$signed(registersy[k-1].a);
		end
	end
endgenerate

reg [7:0]init=0;
reg init_b=0;
//fix calculated summa in register
reg [RESULT_SZ-1:0]result;
// res = a[last]+b[last]
always @(posedge clk) begin
	if(init == REGSA_NUM)
		init_b = 1;
	else if (init_b) begin
		yi <= result;
	end
	init <= init + 1;
	result <= registers[REGSA_NUM-1].a + registersy[REGSB_NUM-1].a;
end

//deliver output
assign out = result;

endmodule