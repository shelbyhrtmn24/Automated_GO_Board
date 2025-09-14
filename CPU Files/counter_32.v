module counter_32 (
    rst, clk, count
);

input clk, rst;
output [5:0] count;

tff tff0(.toggle(1'b1), .clk(clk), .rst(rst), .out(count[0]));
tff tff1(.toggle(count[0]), .clk(clk), .rst(rst), .out(count[1]));
tff tff2(.toggle(count[0] & count[1]), .clk(clk), .rst(rst), .out(count[2]));
tff tff3(.toggle(count[0] & count[1] & count[2]), .clk(clk), .rst(rst), .out(count[3]));
tff tff4(.toggle(count[0] & count[1] & count[2] & count[3]), .clk(clk), .rst(rst), .out(count[4]));
tff tff5(.toggle(count[0] & count[1] & count[2] & count[3] & count[4]), .clk(clk), .rst(rst), .out(count[5]));
    
endmodule