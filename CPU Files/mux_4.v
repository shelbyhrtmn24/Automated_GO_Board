module mux_4 (
    out, select, in0, in1, in2, in3
);
    input [1:0] select;
    input [31:0] in0, in1, in2, in3;
    output [31:0] out;
    wire [31:0] w1, w2;
    mux_2 first_top(.out(w1), .select(select[0]), .in0(in0), .in1(in1));
    mux_2 first_bottom(.out(w2), .select(select[0]), .in0(in2), .in1(in3));
    mux_2 final(.out(out), .select(select[1]), .in0(w1), .in1(w2)); 
endmodule
