// this module saves where the trails are in the world, and also detects collisions
// In the RAM: 0 = nothing, 1 = B_HORIZ, 2 = B_VERT, 3 = R_HORIZ, 4 = R_VERT, 5 = CORNER

// handles what type of trail to save to the frame buffer


module trails ( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					
					output logic [2:0] write_r, write_b,
               input logic [7:0] Blue_X, Blue_Y, Red_X, Red_Y,
					input logic [1:0] Blue_dir, Red_dir,
					input logic [2:0] Game_State
					);
					
					// play area is 448x448
					// 14x14 offset from top left corner
					

					logic [1:0] Blue_dir_old, Red_dir_old;
					
					logic [6:0] Blue_X_old, Red_X_old, Blue_Y_old, Red_Y_old;
					
					// update old values
					always_ff @ (posedge Clk) 
					begin
					if (Game_State == 3'b10)
						begin
						Blue_dir_old <= Blue_dir;
						Red_dir_old  <= Red_dir;
						Blue_X_old   <= Blue_X;
						Red_X_old    <= Red_X;
						Blue_Y_old   <= Blue_Y;
						Red_Y_old    <= Red_Y;
						end
					end
		
//					always_ff @ (posedge Clk) 
//					begin
//					if (Game_State == 3'b10)
//						begin
//						read_b<= mem[Blue_Y*112+Blue_X];
//						read_r<= mem[Red_Y*112+Red_X];
//						end
//					end
					
//					always_ff @ (posedge Clk) 
//					begin
//					if (Game_State == 3'b1)
//						mem <= 0;
//					else if (Game_State == 3'b10)
//						begin
//						mem[Blue_Y*112+Blue_X] <= write_b;
//						mem[Red_Y*112+Red_X] <= write_r;
//						end
//					end
					
					always_comb
					begin
						// default
//						collision_blue = 1'b0;
//						collision_blue = 1'b0;
						write_b = 3'b000;
						write_r = 3'b000;
						
						// check if new locations
						// blue
						if ((Blue_X_old != Blue_X) && (Blue_Y_old != Blue_Y))
						begin
							// update trails
							// corner
							if (Blue_dir != Blue_dir_old)
								write_b = 3'b101;
							// up or down
							else if ((Blue_dir == 2'b00) || (Blue_dir == 2'b01))
								write_b = 3'b010;
							// left or right
							else if ((Blue_dir == 2'b10) || (Blue_dir == 2'b11))
								write_b = 3'b001;
							else
								write_b = 3'b0;
						end
						
						// red
						if ((Red_X_old != Red_X) && (Red_Y_old != Red_Y))
						begin
							// update trails
							// corner
							if (Red_dir != Red_dir_old)
								write_r = 3'b101;
							// up or down
							else if ((Red_dir == 2'b00) || (Red_dir == 2'b01))
								write_r = 3'b100;
							// left or right
							else if ((Red_dir == 2'b10) || (Red_dir == 2'b11))
								write_r = 3'b011;		
						end
						else
							write_r = 3'b0;
						
					end
					

endmodule