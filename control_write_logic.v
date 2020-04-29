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
			A,
			D,
				);
			
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
input [9:0] A;
input [7:0] D;
//input a0,a1,a2,a3,a4,a5,a6,a7,a8,a9; // inputs for address / a0~a4 module select / a5~a6 Port select / a7~a9 valid module
//input d0,d1,d2,d3,d4,d5,d6,d7; // inputs for data

reg [0:24] count;
reg [31:0] temp;

wire [7:0] data;
wire [4:0] address;
wire [1:0] port;

assign data = {D};//{d7, d6, d5, d4, d3, d2, d1, d0}; // d7 MSB, d0 LSB
assign address = {A[4:0]};//{a4, a3, a2, a1, a0}; // a4 MSB, a0 LSB
assign port = {A[6:5]};//{a6, a5}; // a6 MSB


initial begin
	count = 25'd1; // counter
	user_write_buffer = 1'b0; // Write qualifer. Must be asserted to write data in.
	control_fixed = 1'b0; // Determines whether the master address will increment
	control_write_base = 32'h10004000; //base address
	control_write_length = 32'd12; //  multiple of datawidth in bytes //  Number of Bytes to transfer
	temp = 32'd30554432; // high value to delay
end

always@(posedge clk)
begin

if (count<temp) // perform a burst write every time count reaches temp
begin
	count <= count+25'd1; // increment counter
end


						control_go <= 1'b0; //
						if(count==temp && !user_buffer_full) // start transfer condition
							begin
									user_buffer_input <= {27'd0,~address}; // module value
									user_write_buffer <= 1'b1; //write qualifier
									control_go <= 1'b1; //get things started
									count <= temp+1;
							end
						if(count==(temp+1) && !user_buffer_full)
							begin
									user_buffer_input <= {30'd0,~port}; // port value
									count <= temp+2;
							end
						if(count==(temp+2) && !user_buffer_full)
							begin
									user_buffer_input <= data; // data value
									count <= temp+3;
							end
						if(count==(temp+3) && !user_buffer_full)
							begin
									count <= 0;
									control_go <= 1'b0; //reset control go
									user_write_buffer <= 1'b0; //reset user write buffer
							end

end

endmodule