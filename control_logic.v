module control_logic (
			clk,
			A,
			D,
			we,
			enable,
			vpa,
			reset,
			key0,
			control_fixed_0,
			control_write_base_0,
			control_write_length_0,
			control_go_0,
			user_write_buffer_0,
			user_buffer_input_0,
			control_done_0,
			user_buffer_full_0,
			control_fixed_location_1,
			control_read_base_1,
			control_read_length_1,
			control_go_1,
			control_done_1,
			control_early_done_1,
			user_read_buffer_1,
			user_buffer_data_1,
			user_data_available_1
				);
				
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Clock ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////	
		
input clk;

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Outputs /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

output reg control_fixed_0;
output reg control_go_0;
output reg [31:0] control_write_base_0;
output reg [31:0] control_write_length_0;
output reg [31:0] user_buffer_input_0;
output reg user_write_buffer_0;
output reg control_fixed_location_1;
output reg control_go_1;
output reg [31:0] control_read_base_1;
output reg [31:0] control_read_length_1;
output reg user_read_buffer_1;
output reg we; // Read/~Write
output reg enable; // Enable
output reg reset; // Reset

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Inputs //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

input wire control_done_0;
input wire user_buffer_full_0;
input wire [31:0] user_buffer_data_1;
input wire control_done_1;
input wire control_early_done_1;
input wire user_data_available_1;
input wire vpa; // Valid peripheral insert check / hardware
input wire key0; // Key

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Bidirectional ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

inout [7:0] D; // Data
inout [9:0] A; // Address


/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Regs ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

reg [0:24] count;
reg [31:0] temp;
reg [7:0] dataw;
reg [9:0] addressw;
reg [21:0] zeros22;
reg [23:0] zeros24;

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Wires ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

wire [7:0] data;
wire [9:0] address;
wire we_q;
wire reset_q;

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Assignments /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

// if enable set to low, write enable goes low, else write enable high
assign we_q = (~enable) ? 0 : 1; 
// if write enable goes low, data becomes output (write), else data tri-state
assign D = (~we_q) ? dataw : 8'bzzzz_zzzz; 
// if write enable goes low, address becomes output (write), else address tri-state
assign A = (~we_q) ? addressw : 10'bzz_zzzz_zzzz; 
//if write enable goes high, data becomes input, else zero
assign data = (we_q) ? D : 8'd0;
//if write enable goes high, address becomes input, else zero
assign address = (we_q) ? A : 10'd0;
// if key press, reset, else not
assign reset_q = (key0) ? 0 : 1;

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Initialisation //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

initial begin
	count = 25'd1; // Counter to 33_554_431 decimal
	user_write_buffer_0 = 1'b0; // Write qualifer. Must be asserted to write data in.
	control_fixed_0 = 1'b0; // Determines whether the master address will increment
	control_write_base_0 = 32'h10004000; // Base address
	control_write_length_0 = 32'd704; // Number of Bytes to transfer
	control_fixed_location_1 = 1'b0; // Determines whether the master address will increment
	control_read_base_1 = 32'h10004000; // Base address
	control_read_length_1= 32'd704; // Number of Bytes to transfer
	user_read_buffer_1=1'b0; // Read qualifer
	temp = 32'd30554432; // High value to delay
	enable = 1; // Initialise to data read
	reset = 1;
	we = 1;
end

