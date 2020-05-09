// module testbench();

// timeunit 10ns;
// timeprecision 1ns;

// 	// inputs
// 	logic [15:0] S;
// 	logic Clk, Reset, Run, Continue;
	
// 	//outputs
// 	logic [11:0] LED;
// 	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
// 	logic CE, UB, LB, OE, WE;
// 	logic [19:0] ADDR;
	
// 	logic [15:0] MDR, MAR, PC, IR;
	
// 	//bus
// 	wire [15:0] Data;
	
// lab6_toplevel top_level(.*);


// initial begin: CLOCK_INIT
// 	Clk = 0;
// end

// always begin: CLOCK_GEN
// 	#1 Clk = ~Clk;
// end

// always begin: DIAGNOSTIC_OUT
// 	#2 PC = top_level.my_slc.PCFF.Q;
// 	MAR = top_level.my_slc.MARFF.Q;
// 	MDR = top_level.my_slc.MDRFF.Q;
// 	IR = top_level.my_slc.IRFF.Q;
// end

// initial begin: TEST_VECTORS
// 	Reset = 0;
// 	Run = 0;
// 	Continue = 0;
	
// 	#2 Reset = 1;
// 	#2 Run = 1;
	
// 	#2 Continue = 1;
// 	#2 Continue = 0;
// 	#2 Continue = 1;
// 	#2 Continue = 0;
// 	#2 Continue = 1;
// 	#2 Continue = 0;
// 	#2 Continue = 1;
// 	#2 Continue = 0;

// 	#2 Continue = 1;
// 	#2 Continue = 0;
// 	#2 Continue = 1;
// 	#2 Continue = 0;
// 	#2 Continue = 1;
// 	#2 Continue = 0;	
// 	#2 Continue = 1;
// 	#2 Continue = 0;	
// end

// endmodule

module testbench();

	timeunit 10ns;
	timeprecision 1ns;

	logic [15:0]	S, Bus, MAR, MDR, IR, PC, SR1_OUT, SR2_OUT, offset6;
	logic [15:0]	R0, R1, R2, R3, R4, R5, R6, R7;
	logic				Clk, Reset, Run, Continue, BEN;
	logic [11:0]	LED;
	logic 			CE, UB, LB, OE, WE, LDREG;
	logic [19:0] 	ADDR;
	wire  [15:0] 	Data;
	logic [6:0]		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	int i, j;
	
	logic [2:0] DROUTMUX, SR2MUX, SR1MUX;
	
	logic [3:0] OPCODE;
	
	logic [4:0] CURRSTATE, NEXTSTATE;

	lab6_toplevel tp(.*);

	always begin: CLOCK_GEN
		#1 Clk = ~Clk;
	end

	initial begin: CLOCK_INIT
		Clk = 0;
	end

//	
	always begin: MONITORING
		// Basic Testing Stuff
		#2 MAR = tp.my_slc.MARFF.Q;
			MDR = tp.my_slc.MDRFF.Q;
			IR = tp.my_slc.IRFF.Q;
			PC = tp.my_slc.PCFF.Q;
			Bus = tp.my_slc.d0.Data;
			
		// Monitoring Register File
//			SR1_OUT = tp.my_slc.Register_File.SR1OUT;
//			SR2_OUT = tp.my_slc.Register_File.SR2OUT;
			LED = tp.my_slc.LED;
			R0 = tp.my_slc.Register_File.REGISTER[0];
			R1 = tp.my_slc.Register_File.REGISTER[1];
			R2 = tp.my_slc.Register_File.REGISTER[2];
			R3 = tp.my_slc.Register_File.REGISTER[3];
			R4 = tp.my_slc.Register_File.REGISTER[4];
			R5 = tp.my_slc.Register_File.REGISTER[5];
			R6 = tp.my_slc.Register_File.REGISTER[6];
			R7 = tp.my_slc.Register_File.REGISTER[7];
//			BEN = tp.my_slc.ben.BEN;
			
			// Check the Muxes
			DROUTMUX = tp.my_slc.Register_File.DRMUXIN;
			SR2MUX = tp.my_slc.Register_File.SR2IN;
			SR1MUX = tp.my_slc.Register_File.SR1IN;
			LDREG = tp.my_slc.Register_File.LDREG;
			
//			// Check our state machine
//			OPCODE = tp.my_slc.state_controller.Opcode;
//			CURRSTATE = tp.my_slc.state_controller.State;
//			NEXTSTATE = tp.my_slc.state_controller.Next_state;
		
		end
//Testing begins here

	initial begin: TEST_VECTORS
	
	#2		Reset 	= 0;
	#6		Reset 	= 1;
			S 			= 16'h0002;
	#2		Run 		= 0;
	#2		Run 		= 1;
	#2   	Run      = 0;
//	#10	S			= 16'h0002;
		
 // XOR Test 
// 		#2    Reset		= 0;
// 		#2    Reset 	= 1;
// 		#4    Run      = 0;
// 		#4    Run      = 1;
// 		      S        = 16'h0014;
//		#4	Continue = 0;
//		S        = 16'h0001;
//		#10  Continue = 1;
//		#4   Continue = 0;
//		S        = 16'h0001;
//		#4   Continue = 1;
//		#10  Continue = 0;
//		#2   Continue = 1;
	
	end
endmodule 