module simple_slave(
   clk,
	r_a, r_s, r_d,
	w_a, w_s, w_d);
	
input clk;
input [9:0] r_a;
input r_s = 1;
output reg [7:0] r_d;
input [9:0] w_a;
input w_s;
input [7:0] w_d;

reg [7:0] memory [0:1023];

initial $readmemh("mem.txt", memory);

always @(posedge clk) begin
	if (r_s)
		r_d <= memory[r_a];
	if (w_s)
		memory[w_a] <= w_d;
end

endmodule
