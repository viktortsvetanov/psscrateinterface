	softproc u0 (
		.clk_clk                                   (<connected-to-clk_clk>),                                   //                       clk.clk
		.master_template_0_control_fixed_location  (<connected-to-master_template_0_control_fixed_location>),  // master_template_0_control.fixed_location
		.master_template_0_control_write_base      (<connected-to-master_template_0_control_write_base>),      //                          .write_base
		.master_template_0_control_write_length    (<connected-to-master_template_0_control_write_length>),    //                          .write_length
		.master_template_0_control_go              (<connected-to-master_template_0_control_go>),              //                          .go
		.master_template_0_control_done            (<connected-to-master_template_0_control_done>),            //                          .done
		.master_template_0_user_write_buffer       (<connected-to-master_template_0_user_write_buffer>),       //    master_template_0_user.write_buffer
		.master_template_0_user_buffer_input_data  (<connected-to-master_template_0_user_buffer_input_data>),  //                          .buffer_input_data
		.master_template_0_user_buffer_full        (<connected-to-master_template_0_user_buffer_full>),        //                          .buffer_full
		.master_template_1_control_fixed_location  (<connected-to-master_template_1_control_fixed_location>),  // master_template_1_control.fixed_location
		.master_template_1_control_read_base       (<connected-to-master_template_1_control_read_base>),       //                          .read_base
		.master_template_1_control_read_length     (<connected-to-master_template_1_control_read_length>),     //                          .read_length
		.master_template_1_control_go              (<connected-to-master_template_1_control_go>),              //                          .go
		.master_template_1_control_done            (<connected-to-master_template_1_control_done>),            //                          .done
		.master_template_1_control_early_done      (<connected-to-master_template_1_control_early_done>),      //                          .early_done
		.master_template_1_user_read_buffer        (<connected-to-master_template_1_user_read_buffer>),        //    master_template_1_user.read_buffer
		.master_template_1_user_buffer_output_data (<connected-to-master_template_1_user_buffer_output_data>), //                          .buffer_output_data
		.master_template_1_user_data_available     (<connected-to-master_template_1_user_data_available>),     //                          .data_available
		.sdram_clock_clk                           (<connected-to-sdram_clock_clk>),                           //               sdram_clock.clk
		.sdram_wire_addr                           (<connected-to-sdram_wire_addr>),                           //                sdram_wire.addr
		.sdram_wire_ba                             (<connected-to-sdram_wire_ba>),                             //                          .ba
		.sdram_wire_cas_n                          (<connected-to-sdram_wire_cas_n>),                          //                          .cas_n
		.sdram_wire_cke                            (<connected-to-sdram_wire_cke>),                            //                          .cke
		.sdram_wire_cs_n                           (<connected-to-sdram_wire_cs_n>),                           //                          .cs_n
		.sdram_wire_dq                             (<connected-to-sdram_wire_dq>),                             //                          .dq
		.sdram_wire_dqm                            (<connected-to-sdram_wire_dqm>),                            //                          .dqm
		.sdram_wire_ras_n                          (<connected-to-sdram_wire_ras_n>),                          //                          .ras_n
		.sdram_wire_we_n                           (<connected-to-sdram_wire_we_n>)                            //                          .we_n
	);

