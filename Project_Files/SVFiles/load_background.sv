module load_background(
	input logic Clk, Reset, load, SRAM_done, OCM_done, // load to tell it to load the background, SRAM_done tells it that its ready.
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

// assign data out and addr
assign DATA_OUT = DATA_IN;

// addr_OCM is per byte, ADDR is per 2 bytes
assign addr_OCM = ADDR * 2;

// have reg to hold offset for the background selected
logic [19:0] OFFSET, address, nextaddr;

// states
enum logic [2:0] {idle, pause, read, write1, write2, done} state, nextState;

// set the offset to start loading at
// every background is 640x480 bytes + 2 bytes of xFF

always_ff @ (posedge Clk)
begin
	unique case (BG_Sel)
		2'b00: OFFSET <= 20'd0;
		2'b01: OFFSET <= 20'd307200;
		2'b10: OFFSET <= 20'd614400;
		2'b11: OFFSET <= 20'd921600;
		default: OFFSET <= 20'd0;
	endcase
end

// update state
always_ff @ (posedge Clk)
begin
	if (Reset)
		state <= idle;
	else
		state <= nextState;
end
// update addr
always_ff @ (posedge Clk)
begin
	if (Reset)
		addr <= 20'd0;
	else
		addr <= nextaddr;
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
			if (OCM_done)
				nextState = idle;
	endcase
end

// set control signals and stuff
always_comb 
begin
	// set defaults
	writing = 0;
	reading = 0;
	nextaddr = addr;
	
	unique case (state)
		idle:
			nextaddr = OFFSET;
		pause: ;
		read:
			reading = 1;          // tell SRAM to read at address
		write:
			writing = 1;          // tell OCM to write at address
			nextaddr = addr + 1;  // increment the address for next read
		default: ;
	endcase
end

endmodule