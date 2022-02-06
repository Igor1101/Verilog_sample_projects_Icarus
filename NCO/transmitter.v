module transmitter(clk, reset, dac);
input clk;
input reset;
output [3:0] dac;
wire [3:0] dac;
wire fini;
reg [3:0] datap;
reg [7:0] counter;
reg     [3:0]   DATA_ROM[15:0];
reg setdata;

initial $readmemh("DATA_ROM.HEX", DATA_ROM);
NCO inco(clk, reset, {DATA_ROM[datap], 6'b0}, dac, setdata, fini);
always @(posedge clk or negedge reset) begin
    if(~reset) begin
		  counter <= 0;
		  datap <= 0;
    end else if(counter ==  255 && fini == 1) begin
			datap <= datap + 1;
			setdata <= 1;
			counter <= counter + 1;
	end
	else begin
		setdata <= 0;
		counter <= counter + 1;
	end
end

endmodule