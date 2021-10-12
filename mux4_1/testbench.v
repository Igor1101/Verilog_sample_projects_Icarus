`include "../defs.v"
module test ;
    reg s0, s1, i0, i1, i2, i3;
    wire out;
    mux4_1 mx(out, i0, i1, i2, i3, s0, s1);
    initial begin
        s0 = 0;
        s1 = 0;
        i0 = 1;
        i1 = 0;
        i2 = 1;
        i3 = 0;
    end
    always begin
        $monitor($time, ": s0 %b, s1 %b, i0 %b, i1 %b, i2 %b, i3 %b, out %b", 
        s0, s1, i0, i1, i2, i3, out);
         #5 
         s0 = 0;
         s1 = 0;
         i0 = 1;
         i1 = 0;
         i2 = 1;
         i3 = 0;
        #5 
         `assert(out, 1);
        #5 s0 = 1;
        #5 
         `assert(out, 0);
        #5 
        s1 = 1;
        s0 = 0;
        #5 
         `assert(out, 1);
        #5 
        s1 = 1;
        s0 = 1;
        #5 
         `assert(out, 0);
        #1 $finish;
    end
      // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,out);
        $dumpvars(0,s0);
        $dumpvars(0,s1);
        $dumpvars(0,i0);
        $dumpvars(0,i1);
        $dumpvars(0,i2);
        $dumpvars(0,i3);
    end
endmodule