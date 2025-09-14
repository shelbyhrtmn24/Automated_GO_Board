module mult_ctrl (
    booth_bits, add, sub, shift
);

    input [2:0] booth_bits;
    output add, sub, shift;

    assign shift = (~booth_bits[2] & booth_bits[1] & booth_bits[0]) | (booth_bits[2] & ~booth_bits[1] & ~booth_bits[0]);
    assign sub = ~(booth_bits[1] & booth_bits[0]) & booth_bits[2];
    assign add = ~booth_bits[2] & (booth_bits[1] | booth_bits[0]);
    
endmodule