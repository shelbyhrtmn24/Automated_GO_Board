module lfsr_wrapper (
    CLK100MHZ, LED, BTNC, BTNU
);

    input CLK100MHZ, BTNC, BTNU;
    output[4:0] LED;
    wire locked, reset, clk;
    wire[3:0] lfsr_out;

    clk_wiz_0 clkwiz(.clk_in1(CLK100MHZ), .clk_out1(clk), .reset(reset), .locked(locked));

    lfsr lfsr_unit(.CLK(clk), .RST(BTNC), .Q(lfsr_out));
    
    assign LED[4] = 1'b1;
    
    dffe_ref dff(.d(lfsr_out), .q(LED[3:0]), .clk(clk), .en(BTNU), .clr(1'b0));
    
endmodule