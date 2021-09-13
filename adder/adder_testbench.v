`include "../defs.v"
module adder_testbench ;
    reg clk;
    reg a,b;
    wire s, co;
    half_adder ha(a, b, s, co);
    initial begin
        a = 1'b0;
        b = 1'b0;
    end
    always begin
        #1
        {a, b} = { 1'b1, 1'b0};
        #1
        `assert (s, 1);
        `assert (co, 0);
        #1
        {a, b} = { 1'b0, 1'b1};
        #1
        `assert (s, 1);
        `assert (co, 0);
        #1
        {a, b} = { 1'b1, 1'b1};
        #1
        `assert (s, 0);
        `assert (co, 1);
        # 5 $finish;
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