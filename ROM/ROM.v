module ROM
#(
    parameter SZ=32,
    parameter N = 8
)
(
    clk, o, iaddr, reset 
);

// control 
input wire clk;
input wire reset; 
input wire [N-1:0] iaddr; 
output reg [N-1:0] o; 

reg [N-1:0] data [SZ-1:0];

always @(negedge reset) begin 
    if(reset) begin 
        o <= {N{1'bz}};
    end
end
initial begin
    $readmemh("ROM.hex", data);
end
always @(posedge clk) begin
    o <= data[iaddr];
end
endmodule