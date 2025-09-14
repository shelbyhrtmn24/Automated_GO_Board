module mod_sixteen_counter_tb;

    reg clk, rst;
    wire [4:0] count;

    mod_sixteen_counter test(.clk(clk), .rst(rst), .count(count));
    initial begin
        clk = 0;
        #340;
        $finish;
    end

    always 
        #10 clk = ~clk;
    always @ (clk) begin
        #1;
        $display("%b %b %b %b %b", count[4], count[3], count[2], count[1], count[0]);
    end

endmodule