
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
	pio_0_external_connection_export,
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
	input	[7:0]	master_template_0_user_buffer_input_data;
	output		master_template_0_user_buffer_full;
	input		pio_0_external_connection_export;
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
