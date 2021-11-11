module rg 
#(
    parameter N=8
)
(
    clk, i, o, reset
);
input wire reset;
input wire [N-1:0] i;
input  wire clk; 
output reg [N-1:0] o;
always @(posedge clk or negedge reset) begin
    if(reset) begin
        o <= 0;
    end
    else begin
        o <= i;
    end
end
endmodule