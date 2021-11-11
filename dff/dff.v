module dff (
    clk, i, o, reset
);
input wire reset;
input wire i;
input  wire clk; 
output reg o;
always @(posedge clk or negedge reset) begin
    if(reset) begin
        o <= 1'b0;
    end
    else begin
        o <= i;
    end
end
endmodule