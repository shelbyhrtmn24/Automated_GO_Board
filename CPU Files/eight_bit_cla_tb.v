`timescale 10 ns /100 ps
module eight_bit_cla_tb ();
    
    wire [7:0] A, B;
    wire [7:0] S;
    wire G, P;

    eight_bit_cla test(.A(A), .B(B), .c_in(1'b0), .G(G), .P(P), .data_result(S));

    integer i;
    assign {A, B} = i[15:0];
    initial begin
        for(i=0; i<65536; i=i+1) begin
            #20;
            $display("A:%b, B:%b, S:%b", A, B, S);
        end
        $finish;
    end
    
endmodule