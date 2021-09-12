module adder_testbench ;
    reg a,b;
    wire s, co;
    half_adder ha(a, b, s, co);
    initial begin
        a = 1'b0;
        b = 1'b0;
    end
    always begin
        #5 
        a = 1'b1;
        b = 1'b0;

        #5 
        a = 1'b0;
        b = 1'b1;

        #5 
        a = 1'b1;
        b = 1'b1;
        #5 $finish;
    end
    // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,a);
        $dumpvars(0,b);
        $dumpvars(0,s);
        $dumpvars(0,co);
    end
endmodule