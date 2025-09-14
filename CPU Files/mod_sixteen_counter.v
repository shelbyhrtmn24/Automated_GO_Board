module mod_sixteen_counter (
    clk, count, rst
);

    input clk, rst;
    output [4:0] count;

    wire q0_wire, q1_wire, q2_wire, q3_wire;

    tff tff0(.toggle(1'b1), .clk(clk), .rst(rst), .out(count[0]));
    tff tff1(.toggle(count[0]), .clk(clk), .rst(rst), .out(count[1]));
    tff tff2(.toggle(count[0] & count[1]), .clk(clk), .rst(rst), .out(count[2]));
    tff tff3(.toggle(count[2] & count[1] & count[0]), .clk(clk), .rst(rst), .out(count[3]));
    tff tff4(.toggle(count[3] & count[2] & count[1] & count[0]), .clk(clk), .rst(rst), .out(count[4]));
    
endmodule