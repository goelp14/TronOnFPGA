
module lab8_soc (
	accum_btn_export,
	clk_clk,
	keycode_external_connection_export,
	otg_hpi_address_external_connection_export,
	otg_hpi_cs_external_connection_export,
	otg_hpi_data_external_connection_in_port,
	otg_hpi_data_external_connection_out_port,
	otg_hpi_r_external_connection_export,
	otg_hpi_reset_external_connection_export,
	otg_hpi_w_external_connection_export,
	reset_reset_n,
	reset_btn_export,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n);	

	input		accum_btn_export;
	input		clk_clk;
	output	[7:0]	keycode_external_connection_export;
	output	[1:0]	otg_hpi_address_external_connection_export;
	output		otg_hpi_cs_external_connection_export;
	input	[15:0]	otg_hpi_data_external_connection_in_port;
	output	[15:0]	otg_hpi_data_external_connection_out_port;
	output		otg_hpi_r_external_connection_export;
	output		otg_hpi_reset_external_connection_export;
	output		otg_hpi_w_external_connection_export;
	input		reset_reset_n;
	input		reset_btn_export;
	output		sdram_clk_clk;
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
