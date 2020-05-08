// NOTES:
// Not sure what to output
// don't think frame_clk is needed
// Not sure if you can + 1 in alwaysff
// No longer need collision_blue, Collision_red, collision_blue_trail, collision_red_trail with new render method

module score ( input         Clk,                // 50 MHz clock
                             Reset_Score,        // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [2:0]   Game_State,				  
					input logic [7:0] red_color, blue_color,
					output logic Blue_W, Red_W, reset_round,
               output logic [1:0] score_blue, score_red
				 );
	
	logic [1:0] score_blue_reg, score_red_reg;
	enum logic [3:0] {nocountb, raiseflagb1, blue_count1, raiseflagb2, blue_count2, raiseflagb3, blue_count3, restartb} stateb, nextStateb;
	enum logic [3:0] {nocountr, raiseflagr1, red_count1, raiseflagr2, red_count2,raiseflagr3, red_count3, restartr} stater, nextStater;
	logic reset_flag, reset_flagr, reset_flag_nextr, reset_flagb, reset_flag_next;
	
	assign score_blue = score_blue_reg;
	assign score_red  = score_red_reg;
	assign reset_round = reset_flagr | reset_flagb;
	
	always_ff @ (posedge Clk)
		begin
			if (Reset_Score || Game_State == 3'b0)
				begin
					stateb <= nocountb;
					stater <= nocountr;
				end
			else
				begin
					stateb <= nextStateb;
					stater <= nextStater;
				end
		end
	
	always_comb
		begin
			unique case(stateb)
				nocountb:
					begin
						if (blue_color != 8'b1)
							nextStateb = raiseflagb1;
						else if (score_red_reg == 2'd3)
							nextStateb = restartb;	
						else
							nextStateb = stateb;
					end
				raiseflagb1: nextStateb = blue_count1;
				blue_count1:
					begin
						if (blue_color != 8'b1)
							nextStateb = raiseflagb2;	
						else if (score_red_reg == 2'd3)
							nextStateb = restartb;
						else
							nextStateb = stateb;
					end
				raiseflagb2: nextStateb = blue_count2;
				blue_count2:
					begin
						if (blue_color != 8'b1)
							nextStateb = raiseflagb3;
						else if (score_red_reg == 2'd3)
							nextStateb = restartb;
						else
							nextStateb = stateb;
					end
				raiseflagb3: nextStateb = blue_count3;
				blue_count3: nextStateb = restartb;
				restartb: nextStateb = nocountb;
				default: nextStateb = stateb;
			endcase
		end
	
	always_comb
		begin
			unique case(stater)
				nocountr:
					begin
						if (red_color != 8'b1)
							nextStater = raiseflagr1;
						else if (score_blue_reg == 2'd3)
							nextStater = restartr;
						else
							nextStater = stater;
					end
				raiseflagr1: nextStater = red_count1;
				red_count1:
					begin
						if (red_color != 8'b1)
							nextStater = raiseflagr2;
						else if (score_blue_reg == 2'd3)
							nextStater = restartr;
						else
							nextStater = stater;
					end
				raiseflagr2: nextStater = red_count2;
				red_count2:
					begin
						if (red_color != 8'b1)
							nextStater = raiseflagr3;
						else if (score_blue_reg == 2'd3)
							nextStater = restartr;
						else
							nextStater = stater;
					end
				raiseflagr3: nextStater = red_count3;
				red_count3: nextStater = restartr;
				restartr: nextStater = nocountr;
				default: nextStater = stater;
			endcase
		end
		
		always_comb
			begin
				reset_flagr = 1'b0;
				unique case(stater)
				nocountr:
					begin
						reset_flagr = 1'b0;
						score_red_reg = 2'd0;
						Blue_W = 1'b0;
					end
				raiseflagr1:
					begin
						reset_flagr = 1'b1;
						score_red_reg = 2'd0;
						Blue_W = 1'b0;
					end
				red_count1:
					begin
						reset_flagr = 1'b0;
						score_red_reg = 2'd1;
						Blue_W = 1'b0;
					end
				raiseflagr2:
					begin
						reset_flagr = 1'b1;
						score_red_reg = 2'd1;
						Blue_W = 1'b0;
					end
				red_count2:
					begin
						reset_flagr = 1'b0; 
						score_red_reg = 2'd2;
						Blue_W = 1'b0;
					end
				raiseflagr3:
					begin
						reset_flagr = 1'b1;
						score_red_reg = 2'd2;
						Blue_W = 1'b0;
					end
				red_count3:
					begin
						reset_flagr = 1'b0;
						score_red_reg = 2'd3;
						Blue_W = 1'b1;
					end
				restartb: 
					begin
						reset_flagr = 1'b0;
						score_red_reg = 2'd0;
						Blue_W = 1'b0;
					end
				default: ;
			endcase
		end
			
		always_comb
			begin
				reset_flagb = 1'b0;
				unique case(stateb)
				nocountb:
					begin
						reset_flagb = 1'b0;
						score_blue_reg = 2'd0;
						Red_W = 1'b0;
					end
				raiseflagb1:
					begin
						reset_flagb = 1'b1;
						score_blue_reg = 2'd0;
						Red_W = 1'b0;
					end
				blue_count1:
					begin
						reset_flagb = 1'b0;
						score_blue_reg = 2'd1;
						Red_W = 1'b0;
					end
				raiseflagb2:
					begin
						reset_flagb = 1'b1;
						score_blue_reg = 2'd1;
						Red_W = 1'b0;
					end
				blue_count2:
					begin
						reset_flagb = 1'b0; 
						score_blue_reg = 2'd2;
						Red_W = 1'b0;
					end
				raiseflagb3:
					begin
						reset_flagb = 1'b1;
						score_blue_reg = 2'd2;
						Red_W = 1'b0;
					end
				blue_count3:
					begin
						reset_flagb = 1'b0;
						score_blue_reg = 2'd3;
						Red_W = 1'b1;
					end
				restartb: 
					begin
						reset_flagb = 1'b0;
						score_blue_reg = 2'd0;
						Red_W = 1'b0;
					end
				default: ;
			endcase
		end
//	always_ff @ (posedge Clk)
//	begin
//		if (Reset_Score || (Game_State == 3'b0))
//		begin
//			score_blue_reg <= 0;
//			score_red_reg  <= 0;
//		end
//		else if (Game_State == 3'b1)
//			begin
//				reset_flag <= 0;
//				score_red_reg <= score_red_reg;
//				score_blue_reg <= score_blue_reg;
//			end
//		else if (blue_color != 8'b1)
//		begin
//			score_blue_reg <= score_blue_reg + 2'b1;
//			reset_flag <= 1;
//		end
//		else if (red_color != 8'b1)
//		begin
//			score_red_reg <= score_red_reg + 2'b1;
//			reset_flag <= 1;
//		end
//		else
//			reset_flag <= 0;
//			score_red_reg <= score_red_reg;
//			score_blue_reg <= score_blue_reg;
//	end
	
	
//	always_comb
//	begin
//		//default values
//		Blue_W = 1'b0;
//		Red_W  = 1'b0;
//		if (score_blue_reg == 3)
//			Blue_W = 1'b1;
//		else if (score_red_reg == 3)
//			Red_W = 1'b1;
//	end
endmodule
