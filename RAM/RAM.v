module RAM
#(
    parameter SZ=32,
    parameter N = 8
)
(
    clk, i, o, iaddr, reset, rw
);

// control 
input wire clk; 
input wire rw;
input wire reset; 
input wire [N-1:0] i;
input wire [N-1:0] iaddr; 
output reg [N-1:0] o; 

reg [N-1:0] data [SZ-1:0];

always @(negedge reset) begin 
    if(reset) begin 
        o <= {N{1'bz}};
    end
end
always @(posedge clk) begin
    if(rw == 1) begin
        data[iaddr] <= i;
    end
    o <= data[iaddr];
end
endmodule