// notes: assuming address is per 16 bit word, active-low
// not sure if inout wire should be input if ROM (Data)

module sram_controller(
	input logic Clk, Reset, Read,
	input logic [19:0] addr_in,
	//input logic [15:0] Data_in, - unneeded cus ROM
	output logic CE, UB, LB, OE, WE, // active when 0
	output logic done_r, // active when 1, tells that reg is loaded w/ correct value
	output logic [15:0] OUTPUT_DATA, // to actually be used in other modules
	output logic [19:0] ADDR, // to the SRAM
	input wire [15:0] Data // connecting to sram NOT SURE IF INOUT
	// output logic [639:0] BG [480]
	// inout wire [307199:0] Data //tristate buffers need to be of type wire
);

// readdata for storing read data, newreaddata to update
logic [15:0] readData, newreadData;

// we only read, so chip stuff can be constant
assign CE = 1'b0;
assign UB = 1'b0;
assign LB = 1'b0;
assign WE = 1'b1;
// assign address
assign ADDR = addr_in;
// assign output data
// states
enum logic [2:0] {idle, setaddr, read, done, read1} state, nextState;

assign OUTPUT_DATA = readData;

always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		state <= idle;
		readData <= 16'b0;
	end
	
	else
	begin
		state <= nextState;
		readData <= newreadData;
	end
end

always_comb
begin
	// default values
	nextState = state;
	
	unique case (state)
		idle:
			if (Read)
				nextState = setaddr;
		setaddr: 
			nextState = read;
		read:
			nextState = read1;
		read1:
			nextState = done;
		done:
			nextState = idle;
		default : 
			nextState = idle;
	endcase
end

always_comb
begin
	// default values
	OE = 1'b1;
	done_r = 1'b0;
	
	unique case (state)
		idle:
			newreadData = 16'h3333;
			
		read:
			begin
				OE = 1'b0;
				newreadData = Data;
			end
		done:
			begin
				OE = 1'b0;
				done_r = 1'b1;
				newreadData = Data;
			end
		read1:
			begin
				OE = 1'b0;
				done_r = 1'b1;
				newreadData = Data;
			end
		default: 
			newreadData = 16'h5555;
	endcase
end

endmodule


//          *********************************OLD********************************
// Declaration of active high signals
//logic Reset_ah, Run_ah;
//
//assign Reset_ah = ~Reset;
//// assign Continue_ah = ~Continue;
//assign Run_ah = ~Run;
//
//// Since each line is 16 bits I am thinking its easier just to read a line at a time depending starting at an address (handled in drawengine)
//
//enum logic [2:0] {hold, read, write} state, nextState; // states
//
//logic [15:0] readData, nextReadData, writeData, nextWriteData; // actually hold the values for read and write so they can change depending on situation
//logic [19:0] addr, nextAddr; // save the current address so that its easy to look at the next address
//logic we_sig, we_sig_next, oe_sig, oe_sig_next, tristate, tristate_next; // this is so that we can actually give something to the outputs (the others are always going to be active it should be fine to directly keep them 0)
//
//assign CE = 1'b0, UB = 1'b0, LB = 1'b0, OE = oe_sig, WE = we_sig, ADDR = addr, DATA = read; // make sure outputs are connected
//
//// possibly tristate needs to be notted
//assign data = (tristate) ? 16'bZZZZZZZZZZZZZZZZ : writeData;
//
//// basic state machine setup for each logic
//always_ff @ (posedge Clk)
//	begin
//		if (Reset_ah)
//			begin
//				state <= hold;
//				readData <= 0;
//				writeData <= 0;
//				addr <= 0;
//				we_sig <= 1'b1;
//				oe_sig <= 1'b1;
//				tristate <= 1'b1;
//			end
//		else
//			begin
//				state <= nextState;
//				readData <= nextReadData;
//				writeData <= nextWriteData;
//				addr <= nextAddr;
//				we_sig <= we_sig_next;
//				oe_sig <= oe_sig_next;
//				tristate <= tristate_next;
//			end
//	end
//
//
//// State machine
//always_comb
//	begin
//		nextReadData = readData;
//		nextWriteData = writeData;
//		nextAddr = addr;
//		we_sig_next = 1'b1;
//		oe_sig_next = 1'b1;
//		tristate_next = 1'b1;
//	// state machine to control outputs
//	case (state)
//		hold: 
//			begin
//				if (Run_ah)
//					nextState = state;
//				else
//					begin
//						addr = addr_loc;
//						if (READ)
//							begin
//								nextState = read;
//								oe_sig = 1'b0; // since you are reading you want it to output result
//							end
//						else
//							begin
//								nextState = write;
//								we_sig = 1'b0; // since you are writing you want that signal to be sent out
//								tristate = 1'b0;
//							end
//					end
//			end
//		read:
//			begin
//				nextState = hold; // wait for next call
//				nextReadData = data; // pull data from sram
//				oe_sig_next = 1'b1; // make sure it doesn't continue to output
//			end
//		write:
//			begin
//				nextState = hold; // wait for next call
//				nextWriteData = Data_in; // set data to be written
//				we_sig_next = 1'b1; // make sure it doesn't continue to write
//				tristate = 1'b1;
//			end
//		default: nextState = hold;
//		endcase
//	end
//endmodule

