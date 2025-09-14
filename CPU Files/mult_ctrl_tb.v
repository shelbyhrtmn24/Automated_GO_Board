module mult_ctrl_tb;

    reg [2:0] booth_bits;
    wire add, sub, shift;

    // I'm so tired.
    mult_ctrl test(.booth_bits(booth_bits), .add(add), .sub(sub), .shift(shift));

    initial begin
        booth_bits = 3'b0;
        #80;
        $finish;
    end

    always 
        #10 booth_bits[0] = ~booth_bits[0];
    always 
        #20 booth_bits[1] = ~booth_bits[1];
    always
        #40 booth_bits[2] = ~booth_bits[2];
    always @ (booth_bits) begin
        #1;
        $display("%b %b %b => add:%b, sub:%b, shift:%b", booth_bits[2], booth_bits[1], booth_bits[0], add, sub, shift);
    end

endmodule