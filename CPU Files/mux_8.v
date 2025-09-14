module mux_8 (
    out, select, in0, in1, in2, in3, in4, in5, in6, in7
);
    input [2:0] select;
    input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output [31:0] out;
    wire [31:0] w1, w2;
    mux_4 first(.out(w1), .select(select[1:0]), .in0(in0), .in1(in1), .in2(in2), .in3(in3));
    mux_4 second(.out(w2), .select(select[1:0]), .in0(in4), .in1(in5), .in2(in6), .in3(in7));
    mux_2 third(.out(out), .select(select[2]), .in0(w1), .in1(w2));
endmodule