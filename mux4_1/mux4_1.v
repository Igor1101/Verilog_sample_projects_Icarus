module mux4_1(
    out, i0, i1, i2, i3, s0, s1
);
output out;
input i0, i1, i2, i3;
input s0, s1;
wire ns0, ns1;

not(ns0, s0);
not(ns1, s1);

wire ifi0, ifi1, ifi2, ifi3;

and(ifi0, i0, ns0, ns1);
and(ifi1, i1, s0, ns1);
and(ifi2, i2, ns0, s1);
and(ifi3, i3, s0, s1);

or(out, ifi0, ifi1, ifi2, ifi3);

endmodule