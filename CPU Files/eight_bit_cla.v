module eight_bit_cla (
    A, B, data_result, c_in, G, P
);

    input [7:0] A, B;
    input c_in;
    output G, P;
    output [7:0] data_result;
    wire [7:0] g;
    wire [7:0] p;
    wire [7:0] c;

    // Create generate and propagate functions:
    or p0(p[0], A[0], B[0]);
    or p1(p[1], A[1], B[1]);
    or p2(p[2], A[2], B[2]);
    or p3(p[3], A[3], B[3]);
    or p4(p[4], A[4], B[4]);
    or p5(p[5], A[5], B[5]);
    or p6(p[6], A[6], B[6]);
    or p7(p[7], A[7], B[7]);

    and g0(g[0], A[0], B[0]);
    and g1(g[1], A[1], B[1]);
    and g2(g[2], A[2], B[2]);
    and g3(g[3], A[3], B[3]);
    and g4(g[4], A[4], B[4]);
    and g5(g[5], A[5], B[5]);
    and g6(g[6], A[6], B[6]);
    and g7(g[7], A[7], B[7]);

    // Calculate P:
    and BigP(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);

    // Calculate G:
    wire t1;
    and pain1(t1, p[7], g[6]);

    wire t2;
    and pain2(t2, p[7], p[6], g[5]);

    wire t3;
    and pain3(t3, p[7], p[6], p[5], g[4]);

    wire t4;
    and pain4(t4, p[7], p[6], p[5], p[4], g[3]);

    wire t5;
    and pain5(t5, p[7], p[6], p[5], p[4], p[3], g[2]);

    wire t6;
    and pain6(t6, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);

    wire t7;
    and pain7(t7, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);

    or BigG(G, g[7], t1, t2, t3, t4, t5, t6, t7);

    //Calculate carry-ins for each one-bit adder (including the output c8):
    wire G_0, P_0;
    assign G_0 = G;
    assign P_0 = P;

    //c[0] = c_in
    assign c[0] = c_in;

    //c[1]:
    wire w1;
    and (w1, p[0], c[0]);
    or (c[1], g[0], w1);

    //c[2]:
    wire w2, w3;
    and (w2, p[1], g[0]);
    and (w3, p[1], p[0], c[0]);
    or (c[2], g[1], w2, w3);

    //c[3]:
    wire w4, w5, w6;
    and (w4, p[2], g[1]);
    and (w5, p[2], p[1], g[0]);
    and (w6, p[2], p[1], p[0], c[0]);
    or (c[3], g[2], w4, w5, w6);

    //c[4]:
    wire w7, w8, w9, w10;
    and (w7, p[3], g[2]);
    and (w8, p[3], p[2], g[1]);
    and (w9, p[3], p[2], p[1], g[0]);
    and (w10, p[3], p[2], p[1], p[0], c[0]);
    or (c[4], g[3], w7, w8, w9, w10); 

    //c[5]:
    wire w11, w12, w13, w14, w15;
    and (w11, p[4], g[3]);
    and (w12, p[4], p[3], g[2]);
    and (w13, p[4], p[3], p[2], g[1]);
    and (w14, p[4], p[3], p[2], p[1], g[0]);
    and (w15, p[4], p[3], p[2], p[1], p[0], c[0]);
    or (c[5], g[4], w11, w12, w13, w14, w15);

    //c[6]:
    wire w16, w17, w18, w19, w20, w21;
    and (w16, p[5], g[4]);
    and (w17, p[5], p[4], g[3]);
    and (w18, p[5], p[4], p[3], g[2]);
    and (w19, p[5], p[4], p[3], p[2], g[1]);
    and (w20, p[5], p[4], p[3], p[2], p[1], g[0]);
    and (w21, p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
    or (c[6], g[5], w16, w17, w18, w19, w20, w21);

    //c[7]:
    wire w22, w23, w24, w25, w26, w27, w28;
    and (w22, p[6], g[5]);
    and (w23, p[6], p[5], g[4]);
    and (w24, p[6], p[5], p[4], g[3]);
    and (w25, p[6], p[5], p[4], p[3], g[2]);
    and (w26, p[6], p[5], p[4], p[3], p[2], g[1]);
    and (w27, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and (w28, p[6], p[5], p[4], p[3], p[2], p[1], p[0], c[0]);
    or (c[7], g[6], w22, w23, w24, w25, w26, w27, w28);

    // Get S:
    one_bit_adder adder0(.S(data_result[0]), .A(A[0]), .B(B[0]), .Cin(c[0]));
    one_bit_adder adder1(.S(data_result[1]), .A(A[1]), .B(B[1]), .Cin(c[1]));
    one_bit_adder adder2(.S(data_result[2]), .A(A[2]), .B(B[2]), .Cin(c[2]));
    one_bit_adder adder3(.S(data_result[3]), .A(A[3]), .B(B[3]), .Cin(c[3]));
    one_bit_adder adder4(.S(data_result[4]), .A(A[4]), .B(B[4]), .Cin(c[4]));
    one_bit_adder adder5(.S(data_result[5]), .A(A[5]), .B(B[5]), .Cin(c[5]));
    one_bit_adder adder6(.S(data_result[6]), .A(A[6]), .B(B[6]), .Cin(c[6]));
    one_bit_adder adder7(.S(data_result[7]), .A(A[7]), .B(B[7]), .Cin(c[7]));

endmodule