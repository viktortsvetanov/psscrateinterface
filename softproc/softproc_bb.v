
module softproc (
	clk_clk,
	master_template_0_control_fixed_location,
	master_template_0_control_write_base,
	master_template_0_control_write_length,
	master_template_0_control_go,
	master_template_0_control_done,
	master_template_0_user_write_buffer,
	master_template_0_user_buffer_input_data,
	master_template_0_user_buffer_full,
	master_template_1_control_fixed_location,
	master_template_1_control_read_base,
	master_template_1_control_read_length,
	master_template_1_control_go,
	master_template_1_control_done,
	master_template_1_control_early_done,
	master_template_1_user_read_buffer,
	master_template_1_user_buffer_output_data,
	master_template_1_user_data_available,
	sdram_clock_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n);	

	input		clk_clk;
	input		master_template_0_control_fixed_location;
	input	[31:0]	master_template_0_control_write_base;
	input	[31:0]	master_template_0_control_write_length;
	input		master_template_0_control_go;
	output		master_template_0_control_done;
	input		master_template_0_user_write_buffer;
	input	[31:0]	master_template_0_user_buffer_input_data;
	output		master_template_0_user_buffer_full;
	input		master_template_1_control_fixed_location;
	input	[31:0]	master_template_1_control_read_base;
	input	[31:0]	master_template_1_control_read_length;
	input		master_template_1_control_go;
	output		master_template_1_control_done;
	output		master_template_1_control_early_done;
	input		master_template_1_user_read_buffer;
	output	[31:0]	master_template_1_user_buffer_output_data;
	output		master_template_1_user_data_available;
	output		sdram_clock_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[31:0]	sdram_wire_dq;
	output	[3:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
endmodule
