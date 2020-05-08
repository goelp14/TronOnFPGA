module load_background(
	input logic Clk, Reset, load, SRAM_done,// OCM_done, // load to tell it to load the background, SRAM_done tells it that its ready.
	input logic [1:0] BG_Sel,
	input logic [2:0] Game_State,
	input logic [15:0] DATA_IN,
	output logic writing, reading, // writing tells OCM FB that its writing, reading tells SRAM that its reading
	output logic [19:0] ADDR,     // for the sram
	output logic [18:0] addr_OCM, // for the OCM to know where to store
	output logic [15:0] DATA_OUT
);

// notes:
// unsure on offsets, also if (DATA_IN > 16'h0F01) ~ line 55, not sure if need 2 writes ??
// unsure on if we need a delay state to allow OFFSET to update

// loads 2 bytes at a time
// 640 * 153600 = 0
logic [15:0] SRAM_OUT_DATA;

// assign data out and addr
assign SRAM_OUT_DATA = DATA_IN;

//// addr_OCM is per byte, ADDR is per 2 bytes
//assign addr_OCM = ADDR * 2;

assign addr_OCM = OCM_addr_reg;
assign ADDR = address;

// have reg to hold offset for the background selected
logic [19:0] OFFSET, address, nextaddr;
logic [18:0] OCM_addr_reg, OCM_addr_new;

// states
enum logic [2:0] {idle, pause, read, write, done} state, nextState;

// set the offset to start loading at

// every background is 640x480 bytes + 2 bytes of xFF
// offset /2 cuz 16 bits at a time

always_ff @ (posedge Clk)
begin
	unique case (BG_Sel)
		2'b00: OFFSET <= 20'd0;
		2'b01: OFFSET <= 20'd153601;
		2'b10: OFFSET <= 20'd307202;
		2'b11: OFFSET <= 20'd460803;
		default: OFFSET <= 20'd0;
	endcase
end

// update state
always_ff @ (posedge Clk)
begin
	if (Reset)
		state <= pause;
	else
		state <= nextState;
end
// update addr
always_ff @ (posedge Clk)
begin
	if (Reset)
		begin
		address <= 20'd0;
		OCM_addr_reg <= 19'd0;
		end
	else
		begin
		address <= nextaddr;
		OCM_addr_reg <= OCM_addr_new;
		end
end


// set next state

// keep on reading 16 bits from sram and then writing to OCM until end char
always_comb 
begin
	// set defaults
	nextState = state;
	
	unique case (state)
		idle:
			if (load)
				nextState = pause;
		pause: nextState = read;
		read:
			if (DATA_IN > 16'hF000) // worst case senario: h0F0F
				nextState = done;
			else if (SRAM_done)
				nextState = write;
		write:
			//if (OCM_done)
			nextState = read;
		done:
			if (~load)
				nextState = idle;
		default:
			nextState = idle;
	endcase
end

// set control signals and stuff
always_comb 
begin
	// set defaults
	writing = 0;
	reading = 0;
	nextaddr = address;
	OCM_addr_new = OCM_addr_reg;
	DATA_OUT = 16'b0;
	unique case (state)
		idle:
			begin
			nextaddr = OFFSET;
			OCM_addr_new = 19'd0;
			end
		pause:
			begin
			nextaddr = OFFSET;
			OCM_addr_new = 19'd0;
			end
		read:
			begin
				reading = 1'b1;          // tell SRAM to read at address
				DATA_OUT = SRAM_OUT_DATA;
			end
		write:
		begin
			DATA_OUT = SRAM_OUT_DATA;
			writing = 1'b1;            // tell OCM to write at address
			OCM_addr_new = OCM_addr_reg + 19'b1; // increment the OCM address
			nextaddr = address + 1'b1;  // increment the address for next read
		end
		done: ;
		default: ;
	endcase
end

endmodule