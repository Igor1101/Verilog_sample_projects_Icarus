module full_adder4 (
    a, b, c_in, sum, c_out
);
output c_out;
output [3:0]sum;
input [3:0]a;
input [3:0]b;
input c_in;
wire [4:0]s_full;
    assign s_full = a + b + c_in;
    assign c_out = s_full[4];
    assign sum = s_full[3:0];
endmodule