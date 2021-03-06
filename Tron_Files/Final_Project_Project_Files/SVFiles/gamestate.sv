//Game State Machine

module GameState (   input logic  Clk, Reset, Reset_Game, Reset_Round, Blue_W, Red_W,
					 input logic [1:0] Score_B, Score_R,
					 input logic  [7:0] keycode,
					 output logic [2:0] Game_State,
					 output logic [2:0] background_select,
					 output logic load_background
				);

	enum logic [2:0] {   Menu,
								Round_Paused,
								Round_Started,
								Blue_Wins,
								Red_Wins
							}   State, Next_state; // states
	// to detect keypress
	logic [7:0] oldkeycode;
	logic [2:0] background_sel;
	
	assign background_select = background_sel;
	
	always_ff @ (posedge Clk)
	begin
		if (Reset_Game || Reset)
			background_sel <= 3'b000;
		else if (State == Menu)  // choose next map after menu
			begin
			if (((keycode == 8'h1a) || (keycode == 8'h52))) // UPDATE TO NUMBER OF MAPS, 2'b1 is highest map, w or up arrow
				background_sel <= 3'b001;
			else if (((keycode == 8'h16) || (keycode == 8'h51))) // UPDATE TO NUMBER OF MAPS, 2'b1 is lowest map, s or down arrow
				background_sel <= 3'b100;
			else
				background_sel <= background_sel;
			end
		else if (State == Red_Wins || State == Blue_Wins)
			background_sel <= 3'b000;
		else if (State == Round_Started)
			if (Blue_W)
				background_sel <= 3'b010;
			else if (Red_W)
				background_sel <= 3'b011;
			else
				background_sel <= background_sel;
		else
			background_sel <= background_sel;
			
		// load in current keycode for keydown detection
		oldkeycode <= keycode;
	end
	
	assign Game_State = State;
		
	always_ff @ (posedge Clk)
	begin
		if (Reset_Game || Reset) 
			State <= Menu;
		else 
			begin
			State <= Next_state;
			end
	end
   
	always_comb
	begin 
		// Default Keep State
		Next_state = State;
		load_background = 1'b0;
		// Assign next state
		unique case (State)
			Menu :
				if (keycode == 8'h28) // enter
				begin
					Next_state = Round_Paused;
					load_background = 1'b1;
				end
								
			Round_Paused :
				if (keycode == 8'h28)
					Next_state = Round_Started;
			Round_Started :
				begin
					if (Blue_W)
						begin
							Next_state = Blue_Wins;
							load_background = 1'b1;
						end
					else if (Red_W)
						begin
							Next_state = Red_Wins;
							load_background = 1'b1;
						end
					else if (Reset_Round)
						begin
							Next_state = Round_Paused;
							load_background = 1'b1;
						end
				end
			Blue_Wins :
				if (keycode == 8'h28)
				begin
					Next_state = Menu;
					load_background = 1'b1;
				end
			Red_Wins :
				if (keycode == 8'h28)
				begin
					Next_state = Menu;
					load_background = 1'b1;
				end
			default : Next_state = State;

		endcase
	end
	
//	// for the menu mostly
//	always_comb
//	begin 
//		// Default Keep menu
//		newkeycode = oldkeycode;
//		
//		// Assign next state
//		unique case (State)
//			Menu :
//								
//			Round_Paused :
//
//			Round_Started :
//			
//			Blue_Wins :
//
//			Red_Wins :
//	
//			default : 
//
//		endcase
//	end
	
endmodule
