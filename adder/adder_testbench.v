`include "../defs.v"
module adder_testbench ;
    reg clk;
    reg a,b, ci;
    wire sf, cof;
    wire sh, coh;
    half_adder ha(a, b, sh, coh);
    full_adder fa(a, b, ci, sf, cof);
    initial begin
        a = 1'b0;
        b = 1'b0;
        ci = 1'b0;
    end
    always begin
        #1
        {a, b} = { 1'b1, 1'b0};
        #1
        `assert (sh, 1);
        `assert (coh, 0);
        `assert (sf, 1);
        `assert (cof, 0);
        #1
        {a, b} = { 1'b0, 1'b1};
        #1
        `assert (sh, 1);
        `assert (coh, 0);
        `assert (sf, 1);
        `assert (cof, 0);
        #1
        {a, b} = { 1'b1, 1'b1};
        #1
        `assert (sh, 0);
        `assert (coh, 1);
        `assert (sf, 0);
        `assert (cof, 1);

        ci = 1'b1;
        #1
        {a, b} = { 1'b1, 1'b0};
        #1
        `assert (sh, 1);
        `assert (coh, 0);
        `assert (sf, 0);
        `assert (cof, 1);
        #1
        {a, b} = { 1'b0, 1'b1};
        #1
        `assert (sh, 1);
        `assert (coh, 0);
        `assert (sf, 0);
        `assert (cof, 1);
        #1
        {a, b} = { 1'b1, 1'b1};
        #1
        `assert (sh, 0);
        `assert (coh, 1);
        `assert (sf, 1);
        `assert (cof, 0);
        # 1 $finish;
    end
    // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,a);
        $dumpvars(0,b);
        $dumpvars(0,ci);
        $dumpvars(0,sf);
        $dumpvars(0,cof);
        $dumpvars(0,sh);
        $dumpvars(0,coh);
    end
endmodule