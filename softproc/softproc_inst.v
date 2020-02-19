	softproc u0 (
		.clk_clk                                  (<connected-to-clk_clk>),                                  //                       clk.clk
		.master_template_0_control_fixed_location (<connected-to-master_template_0_control_fixed_location>), // master_template_0_control.fixed_location
		.master_template_0_control_write_base     (<connected-to-master_template_0_control_write_base>),     //                          .write_base
		.master_template_0_control_write_length   (<connected-to-master_template_0_control_write_length>),   //                          .write_length
		.master_template_0_control_go             (<connected-to-master_template_0_control_go>),             //                          .go
		.master_template_0_control_done           (<connected-to-master_template_0_control_done>),           //                          .done
		.master_template_0_user_write_buffer      (<connected-to-master_template_0_user_write_buffer>),      //    master_template_0_user.write_buffer
		.master_template_0_user_buffer_input_data (<connected-to-master_template_0_user_buffer_input_data>), //                          .buffer_input_data
		.master_template_0_user_buffer_full       (<connected-to-master_template_0_user_buffer_full>),       //                          .buffer_full
		.pio_0_external_connection_export         (<connected-to-pio_0_external_connection_export>),         // pio_0_external_connection.export
		.sdram_clock_clk                          (<connected-to-sdram_clock_clk>),                          //               sdram_clock.clk
		.sdram_wire_addr                          (<connected-to-sdram_wire_addr>),                          //                sdram_wire.addr
		.sdram_wire_ba                            (<connected-to-sdram_wire_ba>),                            //                          .ba
		.sdram_wire_cas_n                         (<connected-to-sdram_wire_cas_n>),                         //                          .cas_n
		.sdram_wire_cke                           (<connected-to-sdram_wire_cke>),                           //                          .cke
		.sdram_wire_cs_n                          (<connected-to-sdram_wire_cs_n>),                          //                          .cs_n
		.sdram_wire_dq                            (<connected-to-sdram_wire_dq>),                            //                          .dq
		.sdram_wire_dqm                           (<connected-to-sdram_wire_dqm>),                           //                          .dqm
		.sdram_wire_ras_n                         (<connected-to-sdram_wire_ras_n>),                         //                          .ras_n
		.sdram_wire_we_n                          (<connected-to-sdram_wire_we_n>)                           //                          .we_n
	);

