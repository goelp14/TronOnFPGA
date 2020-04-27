module drawengine(
	input logic Clk, Reset, Run, Continue,
	input LD,
	input logic [2:0] Game_State,
	output logic CE, UB, LB, OE, WE,
	output logic [19:0] ADDR,
	inout wire [307199:0] Data //tristate buffers need to be of type wire
);

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// Declaration of SRAM DATA related wires
logic [307199:0] REG_SRAM_DATA;
logic [307199:0] SRAM_TO_DATA;
logic frame_sel;


// Register to Process Data and Use for OCM
always_ff @ (posedge Clk) begin
	if (Reset_ah)
		REG_SRAM_DATA <= 307200'0;
	else if (LD) begin
		REG_SRAM_DATA <= SRAM_TO_DATA;
	else
		REG_SRAM_DATA <= REG_SRAM_DATA;
	end
end

// SRAM Pull Logic (frame select should tell where from the SRAM its pulling and ADDR should be making sure that its pulling from the right address.
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR), .SRAMFRAME(frame_sel),
    .Data_from_REG(REG_SRAM_DATA), .Data_to_REG(SRAM_TO_DATA),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
);

// frame sel should be determined by the Game State
assign frame_sel = Game_State;

// REG_SRAM_DATA should hold the information we want which is put into the DATA inout wire.
assign Data = REG_SRAM_DATA;

//The next lines should be putting whats in the REG_SRAM_DATA to the OCM when asked for.
endmodule