//********************************OLD CONTENT*******************************************************
// // Declaration of SRAM DATA related wires
// logic [639:0] REG_SRAM_DATA [480];
// logic [307199:0] REG_SRAM_DATA_IN;
// logic [307199:0] SRAM_TO_DATA;

// assign BG = REG_SRAM_DATA;
// // logic frame_sel;
// logic menu_addr, bg_addr, sprites_addr;
// // bike_blue_down_addr, bike_blue_up_addr, bike_blue_right_addr, bike_blue_left_addr, bike_red_down_addr, bike_red_up_addr, bike_red_right_addr, bike_red_left_addr;

// //assign sram signals
// assign CE = 1'b0;
// assign UB = 1'b0;
// assign LB = 1'b0;
// assign OE = 1'b0;
// assign WE = 1'b0;

// // Register to Process Data and Use for OCM
// always_ff @ (posedge Clk) begin
// 	if (Reset_ah)
// 		for (int i = 0; i < 480; i++)
// 			begin
// 				REG_SRAM_DATA[i] <= 3'h280;
// 			end
// 	else if (LD) begin
// 		for (int i = 0; i < 480; i++)
// 			begin
// 				REG_SRAM_DATA[i] <= Data_to_SRAM [(640 * (i + 1)) : (640 * i)];
// 			end
// 	else
// 		REG_SRAM_DATA <= REG_SRAM_DATA;
// 	end
// end

// // SRAM Pull Logic (frame select should tell where from the SRAM its pulling and ADDR should be making sure that its pulling from the right address.
// Mem2IO memory_subsystem(
//     .*, .Reset(Reset_ah), .ADDR(ADDR),
//     .Data_from_REG(REG_SRAM_DATA), .Data_to_REG(SRAM_TO_DATA),
//     .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
// );

// // // The tri-state buffer serves as the interface between Mem2IO and SRAM
// // tristate #(.N(16)) tr0(
// //     .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
// // );

// // frame sel should be determined by the Game State
// // assign frame_sel = Game_State;

// always_comb 
// 	begin
// 		if (Game_State == 3'b000)
// 			ADDR = menu_addr;
// 		else if (Game_State == 3'b001)
// 			ADDR = bg_addr;
// 		else if (Sprite_addr_sel)
// 			ADDR = sprites_addr;
// 		else
// 			ADDR = 20'b00000000000000000000
// 	end

// // always_comb
// // 	begin
// // 		if (Sprite_addr_sel == 3'b000)
// // 			ADDR = bike_blue_down_addr;
// // 		else if (Sprite_addr_sel == 3'b001)
// // 			ADDR = bike_blue_up_addr;
// // 		else if (Sprite_addr_sel == 3'b010)
// // 			ADDR = bike_blue_right_addr;
// // 		else if (Sprite_addr_sel == 3'b011)
// // 			ADDR = bike_blue_left_addr;
// // 		else if (Sprite_addr_sel == 3'b100)
// // 			ADDR = bike_red_down_addr;
// // 		else if (Sprite_addr_sel == 3'b101)
// // 			ADDR = bike_red_up_addr;
// // 		else if (Sprite_addr_sel == 3'b110)
// // 			ADDR = bike_red_left_addr;
// // 		else if (Sprite_addr_sel == 3'b111)
// // 			ADDR = bike_red_right_addr;
// // 	end

// // REG_SRAM_DATA should hold the information we want which is put into the DATA inout wire.
// assign Data = REG_SRAM_DATA;

// //The next lines should be putting whats in the REG_SRAM_DATA to the OCM when asked for.

// // This is for bikes
// always_comb
// 	begin
// 		if (Sprite_addr_sel == 3'b000)
// 			BIKE = Data_to_SRAM [1023:0];
// 		else if (Sprite_addr_sel == 3'b001)
// 			BIKE = Data_to_SRAM [1023*2:1024];
// 		else if (Sprite_addr_sel == 3'b010)
// 			BIKE = Data_to_SRAM [1023*3:1024*2];
// 		else if (Sprite_addr_sel == 3'b011)
// 			BIKE = Data_to_SRAM [1023*4:1024*3];
// 		else if (Sprite_addr_sel == 3'b100)
// 			BIKE = Data_to_SRAM [1023*5:1024*4];
// 		else if (Sprite_addr_sel == 3'b101)
// 			BIKE = Data_to_SRAM [1023*6:1024*5];
// 		else if (Sprite_addr_sel == 3'b110)
// 			BIKE = Data_to_SRAM [1023*7:1024*6];
// 		else if (Sprite_addr_sel == 3'b111)
// 			BIKE = Data_to_SRAM [1023*8:1024*7];
// 	end