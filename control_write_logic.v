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
output reg [31:0] control_write_base;
output reg [31:0] control_write_length;
output reg [31:0] user_buffer_input;
output reg user_write_buffer;

input wire control_done;
input wire user_buffer_full;
input wire transfer;
input a0,a1,a2,a3,a4,a5,a6,a7,a8,a9; // inputs for address / a0~a4 module select / a5~a6 Port select / a7~a9 valid module
input d0,d1,d2,d3,d4,d5,d6,d7; // inputs for data

reg [0:24] count;
reg [31:0] temp;
reg [4:0] mod; // module
reg [1:0] port_value; // port 1,2,3 or 4

wire [7:0] data;
wire [4:0] address;
wire [1:0] port;

assign data = {d7, d6, d5, d4, d3, d2, d1, d0}; // d7 MSB, d0 LSB
assign address = {a4, a3, a2, a1, a0}; // a4 MSB, a0 LSB
assign port = {a6, a5}; // a6 MSB


initial begin
	count = 25'd1;
	user_write_buffer = 1'b0;
	temp = 32'd30554432; //about 2/3 into 1 second
	control_fixed = 1'b0;
	control_write_base = 32'h10004000; //base address
	control_write_length = 32'd12; //12 bytes to send
	mod = 5'd0;
	port_value = 2'd0;
//	data = 8'h0;
//	address = 7'h0;
end

always@(posedge clk)
begin

if (count<temp)
begin
	count <= count+25'd1;
end

	

case(address)
	5'b00001: begin
					case(port)
					2'b00: begin
						if(count==temp && !user_buffer_full) // start transfer condition
							begin
									user_buffer_input <= 32'd1; // address value
									user_write_buffer <= 1'b1; //write qualifier
									control_go <= 1'b1; //get things started
									count <= temp+1;
							end
						if(count==(temp+1))
							begin
								user_buffer_input <= 32'd0; // port value
								count <= temp+2;
							end
						if(count==(temp+2))
							begin
								user_buffer_input <= data; // data value
								count <= temp+3;
								control_go <= 1'b0;
								user_write_buffer <= 1'b0;
							end
						if(count==(temp+3))
							begin
								count <= 0; //reset count
								control_go <= 1'b0; //reset control go
								user_write_buffer <= 1'b0; //reset user write buffer
							end
						end // end for 2'b00
						
						
					2'b01: begin
						if(count==temp && !user_buffer_full) // start transfer condition
							begin
									user_buffer_input <= 32'd1; // address value
									user_write_buffer <= 1'b1; //write qualifier
									control_go <= 1'b1; //get things started
									count <= temp+1;
							end
						if(count==(temp+1))
							begin
								user_buffer_input <= 32'd1; // port value
								count <= temp+2;
							end
						if(count==(temp+2))
							begin
								user_buffer_input <= data; // data value
								count <= temp+3;
								control_go <= 1'b0;
								user_write_buffer <= 1'b0;
							end
						if(count==(temp+3))
							begin
								count <= 0; //reset count
								control_go <= 1'b0; //reset control go
								user_write_buffer <= 1'b0; //reset user write buffer
							end
						end // end for 2'b01
						
						
					2'b10: begin
						if(count==temp && !user_buffer_full) // start transfer condition
							begin
									user_buffer_input <= 32'd1; // address value
									user_write_buffer <= 1'b1; //write qualifier
									control_go <= 1'b1; //get things started
									count <= temp+1;
							end
						if(count==(temp+1))
							begin
								user_buffer_input <= 32'd2; // port value
								count <= temp+2;
							end
						if(count==(temp+2))
							begin
								user_buffer_input <= data; // data value
								count <= temp+3;
								control_go <= 1'b0;
								user_write_buffer <= 1'b0;
							end
						if(count==(temp+3))
							begin
								count <= 0; //reset count
								control_go <= 1'b0; //reset control go
								user_write_buffer <= 1'b0; //reset user write buffer
							end
						end // end for 2'b10
						endcase // end for case port
						
				 end		
				 endcase // end for address case
				 




end









endmodule
