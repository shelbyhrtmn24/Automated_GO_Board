module exception_check (
    A, exception
);

input [32:0] A;
output exception;
wire temp, temp2, allzero, allone;

assign allone = &A;
assign temp = |A;
assign allzero = ~temp;
assign temp2 = allone | allzero;
assign exception = ~temp2;
    
endmodule