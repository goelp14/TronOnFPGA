module load_background(
	input logic Clk, Reset, load
	input logic [1:0] BG_Sel,
	input logic [2:0] Game_State,
	input logic [15:0] DATA_IN,
	output logic writing, reading,
	output logic [19:0] ADDR,
	output logic [15:0] DATA_OUT,
);

// notes:
// unsure on offsets, also if (DATA_IN > 16'h0F01) ~ line 55, not sure if need 2 writes

// loads 2 bytes at a time
// 640 * 153600 = 0

// assign data out and addr
assign DATA_OUT = DATA_IN;

// have reg to hold offset for the background selected
logic [19:0] OFFSET, address;

// states
enum logic [2:0] {idle, read, write1, write2, done} state, nextState;

// set the offset to start loading at
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
	else:
		state <= nextState;
end

// set next state
always_comb 
begin
	// set defaults
	nextState = state;
	
	unique case (state)
		idle:
			if (load)
				nextState = read;
		read:
			if (DATA_IN > 16'h0F01)
				nextState = done;
			else
				nextState = write1;
		write1:
			nextState = write2;
		write2:
			nextState = read;
		done:
			nextState = idle;
		
	endcase
end

// set next state
always_comb 
begin
	// set defaults
	writing = 0;
	
	unique case (state)
		idle:
			
		read:
			
		write1:
		
		write2:
		
		done:
			nextstate = idle;
		
	endcase
end

endmodule