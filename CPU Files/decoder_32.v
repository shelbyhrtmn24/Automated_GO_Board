module decoder_32 (
    out, select, enable
);
    input enable;
    input [4:0] select;
    output [31:0] out;

    assign out = enable << select;
    // out = which wire in 32-bit bus is on, i.e. select = 3 means third wire on, all others give 0
endmodule