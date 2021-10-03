`include "../defs.v"
module test ;
    wire q, nq;
    reg Set, Reset;
    sr sr1(q, nq, ~Set, ~Reset);
    initial begin
        Set = 0;
        Reset = 0;
    end
    always begin
        $monitor($time, ": set %b, reset %b, q %b, nq %b", Set, Reset, q, nq);
         #5 Reset = 1;
        #5 Reset = 0;
         `assert(q, 0);
         `assert(nq, 1);
        #5 Set = 1;
        #5 Set = 0;
         `assert(q, 1);
         `assert(nq, 0);
        #1 $finish;
    end
      // gen additional files
    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars(0,q);
        $dumpvars(0,nq);
        $dumpvars(0,Set);
        $dumpvars(0,Reset);
    end
endmodule