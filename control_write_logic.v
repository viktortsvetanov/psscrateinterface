module control_write_logic (
			clk,
			control_fixed,
			control_go,
			control_write_base,
			control_write_length,
			user_buffer_input,
			user_write_buffer,
			control_done,
			user_buffer_full,
			transfer,
			a0,
			a1,
			a2,
			a3,
			a4,
			a5,
			a6,
			a7,
			a8,
			a9,
			d0,
			d1,
			d2,
			d3,
			d4,
			d5,
			d6,
			d7);
			
input clk;

output reg control_fixed;
output reg control_go;
output reg [31:0] control_write_base;//
output reg [31:0] control_write_length;//
output reg [31:0] user_buffer_input;// try 8 bit? (was 32)
output reg user_write_buffer;

input wire control_done;
input wire user_buffer_full;
input wire transfer;
input a0,a1,a2,a3,a4,a5,a6,a7,a8,a9; // inputs for address / a0~a4 module select / a5~a6 Port select / a7~a9 valid module
input d0,d1,d2,d3,d4,d5,d6,d7; // inputs for data

reg [0:24] count;
reg [31:0] temp;

wire [7:0] data;
wire [4:0] address;
wire [1:0] port;

assign data = {d7, d6, d5, d4, d3, d2, d1, d0}; // d7 MSB, d0 LSB
assign address = {a4, a3, a2, a1, a0}; // a4 MSB, a0 LSB
assign port = {a6, a5}; // a6 MSB


initial begin
	count = 25'd1;
	user_write_buffer = 1'b0;
	temp = 32'd30554432; //about 2/3 into 1 second / copypaste from another project
	control_fixed = 1'b0;
	control_write_base = 32'h10004000; //base address
	control_write_length = 32'd8; //  multiple of datawidth in bytes //  2 x 4 byte words
end

always@(posedge clk)
begin

if (count<temp)
begin
	count <= count+25'd1; // copy/paste from other project
end

	

case(address) // go through all modules
	5'b11110: begin // inverted / Module 1
					case(port) // go through all 3 ports
					2'b11: begin // inverted // Port A
						if(count==temp && !user_buffer_full) // start transfer condition
							begin
									user_buffer_input <= 32'h1; // module value
									user_write_buffer <= 1'b1; //write qualifier
									control_go <= 1'b1; //get things started
									count <= temp+1;
							end
						if(count==(temp+1))
							begin
									user_buffer_input <= 32'hA; // port value
									count <= temp+2;
							end
//						if(count==(temp+2))
//							begin
//									user_buffer_input <= data; // data value
//									count <= temp+3;
//							end
						if(count==(temp+2))
							begin
									count <= 0; //reset count
									control_go <= 1'b0; //reset control go
									user_write_buffer <= 1'b0; //reset user write buffer
							end
						end // end for 2'b11
						
//						
//					2'b10: begin // inverted // Port B
//						if(count==(temp+4)) 
//							begin
//									user_buffer_input <= 32'd1; // address value
//									count <= temp+5;
//							end
//						if(count==(temp+5))
//							begin
//								user_buffer_input <= 32'hB; // port value
//								count <= temp+6;
//							end
//						if(count==(temp+6))
//							begin
//								user_buffer_input <= data; // data value
//								count <= temp+7;
//							end
//	//					if(count==(temp+7))
//	//						begin
//	//							count <= temp+8; //reset count
//	//							control_go <= 1'b0; //reset control go
//	//							user_write_buffer <= 1'b0; //reset user write buffer
//	//						end
//						end // end for 2'b10
//						
//						
//					2'b01: begin // inverted //  Port C
//						if(count==(temp+8)) 
//							begin
//									user_buffer_input <= 32'd1; // address value
//									count <= temp+9;
//							end
//						if(count==(temp+9))
//							begin
//								user_buffer_input <= 32'hC; // port value
//								count <= temp+10;
//							end
//						if(count==(temp+10))
//							begin
//								user_buffer_input <= data; // data value
//								count <= temp+11;
//							end
//						if(count==(temp+11))
//							begin
//								count <= 0; //reset count
//								control_go <= 1'b0; //reset control go
//								user_write_buffer <= 1'b0; //reset user write buffer
//							end
//						end // end for 2'b01
						endcase // end for case port
						
				 end		// end for Module 1
				 endcase // end for address case
				 




end









endmodule
