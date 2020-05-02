//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				 output logic SRAM_CE_N, SRAM_UB_N, SRAM_LB_N, SRAM_OE_N, SRAM_WE_N,  // Sram stuff
				 output [19:0] SRAM_ADDR,
				 input [15:0] SRAM_DQ
                    );
    
    logic Reset_h, Clk, is_ball;
    logic [7:0] keycode;
	 logic [9:0] DrawX, DrawY;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 // VARS TO STORE GAME STUFF
	 logic [7:0] red_color, blue_color;
	 logic [2:0] Game_State;
	 logic [1:0] score_blue, score_red, background_sel;
	 
	 logic reset_round, reset_game, Blue_W, Red_W;
	 // actual 640x480 coords
	 logic [9:0] Blue_X_real, Blue_Y_real, Red_X_real, Red_Y_real;
	 // scaled x4 coords 
	 logic [7:0] Blue_X, Blue_Y, Red_X, Red_Y;
	 
	 logic [1:0] Blue_dir, Red_dir;
    
	 logic [2:0] write_r, write_b;
	 
	 logic [19:0] addr_to_cont;
	 
	 logic sram_read, sram_done;
	 
	 logic [15:0] SRAM_OUTPUT_DATA, OCM_Data;
	 
	 logic fb_we;
	 
	 logic [18:0] fb_addr_OCM;
	 
	 logic [3:0] color_enum, Drawengine_out;
	 
	 logic load_background;
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
    // You need to make sure that the port names here match the ports in Qsys-generated codes.
     finalproject_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_external_connection_export(keycode),  
                             .otg_hpi_address_external_connection_export(hpi_addr),
                             .otg_hpi_data_external_connection_in_port(hpi_data_in),
                             .otg_hpi_data_external_connection_out_port(hpi_data_out),
                             .otg_hpi_cs_external_connection_export(hpi_cs),
                             .otg_hpi_r_external_connection_export(hpi_r),
                             .otg_hpi_w_external_connection_export(hpi_w),
                             .otg_hpi_reset_external_connection_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(
		 .Clk(Clk),         // 50 MHz clock
		 .Reset(Reset_h),       // Active-high reset signal
		 .VGA_HS(VGA_HS),      // Horizontal sync pulse.  Active low
		 .VGA_VS(VGA_VS),      // Vertical sync pulse.  Active low
		 .VGA_CLK(VGA_CLK),     // 25 MHz VGA clock input
		 .VGA_BLANK_N(VGA_BLANK_N), // Blanking interval indicator.  Active low.
		 .VGA_SYNC_N(VGA_SYNC_N),  // Composite Sync signal.  Active low.  We don't use it in this lab,
		 .DrawX(DrawX),       // horizontal coordinate
		 .DrawY(DrawY)        // vertical coordinate
	 );
    
    // Which signal should be frame_clk?
//    ball ball_instance(
//		 .Clk(Clk),         // 50 MHz clock
//		 .Reset(Reset_h),       // Active-high reset signal
//		 .frame_clk(VGA_VS),   // The clock indicating a new frame (~60Hz)
//		 .DrawX(DrawX), 
//		 .DrawY(DrawY),       // Current pixel coordinates
//		 .is_ball(is_ball),      // Whether current pixel belongs to ball or background
//		 .keycode(keycode)	// Key inputs
//	 );
    
	 drawengine draw(.Clk(Clk),.Reset(Reset_h),.frame_clk(VGA_VS), .DrawX(DrawX),.DrawY(DrawY),
					.Blue_dir(Blue_dir), .Red_dir(Red_dir), .Blue_X_real(Blue_X_real), .Blue_Y_real(Blue_Y_real),
					.Red_X_real(Red_X_real), .Red_Y_real(Red_Y_real), .gamestate(Game_State), .color_enum(Drawengine_out));
	 
	 combine combiner(.Clk(Clk),.Reset(Reset_h),.frame_clk(VGA_VS), .WE(fb_we),.DrawX(DrawX),.DrawY(DrawY),
					.Data_In_Bike(Drawengine_out), .Data_In(OCM_Data), .write_address(fb_addr_OCM),
					.color_enum(color_enum));
	 
    color_mapper color_instance(
		.VGA_R(VGA_R), 
		.VGA_G(VGA_G), 
		.VGA_B(VGA_B),		// VGA RGB output
		.color_pallete_enum(color_enum)
	 );
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
    
	 // STUFF FOR GAMELOGIC
	 GameState statemachine(.Clk(CLOCK_50), .Reset(Reset_h), .Reset_Game(reset_game),
									.Reset_Round(reset_round), .Blue_W(Blue_W), .Red_W(Red_W), 
									.keycode(keycode), .Game_State(Game_State), .background_select(background_sel), .load_background(load_background));
									
	 score scorekeeper(.Clk(CLOCK_50), .Reset_Score(reset_game), .frame_clk(VGA_VS), .Game_State(Game_State),
							 .red_color(red_color), .blue_color(blue_color), 
							 .Blue_W(Blue_W), .Red_W(Red_W), .reset_round(reset_round), .score_blue(score_blue), .score_red(score_red));
							
	 arena field(.Clk(CLOCK_50), .Reset(Reset_h), .frame_clk(VGA_VS), .Game_State(Game_State), .keycode(keycode), 
					 .Blue_X_real(Blue_X_real), .Blue_Y_real(Blue_Y_real), .Red_X_real(Red_X_real), .Red_Y_real(Red_Y_real),
					 .Blue_X(Blue_X), .Blue_Y(Blue_Y), .Red_X(Red_X), .Red_Y(Red_Y), .Blue_dir(Blue_dir), .Red_dir(Red_dir));
	
	 trails trail_decider(.Clk(CLOCK_50), .Reset(Reset_h), .frame_clk(VGA_VS), .write_r(write_r), .write_b(write_b),
								 .Blue_X(Blue_X), .Blue_Y(Blue_Y), .Red_X(Red_X), .Red_Y(Red_Y), 
								 .Blue_dir(Blue_dir), .Red_dir(Red_dir), .Game_State(Game_State));
								 
	 sram_controller sramdriver(.Clk(CLOCK_50), .Reset(Reset_h), .Read(sram_read), .addr_in(addr_to_cont), .CE(SRAM_CE_N), .UB(SRAM_UB_N),
										 .LB(SRAM_LB_N), .OE(SRAM_OE_N), .WE(SRAM_WE_N), .done_r(sram_done), .OUTPUT_DATA(SRAM_OUTPUT_DATA), .ADDR(SRAM_ADDR),
										 .Data(SRAM_DQ));
	
	 load_background ldback(.Clk(CLOCK_50), .Reset(Reset_h), .load(load_background), .SRAM_done(sram_done),
	                        .BG_Sel(background_sel), .Game_State(Game_State), .DATA_IN(SRAM_OUTPUT_DATA),
									.writing(fb_we), .reading(sram_read), .ADDR(addr_to_cont),
									.addr_OCM(fb_addr_OCM), .DATA_OUT(OCM_Data));
									
									//.DATA_IN(SRAM_OUTPUT_DATA)
									
//	 FB_tester test(.Data_Out(OCM_Data), .write_address(fb_addr_OCM), .we(fb_we), .DrawX(DrawX), .DrawY(DrawY));
	 
endmodule
