// this module saves where the trails are in the world, and also detects collisions
// In the RAM: 0 = nothing, 1 = B_HORIZ, 2 = B_VERT, 3 = R_HORIZ, 4 = R_VERT, 5 = CORNER

// handles what type of trail to save to the frame buffer


module trails2 ( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					
					output logic [15:0] write,
					output logic [19:0] trail_addr,
					output logic we,
					
               input logic [7:0] Blue_X, Blue_Y, Red_X, Red_Y,
					input logic [1:0] Blue_dir, Red_dir,
					input logic [1:0] r_or_b,
					input logic [2:0] Game_State
					);
					
	// play area is 448x448
	// 14x14 offset from top left corner
//	logic [2:0] write_b, write_b_ff, write_r, write_r_ff;

	logic write_col, write_col_next, offset;

	logic [1:0] Blue_dir_old, Red_dir_old;
	
	logic [7:0] Blue_X_old, Red_X_old, Blue_Y_old, Red_Y_old;
	
	logic [1:0] blueline, nextBlueLine, redline, nextRedLine;
	
	logic [19:0]curr_address_b, next_address_b, curr_address_r, next_address_r, blue_addr, red_addr, w_a1, w_a2, w_a3, w_a4, c_a;
	
	logic [1:0] r_or_b_ff;

	always_ff @ (posedge Clk)
	begin
		if (r_or_b != r_or_b_ff)
			r_or_b_ff <= r_or_b;
		else
			r_or_b_ff <= r_or_b_ff;
	end


	assign w_a1 = (r_or_b_ff) ? (Red_X + 8)*2 + (Red_Y)*320*4 : (Blue_X + 8)*2 + (Blue_Y)*320*4;
	assign w_a2 = w_a1 + 1;
	assign w_a3 = w_a1 + (320);
	assign w_a4 = w_a1 + (320) + 1;
	
	//just in case you want to try 4x4 again but fyi it do't work
	assign w_a5 = w_a1 + (320*2);
	assign w_a6 = w_a1 + (320*2) + 1;
	assign w_a7 = w_a1 + (320*3);
	assign w_a8 = w_a1 + (320*3) + 1;
	
//	always_comb
//		begin
//			if (Red_dir == 2'b00)
//				red_addr = (Red_X + 8)*2 + (Red_Y + 9)*320*4;
//			else if (Red_dir == 2'b01)
//				red_addr = (Red_X + 8)*2 + (Red_Y - 9)*320*4;
//			else if (Red_dir == 2'b10)
//				red_addr = (Red_X + 17)*2 + (Red_Y)*320*4;
//			else
//				red_addr = (Red_X - 2)*2 + (Red_Y)*320*4;
//		end
//	
//	always_comb
//		begin
//			if (Blue_dir == 2'b00)
//				blue_addr = (Blue_X + 8)*2 + (Blue_Y + 9)*320*4;
//			else if (Blue_dir == 2'b01)
//				blue_addr = (Blue_X + 8)*2 + (Blue_Y - 9)*320*4;
//			else if (Blue_dir == 2'b10)
//				blue_addr = (Blue_X + 17)*2 + (Blue_Y)*320*4;
//			else
//				blue_addr = (Blue_X - 2)*2 + (Blue_Y)*320*4;
//		end
	
	enum logic [3:0] {one,two,three,four,five,six,seven,eight} state, nextState;

	assign trail_addr = c_a;
	
//	always_comb
//		begin
//			case (blue_dir)
//				2'b00: blue_addr = (Blue_X+6)*2 + (Blue_Y)*320*4
//			endcase
//		end
	
	always_ff @ (posedge Clk)
		begin
			if (Reset || Game_State != 3'b10)
				begin
					state <= one;
					offset <= 1'b0;
				end
			else
				begin
					offset <= ~offset;
					state <= nextState;
				end
		end
		
	always_comb
		begin
			unique case(state)
				one: nextState = two;
				two: nextState = three;
				three: nextState = four;
				four: nextState = five;
				five: nextState = six;
				six: nextState = seven;
				seven: nextState = eight;
				eight: nextState = one;
			endcase
		end
	
	always_comb
		begin
			unique case(state)
				one: c_a = w_a1;
				two: c_a = w_a3;
				three: c_a = w_a2;
				four: c_a = w_a4;
				five: c_a = w_a5;
				six: c_a = w_a6;
				seven: c_a = w_a7;
				eight: c_a = w_a8;
			endcase
		end
endmodule
