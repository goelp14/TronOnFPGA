//Game State Machine

module ISDU (   input logic  Clk, Reset_Game, Reset_Round, Blue_W, Red_W,
					 input logic  [7:0] keycode,
					 output logic [2:0] Game_State
				
				);

	enum logic [2:0] {   Menu,
								Round_Paused,
								Round_Started,
								Blue_Wins,
								Red_Wins
							}   State, Next_state; // states
							
	assign Game_State = State;
		
	always_ff @ (posedge Clk)
	begin
		if (Reset_Game) 
			State <= Menu;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default Keep State
		Next_state = State;
		
		// Assign next state
		unique case (State)
			Menu :
				if (keycode == 8'h28)
					Next_state = Round_Paused;
								
			Round_Paused :
				if (keycode)
					Next_state = Round_Started;
			Round_Started :
					if (Reset_Round)
						Next_state = Round_Paused;
					else if (Blue_W)
						Next_state = Blue_Wins;
					else if (Red_W)
						Next_state = Red_Wins;
			Blue_Wins :
				if (keycode)
					Next_state = Menu;
			Red_Wins :
				if (keycode)
					Next_state = Menu;		
			default : Next_state = Menu;

		endcase
	end
	
endmodule
