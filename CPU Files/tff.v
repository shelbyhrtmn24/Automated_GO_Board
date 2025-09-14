module tff (
    toggle, out, clk, rst
);

input toggle, clk, rst;
output out;

wire inverted_t, w1, w2, dff_in, out_wire, inverted_out_wire;

not not_t(inverted_t, toggle);
not not_q(inverted_out_wire, out_wire);
and top(w1, out_wire, inverted_t);
and bottom(w2, toggle, inverted_out_wire);
or dff_input(dff_in, w1, w2);

dffe_ref dff(.q(out_wire), .d(dff_in), .clk(clk), .en(1'b1), .clr(rst));

assign out = out_wire;
    
endmodule