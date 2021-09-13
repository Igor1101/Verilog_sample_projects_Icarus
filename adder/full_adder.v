module full_adder (
    a, b, ci, s, co
);
output co;
output s;
input a;
input b;
input ci;
    assign s = a ^ b ^ ci;
    assign co = (a & b) | ((a ^ b) & ci);
endmodule