module full_cla (
    A, B, data_result, c_in, c_out
);

    input [31:0] A, B;
    input c_in;
    output [31:0] data_result;
    wire [3:0] G, P;
    output c_out;

    // First Adder
    eight_bit_cla first(.A(A[7:0]), .B(B[7:0]), .data_result(data_result[7:0]), .c_in(c_in), .G(G[0]), .P(P[0]));

    // Calculate c_8:
    wire c_8, w1;
    and (w1, P[0], c_in);
    or (c_8, G[0], w1);

    //Second Adder
    eight_bit_cla second(.A(A[15:8]), .B(B[15:8]), .data_result(data_result[15:8]), .c_in(c_8), .G(G[1]), .P(P[1]));

    //Calculate c_16:
    wire c_16, w2, w3;
    and (w2, P[1], G[0]);
    and (w3, P[1], P[0], c_in);
    or (c_16, G[1], w2, w3);

    //Third Adder
    eight_bit_cla third(.A(A[23:16]), .B(B[23:16]), .data_result(data_result[23:16]), .c_in(c_16), .G(G[2]), .P(P[2]));

    // c_24:
    wire c_24, w4, w5, w6;
    and (w4, P[2], G[1]);
    and (w5, P[2], P[1], G[0]);
    and (w6, P[2], P[1], P[0], c_in);
    or (c_24, G[2], w4, w5, w6);

    // Fourth Adder
    eight_bit_cla fourth(.A(A[31:24]), .B(B[31:24]), .data_result(data_result[31:24]), .c_in(c_24), .G(G[3]), .P(P[3]));

    // c_out (c_32)
    wire w7, w8, w9, w10;
    and (w7, P[3], G[2]);
    and (w8, P[3], P[2], G[1]);
    and (w9, P[3], P[2], P[1], G[0]);
    and (w10, P[3], P[2], P[1], P[0], c_in);
    or (c_out, G[3], w7, w8, w9, w10);
        
endmodule