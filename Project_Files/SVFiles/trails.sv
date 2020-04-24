// this module saves where the trails are in the world, and also detects collisions

module trails ( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
			
					output logic collision_blue, collision_red,
               input logic [6:0] Blue_X, Blue_Y, Red_X, Red_Y,
					input logic [1:0] Blue_dir, Red_dir,
					input logic [2:0] Game_State
					);
					
					// play area is 448x448
					// 14x14 offset from top left corner
					
					
					// 464^2 = 200704 locations
					// if 4x4 subdivide = 112x112 = 12544 locations
					// can put in OCM
					logic [2:0] mem [0:12544];
					logic [2:0] read, write;
					
					
					always_ff @ (posedge Clk) 
					begin
					if (we)
						mem[write_address] <= write;
						read<= mem[read_address];
					end

endmodule