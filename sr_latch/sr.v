module sr (
    Q, nQ, S,R
);
    
    output Q, nQ;
    input S,R;
    nand n1(Q,S, nQ);
    nand n2(nQ, R, Q); 
endmodule