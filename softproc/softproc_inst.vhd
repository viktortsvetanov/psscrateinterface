	component softproc is
		port (
			clk_clk                                   : in    std_logic                     := 'X';             -- clk
			master_template_0_control_fixed_location  : in    std_logic                     := 'X';             -- fixed_location
			master_template_0_control_write_base      : in    std_logic_vector(31 downto 0) := (others => 'X'); -- write_base
			master_template_0_control_write_length    : in    std_logic_vector(31 downto 0) := (others => 'X'); -- write_length
			master_template_0_control_go              : in    std_logic                     := 'X';             -- go
			master_template_0_control_done            : out   std_logic;                                        -- done
			master_template_0_user_write_buffer       : in    std_logic                     := 'X';             -- write_buffer
			master_template_0_user_buffer_input_data  : in    std_logic_vector(31 downto 0) := (others => 'X'); -- buffer_input_data
			master_template_0_user_buffer_full        : out   std_logic;                                        -- buffer_full
			master_template_1_control_fixed_location  : in    std_logic                     := 'X';             -- fixed_location
			master_template_1_control_read_base       : in    std_logic_vector(31 downto 0) := (others => 'X'); -- read_base
			master_template_1_control_read_length     : in    std_logic_vector(31 downto 0) := (others => 'X'); -- read_length
			master_template_1_control_go              : in    std_logic                     := 'X';             -- go
			master_template_1_control_done            : out   std_logic;                                        -- done
			master_template_1_control_early_done      : out   std_logic;                                        -- early_done
			master_template_1_user_read_buffer        : in    std_logic                     := 'X';             -- read_buffer
			master_template_1_user_buffer_output_data : out   std_logic_vector(31 downto 0);                    -- buffer_output_data
			master_template_1_user_data_available     : out   std_logic;                                        -- data_available
			sdram_clock_clk                           : out   std_logic;                                        -- clk
			sdram_wire_addr                           : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba                             : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n                          : out   std_logic;                                        -- cas_n
			sdram_wire_cke                            : out   std_logic;                                        -- cke
			sdram_wire_cs_n                           : out   std_logic;                                        -- cs_n
			sdram_wire_dq                             : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm                            : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_wire_ras_n                          : out   std_logic;                                        -- ras_n
			sdram_wire_we_n                           : out   std_logic                                         -- we_n
		);
	end component softproc;

	u0 : component softproc
		port map (
			clk_clk                                   => CONNECTED_TO_clk_clk,                                   --                       clk.clk
			master_template_0_control_fixed_location  => CONNECTED_TO_master_template_0_control_fixed_location,  -- master_template_0_control.fixed_location
			master_template_0_control_write_base      => CONNECTED_TO_master_template_0_control_write_base,      --                          .write_base
			master_template_0_control_write_length    => CONNECTED_TO_master_template_0_control_write_length,    --                          .write_length
			master_template_0_control_go              => CONNECTED_TO_master_template_0_control_go,              --                          .go
			master_template_0_control_done            => CONNECTED_TO_master_template_0_control_done,            --                          .done
			master_template_0_user_write_buffer       => CONNECTED_TO_master_template_0_user_write_buffer,       --    master_template_0_user.write_buffer
			master_template_0_user_buffer_input_data  => CONNECTED_TO_master_template_0_user_buffer_input_data,  --                          .buffer_input_data
			master_template_0_user_buffer_full        => CONNECTED_TO_master_template_0_user_buffer_full,        --                          .buffer_full
			master_template_1_control_fixed_location  => CONNECTED_TO_master_template_1_control_fixed_location,  -- master_template_1_control.fixed_location
			master_template_1_control_read_base       => CONNECTED_TO_master_template_1_control_read_base,       --                          .read_base
			master_template_1_control_read_length     => CONNECTED_TO_master_template_1_control_read_length,     --                          .read_length
			master_template_1_control_go              => CONNECTED_TO_master_template_1_control_go,              --                          .go
			master_template_1_control_done            => CONNECTED_TO_master_template_1_control_done,            --                          .done
			master_template_1_control_early_done      => CONNECTED_TO_master_template_1_control_early_done,      --                          .early_done
			master_template_1_user_read_buffer        => CONNECTED_TO_master_template_1_user_read_buffer,        --    master_template_1_user.read_buffer
			master_template_1_user_buffer_output_data => CONNECTED_TO_master_template_1_user_buffer_output_data, --                          .buffer_output_data
			master_template_1_user_data_available     => CONNECTED_TO_master_template_1_user_data_available,     --                          .data_available
			sdram_clock_clk                           => CONNECTED_TO_sdram_clock_clk,                           --               sdram_clock.clk
			sdram_wire_addr                           => CONNECTED_TO_sdram_wire_addr,                           --                sdram_wire.addr
			sdram_wire_ba                             => CONNECTED_TO_sdram_wire_ba,                             --                          .ba
			sdram_wire_cas_n                          => CONNECTED_TO_sdram_wire_cas_n,                          --                          .cas_n
			sdram_wire_cke                            => CONNECTED_TO_sdram_wire_cke,                            --                          .cke
			sdram_wire_cs_n                           => CONNECTED_TO_sdram_wire_cs_n,                           --                          .cs_n
			sdram_wire_dq                             => CONNECTED_TO_sdram_wire_dq,                             --                          .dq
			sdram_wire_dqm                            => CONNECTED_TO_sdram_wire_dqm,                            --                          .dqm
			sdram_wire_ras_n                          => CONNECTED_TO_sdram_wire_ras_n,                          --                          .ras_n
			sdram_wire_we_n                           => CONNECTED_TO_sdram_wire_we_n                            --                          .we_n
		);

