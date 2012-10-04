module mult(x,y,z);
parameter N = 16;
input [N-1:0] x;
//PARAM
input [N-1:0] y;
//PARAM
output [2*N-1:0]z;

assign z = x * y;
endmodule