// this module saves where the trails are in the world, and also detects collisions

module trails ( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					output logic collision_blue, collision_red,
               input logic [9:0] Blue_X, Blue_Y, Red_X, Red_Y,
					input logic [1:0] Blue_dir, Red_dir
					);
					
					// play area is 448x448
					// 14x14 offset from top left corner
					
					// 464^2 = 200704 Bytes
					// if 4x4 subdivide = 12544 Bytes
					// can put in sram or OCM
					
					logic [6:0] x_grid_blue, x_grid_red, y_grid_blue, y_grid_red;
					
					assign x_grid_blue = Blue_X / 4;
					assign y_grid_blue = Blue_Y / 4;
					assign x_grid_red  = Red_X  / 4;
					assign y_grid_red  = Red_Y  / 4;
					
					

endmodule