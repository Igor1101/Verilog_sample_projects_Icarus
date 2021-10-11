`include "../defs.v"
module adder_testbench ;
    reg clk;
    reg [3:0]a,b;
    reg ci;
    wire [3:0]s;
    wire co;
    full_adder4 fa(.a(a), .b(b), .c_in(ci), .sum(s), .c_out(co));
    initial begin
        a = 4'b0000;
        b = 4'b0000;
        ci = 1'b0;
    end
    always begin
        #1
        {a, b} = { 4'b1111, 4'b0000};
        #1
        `assert (s, 4'b1111);
        `assert (co, 0);
        #1
        {a, b} = { 4'b1111, 4'b0100};
        #1
        `assert (s, 4'b0011);
        `assert (co, 1);
        #1
        {a, b} = { 4'b1000, 4'b1000};
        #1
        `assert (s, 4'b0000);
        `assert (co, 1);

        ci = 1'b1;
        #1
        {a, b} = { 4'b1000, 4'b0001};
        #1
        `assert (s, 4'b1010);
        `assert (co, 0);
        #1
        {a, b} = { 4'b1111, 4'b1111};
        #1
        `assert (s, 4'b1111);
        `assert (co, 1);
        $display("testbech test successfull");
        # 1 $finish;
    end
    // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,a);
        $dumpvars(0,b);
        $dumpvars(0,ci);
        $dumpvars(0,s);
        $dumpvars(0,co);
    end
endmodule