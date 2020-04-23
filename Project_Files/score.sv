// NOTES:
// Not sure what to output
// don't think frame_clk is needed
// Not sure if you can + 1 in alwaysff

module score ( input         Clk,                // 50 MHz clock
                             Reset_Score,        // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
									  
					input logic collision_blue, collision_red,
               output logic [1:0] score_blue, score_red
				 );
				 
				 
	always_ff @ (posedge Clk)
	begin
		if (collision_blue)
		begin
			score_blue <= score_blue + 1;
		end
		if (collision_red)
		begin
			score_red <= score_red + 1;
		end

endmodule