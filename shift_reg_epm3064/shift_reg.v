module shift_reg(clk, data, o, reset, set, shift);
input clk;
input wire data;
output wire [5:0]o;
input reset;
input set;
input shift;

shrg #(6) rg(clk, data, o,, reset, set, shift,);
endmodule