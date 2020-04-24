// NOTES:
// Not sure what to output
// don't think frame_clk is needed
// Not sure if you can + 1 in alwaysff

module score ( input         Clk,                // 50 MHz clock
                             Reset_Score,        // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [2:0]   Game_State,				  
					input logic collision_blue, collision_red, 
					output logic Blue_W, Red_W,
               output logic [1:0] score_blue, score_red
				 );
	
	logic [1:0] score_blue_reg, score_red_reg;
	
	assign score_blue = score_blue_reg;
	assign score_red  = score_red_reg;
	
	always_ff @ (posedge Clk)
	begin
		if (Reset_Score || (Game_State == 3'b1))
		begin
			score_blue_reg <= 0;
			score_red_reg  <= 0;
		end
		else if (collision_blue)
		begin
			score_blue_reg <= score_blue_reg + 1;
		end
		else if (collision_red)
		begin
			score_red_reg <= score_red_reg + 1;
		end
	end
	
	
	always_comb
	begin
		//default values
		Blue_W = 1'b0;
		Red_W  = 1'b0;
		if (score_blue_reg == 3)
			Blue_W = 1'b1;
		else if (score_red_reg == 3)
			Red_W = 1'b1;
	end
endmodule