always@(posedge clk)
begin

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Counter /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

	if (count<temp) // perform a burst write every time count reaches temp
	begin
		count <= count+25'd1; // increment counter
	end
	
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Reset ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

	if (~reset_q) 
	begin
		count <= 25'd0;
		reset <= reset_q;
	end
	else begin
		reset <= 1;
	end
	
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Data read ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

	if (count == 25'd0)
	begin
		enable <= 1; // switch to read
		we <= we_q;
		control_go_0 <= 1'b0; 
		
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
		casez(address) // treats z as don't care
			10'bzz_z001_1110:
				begin
								if(count==temp && !user_buffer_full_0) // start transfer condition
									begin
											user_buffer_input_0 <= 7'b001_1110; // Port 0 Module 1
											user_write_buffer_0 <= 1'b1; //write qualifier
											control_go_0 <= 1'b1; // start pulse
											count <= temp+1;
									end
							
								if(count==(temp+1) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											control_go_0 <= 1'b0; // end 1 clock cycle pulse
											count <= temp+2;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
			10'bzz_z011_1110:
				begin
								if(count==(temp+2) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_1110; // Port 1 Module 1
											count <= temp+3;
									end
							
								if(count==(temp+3) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+4;
									end	
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_1110:
				begin
								if(count==(temp+4) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_1110; // Port 2 Module 1
											count <= temp+5;
									end
							
								if(count==(temp+5) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+6;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_1110:
				begin
								if(count==(temp+6) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_1110; // Port 3 Module 1
											count <= temp+7;
									end
							
								if(count==(temp+7) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+8;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
			10'bzz_z001_1101:
				begin
								if(count==(temp+8) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_1101; // Port 0 Module 2
											count <= temp+9;
									end
							
								if(count==(temp+9) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+10;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_1101:
				begin
								if(count==(temp+10) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_1101; // Port 1 Module 2
											count <= temp+11;
									end
							
								if(count==(temp+11) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+12;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_1101:
				begin
								if(count==(temp+12) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_1101; // Port 2 Module 2
											count <= temp+13;
									end
							
								if(count==(temp+13) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+14;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_1101:
				begin
								if(count==(temp+14) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_1101; // Port 3 Module 2
											count <= temp+15;
									end
							
								if(count==(temp+15) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+16;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_1100:
				begin
								if(count==(temp+16) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_1100; // Port 0 Module 3
											count <= temp+17;
									end
							
								if(count==(temp+17) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+18;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_1100:
				begin
								if(count==(temp+18) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_1100; // Port 1 Module 3
											count <= temp+19;
									end
							
								if(count==(temp+19) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+20;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_1100:
				begin
								if(count==(temp+20) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_1100; // Port 2 Module 3
											count <= temp+21;
									end
							
								if(count==(temp+21) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+22;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_1100:
				begin
								if(count==(temp+22) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_1100; // Port 3 Module 3
											count <= temp+23;
									end
							
								if(count==(temp+23) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+24;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_1011:
				begin
								if(count==(temp+24) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_1011; // Port 0 Module 4
											count <= temp+25;
									end
							
								if(count==(temp+25) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+26;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_1011:
				begin
								if(count==(temp+26) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_1011; // Port 1 Module 4
											count <= temp+27;
									end
							
								if(count==(temp+27) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+28;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_1011:
				begin
								if(count==(temp+28) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_1011; // Port 2 Module 4
											count <= temp+29;
									end
							
								if(count==(temp+29) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+30;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_1011:
				begin
								if(count==(temp+30) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_1011; // Port 3 Module 4
											count <= temp+31;
									end
							
								if(count==(temp+31) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+32;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_1010:
				begin
								if(count==(temp+32) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_1010; // Port 0 Module 5
											count <= temp+33;
									end
							
								if(count==(temp+33) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+34;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_1010:
				begin
								if(count==(temp+34) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_1010; // Port 1 Module 5
											count <= temp+35;
									end
							
								if(count==(temp+35) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+36;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_1010:
				begin
								if(count==(temp+36) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_1010; // Port 2 Module 5
											count <= temp+37;
									end
							
								if(count==(temp+37) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+38;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_1010:
				begin
								if(count==(temp+38) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_1010; // Port 3 Module 5
											count <= temp+39;
									end
							
								if(count==(temp+39) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+40;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_1001:
				begin
								if(count==(temp+40) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_1001; // Port 0 Module 6
											count <= temp+41;
									end
							
								if(count==(temp+41) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+42;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_1001:
				begin
								if(count==(temp+42) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_1001; // Port 1 Module 6
											count <= temp+43;
									end
							
								if(count==(temp+43) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+44;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_1001:
				begin
								if(count==(temp+44) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_1001; // Port 2 Module 6
											count <= temp+45;
									end
							
								if(count==(temp+45) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+46;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_1001:
				begin
								if(count==(temp+46) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_1001; // Port 3 Module 6
											count <= temp+47;
									end
							
								if(count==(temp+47) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+48;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_1000:
				begin
								if(count==(temp+48) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_1000; // Port 0 Module 7
											count <= temp+49;
									end
							
								if(count==(temp+49) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+50;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_1000:
				begin
								if(count==(temp+50) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_1000; // Port 1 Module 7
											count <= temp+51;
									end
							
								if(count==(temp+51) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+52;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_1000:
				begin
								if(count==(temp+52) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_1000; // Port 2 Module 7
											count <= temp+53;
									end
							
								if(count==(temp+53) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+54;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_1000:
				begin
								if(count==(temp+54) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_1000; // Port 3 Module 7
											count <= temp+55;
									end
							
								if(count==(temp+55) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+56;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_0111:
				begin
								if(count==(temp+56) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_0111; // Port 0 Module 8
											count <= temp+57;
									end
							
								if(count==(temp+57) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+58;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_0111:
				begin
								if(count==(temp+58) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_0111; // Port 1 Module 8
											count <= temp+59;
									end
							
								if(count==(temp+59) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+60;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_0111:
				begin
								if(count==(temp+60) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_0111; // Port 2 Module 8
											count <= temp+61;
									end
							
								if(count==(temp+61) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+62;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_0111:
				begin
								if(count==(temp+62) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_0111; // Port 3 Module 8
											count <= temp+63;
									end
							
								if(count==(temp+63) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+64;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
			10'bzz_z001_0110:
				begin
								if(count==(temp+64) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_0110; // Port 0 Module 9
											count <= temp+65;
									end
							
								if(count==(temp+65) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+66;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_0110:
				begin
								if(count==(temp+66) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_0110; // Port 1 Module 9
											count <= temp+67;
									end
							
								if(count==(temp+67) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+68;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_0110:
				begin
								if(count==(temp+68) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_0110; // Port 2 Module 9
											count <= temp+69;
									end
							
								if(count==(temp+69) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+70;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_0110:
				begin
								if(count==(temp+70) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_0110; // Port 3 Module 9
											count <= temp+71;
									end
							
								if(count==(temp+71) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+72;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_0101:
				begin
								if(count==(temp+72) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_0101; // Port 0 Module 10
											count <= temp+73;
									end
							
								if(count==(temp+73) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+74;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_0101:
				begin
								if(count==(temp+74) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_0101; // Port 1 Module 10
											count <= temp+75;
									end
							
								if(count==(temp+75) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+76;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_0101:
				begin
								if(count==(temp+76) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_0101; // Port 2 Module 10
											count <= temp+77;
									end
							
								if(count==(temp+77) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+78;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_0101:
				begin
								if(count==(temp+78) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_0101; // Port 3 Module 10
											count <= temp+79;
									end
							
								if(count==(temp+79) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+80;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
			10'bzz_z001_0100:
				begin
								if(count==(temp+80) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_0100; // Port 0 Module 11
											count <= temp+81;
									end
							
								if(count==(temp+81) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+82;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_0100:
				begin
								if(count==(temp+82) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_0100; // Port 1 Module 11
											count <= temp+83;
									end
							
								if(count==(temp+83) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+84;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_0100:
				begin
								if(count==(temp+84) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_0100; // Port 2 Module 11
											count <= temp+85;
									end
							
								if(count==(temp+85) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+86;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_0100:
				begin
								if(count==(temp+86) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_0100; // Port 3 Module 11
											count <= temp+87;
									end
							
								if(count==(temp+87) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+88;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_0011:
				begin
								if(count==(temp+88) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_0011; // Port 0 Module 12
											count <= temp+89;
									end
							
								if(count==(temp+89) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+90;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_0011:
				begin
								if(count==(temp+90) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_0011; // Port 1 Module 12
											count <= temp+91;
									end
							
								if(count==(temp+91) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+92;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_0011:
				begin
								if(count==(temp+92) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_0011; // Port 2 Module 12
											count <= temp+93;
									end
							
								if(count==(temp+93) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+94;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_0011:
				begin
								if(count==(temp+94) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_0011; // Port 3 Module 12
											count <= temp+95;
									end
							
								if(count==(temp+95) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+96;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z001_0010:
				begin
								if(count==(temp+96) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_0010; // Port 0 Module 13
											count <= temp+97;
									end
							
								if(count==(temp+97) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+98;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_0010:
				begin
								if(count==(temp+98) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_0010; // Port 1 Module 13
											count <= temp+99;
									end
							
								if(count==(temp+99) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+100;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_0010:
				begin
								if(count==(temp+100) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_0010; // Port 2 Module 13
											count <= temp+101;
									end
							
								if(count==(temp+101) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+102;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_0010:
				begin
								if(count==(temp+102) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_0010; // Port 3 Module 13
											count <= temp+103;
									end
							
								if(count==(temp+103) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+104;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
			10'bzz_z001_0001:
				begin
								if(count==(temp+104) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_0001; // Port 0 Module 14
											count <= temp+105;
									end
							
								if(count==(temp+105) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+106;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_0001:
				begin
								if(count==(temp+106) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_0001; // Port 1 Module 14
											count <= temp+107;
									end
							
								if(count==(temp+107) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+108;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_0001:
				begin
								if(count==(temp+108) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_0001; // Port 2 Module 14
											count <= temp+109;
									end
							
								if(count==(temp+109) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+110;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_0001:
				begin
								if(count==(temp+110) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_0001; // Port 3 Module 14
											count <= temp+111;
									end
							
								if(count==(temp+111) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+112;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
			10'bzz_z001_0000:
				begin
								if(count==(temp+112) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b001_0000; // Port 0 Module 15
											count <= temp+113;
									end
							
								if(count==(temp+113) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+114;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z011_0000:
				begin
								if(count==(temp+114) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b011_0000; // Port 1 Module 15
											count <= temp+115;
									end
							
								if(count==(temp+115) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+116;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z101_0000:
				begin
								if(count==(temp+116) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b101_0000; // Port 2 Module 15
											count <= temp+117;
									end
							
								if(count==(temp+117) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+118;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z111_0000:
				begin
								if(count==(temp+118) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b111_0000; // Port 3 Module 15
											count <= temp+119;
									end
							
								if(count==(temp+119) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+120;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
			10'bzz_z000_1111:
				begin
								if(count==(temp+120) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b000_1111; // Port 0 Module 16
											count <= temp+121;
									end
							
								if(count==(temp+121) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+122;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z010_1111:
				begin
								if(count==(temp+122) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b010_1111; // Port 1 Module 16
											count <= temp+123;
									end
							
								if(count==(temp+123) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+124;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z100_1111:
				begin
								if(count==(temp+124) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b100_1111; // Port 2 Module 16
											count <= temp+125;
									end
							
								if(count==(temp+125) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+126;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z110_1111:
				begin
								if(count==(temp+126) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b110_1111; // Port 3 Module 16
											count <= temp+127;
									end
							
								if(count==(temp+127) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+128;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z000_1110:
				begin
								if(count==(temp+128) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b000_1110; // Port 0 Module 17
											count <= temp+129;
									end
							
								if(count==(temp+129) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+130;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z010_1110:
				begin
								if(count==(temp+130) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b010_1110; // Port 1 Module 17
											count <= temp+131;
									end
							
								if(count==(temp+131) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+132;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z100_1110:
				begin
								if(count==(temp+132) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b100_1110; // Port 2 Module 17
											count <= temp+133;
									end
							
								if(count==(temp+133) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+134;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z110_1110:
				begin
								if(count==(temp+134) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b110_1110; // Port 3 Module 17
											count <= temp+135;
									end
							
								if(count==(temp+135) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+136;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z000_1101:
				begin
								if(count==(temp+136) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b000_1101; // Port 0 Module 18
											count <= temp+137;
									end
							
								if(count==(temp+137) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+138;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z010_1101:
				begin
								if(count==(temp+138) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b010_1101; // Port 1 Module 18
											count <= temp+139;
									end
							
								if(count==(temp+139) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+140;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z100_1101:
				begin
								if(count==(temp+140) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b100_1101; // Port 2 Module 18
											count <= temp+141;
									end
							
								if(count==(temp+141) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+142;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z110_1101:
				begin
								if(count==(temp+142) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b110_1101; // Port 3 Module 18
											count <= temp+143;
									end
							
								if(count==(temp+143) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+144;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z000_1100:
				begin
								if(count==(temp+144) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b000_1100; // Port 0 Module 19
											count <= temp+145;
									end
							
								if(count==(temp+145) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+146;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z010_1100:
				begin
								if(count==(temp+146) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b010_1100; // Port 1 Module 19
											count <= temp+147;
									end
							
								if(count==(temp+147) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+148;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z100_1100:
				begin
								if(count==(temp+148) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b100_1100; // Port 2 Module 19
											count <= temp+149;
									end
							
								if(count==(temp+149) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+150;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z110_1100:
				begin
								if(count==(temp+150) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b110_1100; // Port 3 Module 19
											count <= temp+151;
									end
							
								if(count==(temp+151) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+152;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
			10'bzz_z000_1011:
				begin
								if(count==(temp+152) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b000_1011; // Port 0 Module 20
											count <= temp+153;
									end
							
								if(count==(temp+153) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+154;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z010_1011:
				begin
								if(count==(temp+154) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b010_1011; // Port 1 Module 20
											count <= temp+155;
									end
							
								if(count==(temp+155) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+156;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z100_1011:
				begin
								if(count==(temp+156) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b100_1011; // Port 2 Module 20
											count <= temp+157;
									end
							
								if(count==(temp+157) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+158;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z110_1011:
				begin
								if(count==(temp+158) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b110_1011; // Port 3 Module 20
											count <= temp+159;
									end
							
								if(count==(temp+159) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+160;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z000_1010:
				begin
								if(count==(temp+160) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b000_1010; // Port 0 Module 21
											count <= temp+161;
									end
							
								if(count==(temp+161) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+162;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z010_1010:
				begin
								if(count==(temp+162) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b010_1010; // Port 1 Module 21
											count <= temp+163;
									end
							
								if(count==(temp+163) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+164;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z100_1010:
				begin
								if(count==(temp+164) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b100_1010; // Port 2 Module 21
											count <= temp+165;
									end
							
								if(count==(temp+165) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+166;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z110_1010:
				begin
								if(count==(temp+166) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b110_1010; // Port 3 Module 21
											count <= temp+167;
									end
							
								if(count==(temp+167) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+168;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z000_1001:
				begin
								if(count==(temp+168) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b000_1001; // Port 0 Module 22
											count <= temp+169;
									end
							
								if(count==(temp+169) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+170;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z010_1001:
				begin
								if(count==(temp+170) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b010_1001; // Port 1 Module 22
											count <= temp+171;
									end
							
								if(count==(temp+171) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+172;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z100_1001:
				begin
								if(count==(temp+172) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b100_1001; // Port 2 Module 22
											count <= temp+173;
									end
							
								if(count==(temp+173) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+174;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
			10'bzz_z110_1001:
				begin
								if(count==(temp+174) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= 7'b110_1001; // Port 3 Module 22
											count <= temp+175;
									end
							
								if(count==(temp+175) && !user_buffer_full_0)
									begin
											user_buffer_input_0 <= data; // data value
											count <= temp+176;
									end
													
								if(count==(temp+176) && !user_buffer_full_0)
									begin
											user_write_buffer_0 <= 1'b0; //end transfer / reset user write buffer
											count <= temp+177;

									end
				end
	endcase // end address case
end // end if count==0	
		
/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// Data write //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

if(count == (temp+177))
	begin
		enable <= 0; // switch to write
		we <= we_q;
		control_go_1 <= 1'b0; 
		count <= temp+178;
		
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
		casez(addressw) // treats z as don't care
			10'bzz_z001_1110:
				begin
								if(count==(temp+178) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 1
											user_read_buffer_1 <= 1'b1; // read qualifier
											control_go_1 <= 1'b1; // start read pulse
											count <= temp+179;
									end
							
								if(count==(temp+179) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											control_go_1 <= 1'b0; // end 1 clock cycle pulse
											count <= temp+180;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_1110:
				begin
								if(count==(temp+180) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 1
											count <= temp+181;
									end
							
								if(count==(temp+181) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+182;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_1110:
				begin
								if(count==(temp+182) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 1
											count <= temp+183;
									end
							
								if(count==(temp+183) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+184;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_1110:
				begin
								if(count==(temp+184) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 1
											count <= temp+185;
									end
							
								if(count==(temp+185) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+186;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_1101:
				begin
								if(count==(temp+186) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 2
											count <= temp+187;
									end
							
								if(count==(temp+187) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+188;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_1101:
				begin
								if(count==(temp+188) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 2
											count <= temp+189;
									end
							
								if(count==(temp+189) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+190;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_1101:
				begin
								if(count==(temp+190) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 2
											count <= temp+191;
									end
							
								if(count==(temp+191) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+192;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_1101:
				begin
								if(count==(temp+192) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 2
											count <= temp+193;
									end
							
								if(count==(temp+193) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+194;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_1100:
				begin
								if(count==(temp+194) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 3
											count <= temp+195;
									end
							
								if(count==(temp+195) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+196;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_1100:
				begin
								if(count==(temp+196) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 3
											count <= temp+197;
									end
							
								if(count==(temp+197) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+198;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_1100:
				begin
								if(count==(temp+198) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 3
											count <= temp+199;
									end
							
								if(count==(temp+199) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+200;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_1100:
				begin
								if(count==(temp+200) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 3
											count <= temp+201;
									end
							
								if(count==(temp+201) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+202;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_1011:
				begin
								if(count==(temp+202) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 4
											count <= temp+203;
									end
							
								if(count==(temp+203) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+204;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_1011:
				begin
								if(count==(temp+204) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 4
											count <= temp+205;
									end
							
								if(count==(temp+205) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+206;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_1011:
				begin
								if(count==(temp+206) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 4
											count <= temp+207;
									end
							
								if(count==(temp+207) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+208;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_1011:
				begin
								if(count==(temp+208) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 4
											count <= temp+209;
									end
							
								if(count==(temp+209) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+210;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_1010:
				begin
								if(count==(temp+210) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 5
											count <= temp+211;
									end
							
								if(count==(temp+211) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+212;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_1010:
				begin
								if(count==(temp+212) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 5
											count <= temp+213;
									end
							
								if(count==(temp+213) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+214;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_1010:
				begin
								if(count==(temp+214) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 5
											count <= temp+215;
									end
							
								if(count==(temp+215) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+216;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_1010:
				begin
								if(count==(temp+216) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 5
											count <= temp+217;
									end
							
								if(count==(temp+217) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+218;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_1001:
				begin
								if(count==(temp+218) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 6
											count <= temp+219;
									end
							
								if(count==(temp+219) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+220;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_1001:
				begin
								if(count==(temp+220) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 6
											count <= temp+221;
									end
							
								if(count==(temp+221) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+222;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_1001:
				begin
								if(count==(temp+222) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 6
											count <= temp+223;
									end
							
								if(count==(temp+223) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+224;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_1001:
				begin
								if(count==(temp+224) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 6
											count <= temp+225;
									end
							
								if(count==(temp+225) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+226;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_1000:
				begin
								if(count==(temp+226) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 7
											count <= temp+227;
									end
							
								if(count==(temp+227) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+228;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_1000:
				begin
								if(count==(temp+228) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 7
											count <= temp+229;
									end
							
								if(count==(temp+229) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+230;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_1000:
				begin
								if(count==(temp+230) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 7
											count <= temp+231;
									end
							
								if(count==(temp+231) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+232;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_1000:
				begin
								if(count==(temp+232) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 7
											count <= temp+233;
									end
							
								if(count==(temp+233) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+234;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_0111:
				begin
								if(count==(temp+234) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 8
											count <= temp+235;
									end
							
								if(count==(temp+235) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+236;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_0111:
				begin
								if(count==(temp+236) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 8
											count <= temp+237;
									end
							
								if(count==(temp+237) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+238;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_0111:
				begin
								if(count==(temp+238) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 8
											count <= temp+239;
									end
							
								if(count==(temp+239) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+240;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_0111:
				begin
								if(count==(temp+240) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 8
											count <= temp+241;
									end
							
								if(count==(temp+241) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+242;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_0110:
				begin
								if(count==(temp+242) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 9
											count <= temp+243;
									end
							
								if(count==(temp+243) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+244;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_0110:
				begin
								if(count==(temp+244) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 9
											count <= temp+245;
									end
							
								if(count==(temp+245) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+246;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_0110:
				begin
								if(count==(temp+246) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 9
											count <= temp+247;
									end
							
								if(count==(temp+247) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+248;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_0110:
				begin
								if(count==(temp+248) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 9
											count <= temp+249;
									end
							
								if(count==(temp+249) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+250;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_0101:
				begin
								if(count==(temp+250) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 10
											count <= temp+251;
									end
							
								if(count==(temp+251) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+252;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_0101:
				begin
								if(count==(temp+252) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 10
											count <= temp+253;
									end
							
								if(count==(temp+253) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+254;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_0101:
				begin
								if(count==(temp+254) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 10
											count <= temp+255;
									end
							
								if(count==(temp+255) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+256;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_0101:
				begin
								if(count==(temp+256) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 10
											count <= temp+256;
									end
							
								if(count==(temp+257) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+258;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_0100:
				begin
								if(count==(temp+258) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 11
											count <= temp+259;
									end
							
								if(count==(temp+259) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+260;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_0100:
				begin
								if(count==(temp+260) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 11
											count <= temp+261;
									end
							
								if(count==(temp+261) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+262;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_0100:
				begin
								if(count==(temp+262) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 11
											count <= temp+263;
									end
							
								if(count==(temp+263) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+264;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_0100:
				begin
								if(count==(temp+264) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 11
											count <= temp+265;
									end
							
								if(count==(temp+265) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+266;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_0011:
				begin
								if(count==(temp+266) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 12
											count <= temp+267;
									end
							
								if(count==(temp+267) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+268;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_0011:
				begin
								if(count==(temp+268) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 12
											count <= temp+269;
									end
							
								if(count==(temp+269) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+270;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_0011:
				begin
								if(count==(temp+270) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 12
											count <= temp+271;
									end
							
								if(count==(temp+271) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+272;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_0011:
				begin
								if(count==(temp+272) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 12
											count <= temp+273;
									end
							
								if(count==(temp+273) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+274;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_0010:
				begin
								if(count==(temp+274) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 13
											count <= temp+275;
									end
							
								if(count==(temp+275) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+276;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_0010:
				begin
								if(count==(temp+276) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 13
											count <= temp+277;
									end
							
								if(count==(temp+277) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+278;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_0010:
				begin
								if(count==(temp+278) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 13
											count <= temp+279;
									end
							
								if(count==(temp+279) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+280;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_0010:
				begin
								if(count==(temp+280) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 13
											count <= temp+281;
									end
							
								if(count==(temp+281) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+282;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_0001:
				begin
								if(count==(temp+282) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 14
											count <= temp+283;
									end
							
								if(count==(temp+283) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+284;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_0001:
				begin
								if(count==(temp+284) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 14
											count <= temp+285;
									end
							
								if(count==(temp+285) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+286;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_0001:
				begin
								if(count==(temp+286) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 14
											count <= temp+287;
									end
							
								if(count==(temp+287) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+288;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_0001:
				begin
								if(count==(temp+288) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 14
											count <= temp+289;
									end
							
								if(count==(temp+289) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+290;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z001_0000:
				begin
								if(count==(temp+290) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 15
											count <= temp+291;
									end
							
								if(count==(temp+291) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+292;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z011_0000:
				begin
								if(count==(temp+292) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 15
											count <= temp+293;
									end
							
								if(count==(temp+293) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+294;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z101_0000:
				begin
								if(count==(temp+294) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 15
											count <= temp+295;
									end
							
								if(count==(temp+295) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+296;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z111_0000:
				begin
								if(count==(temp+296) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 15
											count <= temp+297;
									end
							
								if(count==(temp+297) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+298;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z000_1111:
				begin
								if(count==(temp+298) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 16
											count <= temp+299;
									end
							
								if(count==(temp+299) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+300;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z010_1111:
				begin
								if(count==(temp+300) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 16
											count <= temp+301;
									end
							
								if(count==(temp+301) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+302;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z100_1111:
				begin
								if(count==(temp+302) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 16
											count <= temp+303;
									end
							
								if(count==(temp+303) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+304;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z110_1111:
				begin
								if(count==(temp+304) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 16
											count <= temp+305;
									end
							
								if(count==(temp+305) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+306;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z000_1110:
				begin
								if(count==(temp+306) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 17
											count <= temp+307;
									end
							
								if(count==(temp+307) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+308;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z010_1110:
				begin
								if(count==(temp+308) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 17
											count <= temp+309;
									end
							
								if(count==(temp+309) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+310;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z100_1110:
				begin
								if(count==(temp+310) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 17
											count <= temp+311;
									end
							
								if(count==(temp+311) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+312;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z110_1110:
				begin
								if(count==(temp+312) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 17
											count <= temp+313;
									end
							
								if(count==(temp+313) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+314;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z000_1101:
				begin
								if(count==(temp+314) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 18
											count <= temp+315;
									end
							
								if(count==(temp+315) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+316;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z010_1101:
				begin
								if(count==(temp+316) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 18
											count <= temp+317;
									end
							
								if(count==(temp+317) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+318;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z100_1101:
				begin
								if(count==(temp+318) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 18
											count <= temp+319;
									end
							
								if(count==(temp+319) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+320;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z110_1101:
				begin
								if(count==(temp+320) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 18
											count <= temp+321;
									end
							
								if(count==(temp+321) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+322;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z000_1100:
				begin
								if(count==(temp+322) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 19
											count <= temp+323;
									end
							
								if(count==(temp+323) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+324;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z010_1100:
				begin
								if(count==(temp+324) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 19
											count <= temp+325;
									end
							
								if(count==(temp+325) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+326;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z100_1100:
				begin
								if(count==(temp+326) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 19
											count <= temp+327;
									end
							
								if(count==(temp+327) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+328;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z110_1100:
				begin
								if(count==(temp+328) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 19
											count <= temp+329;
									end
							
								if(count==(temp+329) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+330;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z000_1011:
				begin
								if(count==(temp+330) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 20
											count <= temp+331;
									end
							
								if(count==(temp+331) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+332;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z010_1011:
				begin
								if(count==(temp+332) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 20
											count <= temp+333;
									end
							
								if(count==(temp+333) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+334;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z100_1011:
				begin
								if(count==(temp+334) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 20
											count <= temp+335;
									end
							
								if(count==(temp+335) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+336;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z110_1011:
				begin
								if(count==(temp+336) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 20
											count <= temp+337;
									end
							
								if(count==(temp+337) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+338;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z000_1010:
				begin
								if(count==(temp+338) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 21
											count <= temp+339;
									end
							
								if(count==(temp+339) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+340;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z010_1010:
				begin
								if(count==(temp+340) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 21
											count <= temp+341;
									end
							
								if(count==(temp+341) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+342;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z100_1010:
				begin
								if(count==(temp+342) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 21
											count <= temp+343;
									end
							
								if(count==(temp+343) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+344;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z110_1010:
				begin
								if(count==(temp+344) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 21
											count <= temp+345;
									end
							
								if(count==(temp+345) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+346;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z000_1001:
				begin
								if(count==(temp+346) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 0 Module 22
											count <= temp+347;
									end
							
								if(count==(temp+347) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+348;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z010_1001:
				begin
								if(count==(temp+348) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 1 Module 22
											count <= temp+349;
									end
							
								if(count==(temp+349) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+350;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z100_1001:
				begin
								if(count==(temp+350) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 2 Module 22
											count <= temp+351;
									end
							
								if(count==(temp+351) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+352;
									end
				end
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			10'bzz_z110_1001:
				begin
								if(count==(temp+352) && user_data_available_1) // start transfer condition
									begin
										// 22 zeros + 10 address bits
											{zeros22,addressw} <= user_buffer_data_1; // Port 3 Module 22
											count <= temp+353;
									end
							
								if(count==(temp+353) && user_data_available_1)
									begin
										// 24 zeros + 8 data bits
											{zeros24,dataw} <= user_buffer_data_1; // data write
											count <= temp+354;
									end
									
								if(count == (temp+354) && user_data_available_1)
									begin
											user_read_buffer_1<=1'b0; // end transfer / reset user read buffer 
											count <= 0; // reset count
									end
				end
		endcase // endcase addressw
	end // end count=temp+177
	
end // end always at posedge

endmodule


