module lfsr (
    CLK, RST, Q
);
    
    input CLK, RST;
    output reg[3:0] Q;
    integer i;
    
    always @ (posedge CLK) begin
        if (RST == 1)
            Q = 4'b1111;
        else begin
            for (i=1 ; i < 4 ; i=i+1) begin
                Q[i] = Q[i-1];
            end
            Q[0] = Q[3] ^ Q[2];
        end
    end
endmodule