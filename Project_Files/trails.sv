// this module saves where the trails are in the world, and also detects collisions

module trails ( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					output logic collision_blue, collision_red,
               input logic [9:0] Blue_X, Blue_Y, Red_X, Red_Y,
					input logic [1:0] Blue_dir, Red_dir
					);
					
					// play area is 464x464
					// 5*464^2 = 1076480 bits = 1.07 Mb
					// if 4x4 subdivide = .06 Mb
					// can put in sram or OCM
					

endmodule