module one_bit_adder(S, A, B, Cin);
    input A, B, Cin;
    output S;
    xor Xor1(S, A, B, Cin);

endmodule