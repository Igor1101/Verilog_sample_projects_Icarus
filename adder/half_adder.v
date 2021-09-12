module half_adder (
    a, b, s, co
);
output co;
output s;
input a;
input b;
    assign s = a ^ b;
    assign co = a & b;
endmodule