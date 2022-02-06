module NCO(clk, reset, ctrl, out_data, setdata, fini);

input           setdata; 
input           clk;
input   		reset;
input   [9:0]   ctrl;
output  [3:0]   out_data;
output fini; 

reg     [3:0]   NCO_ROM[15:0];
reg     [15:0]  phase;
reg     [3:0]   dac_data;
reg     [15:0]  freq_step;
wire            setdata;
reg             fini;



assign  out_data = dac_data;   

initial $readmemh("NCO_ROM_4BIT.HEX", NCO_ROM);

always @(posedge clk) begin
    dac_data <= NCO_ROM[phase[15:12]];
end

always @(posedge clk or negedge reset) begin
    if(~reset) begin
        freq_step <= 0;
        phase <= 0;
        fini <= 0;
    end else if(setdata) begin
        fini <= 0;
    end else if(phase > 16'b1111000000000000) begin
        phase <= 0;
        fini <= 1;     
    end else if(fini == 1) begin
        phase <= 0;
    end
    else begin
		  freq_step <= {8'd0, ctrl};
		  phase <= phase + freq_step;
	end
end

endmodule
