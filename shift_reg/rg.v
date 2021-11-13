module shrg 
#(
    parameter N=8
)
(
    clk, data, o, i, reset, set, shift, wri 
);
input wire reset;
input wire [N-1:0] i;
input  wire clk; 
input  wire data; 

// control 
input  wire shift;
input wire wri; 
input wire set;

output reg [N-1:0] o;

reg [N-1:0] shrg_buf;

always @(posedge clk or negedge reset) begin
    if(reset) begin
        o <= {N{1'bz}};
        shrg_buf <= {N{1'bz}};
    end
    else begin
        if(set == 1'b1) begin
            o <= shrg_buf;
        end
        if(wri== 1'b1) begin
            shrg_buf <= i;
        end
        else begin
            if(shift)
                shrg_buf <= {shrg_buf[N-2:0], data};
        end     
    end
end
endmodule