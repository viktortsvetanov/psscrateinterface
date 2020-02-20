module interface(clk,enable,RD/WR,reset,VPA,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,d0,d1,d2,d3,d4,d5,d6,d7,dataout);

input clk, enable, RD/WR, reset, VPA;
input a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
input d0, d1, d2, d3, d4, d5, d6, d7;

output reg [14:0] dataout; // LSB d0 to d7 + a0 to a6 MSB

reg [4:0] module_count;



initial 
	begin
	dataout = 15'd0; 
	module_count = 5'd0;
	end

always@(posedge clk)
	begin
	module_count <= module_count + 5'd1;
	if(module_count == 5'd21) //22 modules
		module_count <= 5'd0; // reset count after all modules
	end
	
always@(posedge reset || negedge reset)
	if(reset == 0)

endmodule
