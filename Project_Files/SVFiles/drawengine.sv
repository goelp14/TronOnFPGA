module drawengine(
	input logic Clk, Reset, Run, Continue,
	input LD, Sprite_addr_sel,
	input logic [2:0] Game_State,
	output logic CE, UB, LB, OE, WE,
	output logic [19:0] ADDR,
	output logic [1023:0] BIKE,
	output logic [639:0] BG [480]
	// inout wire [307199:0] Data //tristate buffers need to be of type wire
);

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// Declaration of SRAM DATA related wires
logic [639:0] REG_SRAM_DATA [480];
logic [307199:0] REG_SRAM_DATA_IN;
logic [307199:0] SRAM_TO_DATA;

assign BG = REG_SRAM_DATA;
// logic frame_sel;
logic menu_addr, bg_addr, sprites_addr;
// bike_blue_down_addr, bike_blue_up_addr, bike_blue_right_addr, bike_blue_left_addr, bike_red_down_addr, bike_red_up_addr, bike_red_right_addr, bike_red_left_addr;


// Register to Process Data and Use for OCM
always_ff @ (posedge Clk) begin
	if (Reset_ah)
		for (int i = 0; i < 480; i++)
			begin
				REG_SRAM_DATA[i] <= 3'h280;
			end
	else if (LD) begin
		for (int i = 0; i < 480; i++)
			begin
				REG_SRAM_DATA[i] <= Data_to_SRAM [(640 * (i + 1)) : (640 * i)];
			end
	else
		REG_SRAM_DATA <= REG_SRAM_DATA;
	end
end

// SRAM Pull Logic (frame select should tell where from the SRAM its pulling and ADDR should be making sure that its pulling from the right address.
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR),
    .Data_from_REG(REG_SRAM_DATA), .Data_to_REG(SRAM_TO_DATA),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// // The tri-state buffer serves as the interface between Mem2IO and SRAM
// tristate #(.N(16)) tr0(
//     .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
// );

// frame sel should be determined by the Game State
// assign frame_sel = Game_State;

always_comb 
	begin
		if (Game_State == 3'b000)
			ADDR = menu_addr;
		else if (Game_State == 3'b001)
			ADDR = bg_addr;
		else if (Sprite_addr_sel)
			ADDR = sprites_addr;
		else
			ADDR = 20'b00000000000000000000
	end

// always_comb
// 	begin
// 		if (Sprite_addr_sel == 3'b000)
// 			ADDR = bike_blue_down_addr;
// 		else if (Sprite_addr_sel == 3'b001)
// 			ADDR = bike_blue_up_addr;
// 		else if (Sprite_addr_sel == 3'b010)
// 			ADDR = bike_blue_right_addr;
// 		else if (Sprite_addr_sel == 3'b011)
// 			ADDR = bike_blue_left_addr;
// 		else if (Sprite_addr_sel == 3'b100)
// 			ADDR = bike_red_down_addr;
// 		else if (Sprite_addr_sel == 3'b101)
// 			ADDR = bike_red_up_addr;
// 		else if (Sprite_addr_sel == 3'b110)
// 			ADDR = bike_red_left_addr;
// 		else if (Sprite_addr_sel == 3'b111)
// 			ADDR = bike_red_right_addr;
// 	end

// REG_SRAM_DATA should hold the information we want which is put into the DATA inout wire.
assign Data = REG_SRAM_DATA;

//The next lines should be putting whats in the REG_SRAM_DATA to the OCM when asked for.

// This is for bikes
always_comb
	begin
		if (Sprite_addr_sel == 3'b000)
			BIKE = Data_to_SRAM [1023:0];
		else if (Sprite_addr_sel == 3'b001)
			BIKE = Data_to_SRAM [1023*2:1024];
		else if (Sprite_addr_sel == 3'b010)
			BIKE = Data_to_SRAM [1023*3:1024*2];
		else if (Sprite_addr_sel == 3'b011)
			BIKE = Data_to_SRAM [1023*4:1024*3];
		else if (Sprite_addr_sel == 3'b100)
			BIKE = Data_to_SRAM [1023*5:1024*4];
		else if (Sprite_addr_sel == 3'b101)
			BIKE = Data_to_SRAM [1023*6:1024*5];
		else if (Sprite_addr_sel == 3'b110)
			BIKE = Data_to_SRAM [1023*7:1024*6];
		else if (Sprite_addr_sel == 3'b111)
			BIKE = Data_to_SRAM [1023*8:1024*7];
	end
endmodule