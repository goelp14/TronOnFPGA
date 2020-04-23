//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------

// inputs clk, reset (the arena), frame clk, keycode
// outputs if either bike has ran into the boundaries, the bikes positions, and their directions

// THINGS TO PAY ATTENTION TO: (notes)
// Collision is ASYNC
// declared Blue_X, Red_X, etc twice, once in module init, and once in logic. Not sure which one to use...
// Blue_X, Red_X used for internal logic so if u want to change it change the name of the output variable
// Only doing blue movement for now
// right now grid is pixel screen size, but might need to downscale x4
// Collision regs: will they reset before reset/signal is outputted?



module  arena ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [7:0]   keycode,
					output logic collision_blue, collision_red,
               output logic [9:0] Blue_X, Blue_Y, Red_X, Red_Y,
					output logic [1:0] Blue_dir, Red_dir
              );
    
    parameter [9:0] Arena_X_Spawn_blue = 10'd76;  // Center position on the X axis
	 parameter [9:0] Arena_X_Spawn_red = 10'd400;  // Center position on the X axis
    parameter [9:0] Arena_Y_Spawn = 10'd240;  // Center position on the Y axis
    parameter [9:0] Arena_X_Min = 10'd14;       // Leftmost point on the X axis
    parameter [9:0] Arena_X_Max = 10'd462;     // Rightmost point on the X axis
    parameter [9:0] Arena_Y_Min = 10'd14;       // Topmost point on the Y axis
    parameter [9:0] Arena_Y_Max = 10'd462;     // Bottommost point on the Y axis
    parameter [9:0] Bike_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Bike_Y_Step = 10'd1;      // Step size on the Y axis
	 parameter [9:0] Bike_Size = 10'd16;      // Bike size for collision detection

	 logic [9:0] Blue_X, Blue_Y, Blue_X_M, Blue_Y_M, Blue_Y_M, Red_X, Red_Y, Red_X_M, Red_Y_M, Red_Y_M;
	 logic [9:0] Blue_X_new, Blue_Y_new, Blue_X_M_new, Blue_Y_M_new, Blue_Y_M_new, Red_X_new, Red_Y_new, Red_X_M_new, Red_Y_M_new, Red_Y_M_new;
	 
	 // logic to control which direction sprite is used
	 logic [1:0] Blue_dir, Red_dir, Blue_dir_new, Red_dir_new;
	 enum logic [1:0] {up, down, left, right};
		
	 // Collision flags
	 logic new_collision_blue, new_collision_red
	 
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) 
	 begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
    // Update registers
	 //Blue
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
				// for blue bike
            Blue_X <= Arena_X_Spawn_blue;
            Blue_Y <= Arena_Y_Spawn;
            Blue_X_M <= Bike_X_Step;
            Blue_Y_M <= 10'd0;
				Blue_dir <= right;
				collision_blue <= 1'b0
        end
        else
        begin
				// for blue bike
            Blue_X <= Blue_X_new;
            Blue_Y <= Blue_Y_new;
            Blue_X_M <= Blue_X_M_new;
            Blue_Y_M <= Blue_Y_M_new;
				Blue_dir <= Blue_dir_new;
				collision_blue <= new_collision_blue
        end
    end
		
	 // Red
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Red_X <= Arena_X_Spawn_red;
            Red_Y <= Arena_Y_Spawn;
            Red_X_M <= ~(Bike_X_Step) + 1'b1;
            Red_Y_M <= 10'd0;
				Red_dir <= left;		
				collision_red <= 1'b0
        end
        else
        begin
            Red_X <= Red_X_new;
            Red_Y <= Red_Y_new;
            Red_X_M <= Red_X_M_new;
            Red_Y_M <= Red_Y_M_new;
				Red_dir <= Red_dir_new;
				collision_red <= new_collision_red
        end
    end
	 
    // You need to modify always_comb block.
    always_comb
    begin
        // default
		  // no collisions
		  new_collision_blue = 1'b0;

		  // keep motion and position unchanged

		  Blue_X_new = Blue_X
		  Blue_Y_new = Blue_Y
		  Blue_X_M_new = Blue_X_M
		  Blue_Y_M_new = Blue_Y_M
		  Blue_dir_new = Blue_Dir

        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
				
				// Collision Detection

            if(Blue_Y + Bike_Size >= Arena_Y_Max )        // Bike hits bottom edge
                new_collision_blue = 1'b1;  
            else if (Blue_Y <= Arena_Y_Min + Bike_Size )  // Bike hits top edge
                new_collision_blue = 1'b1;
				else if (Blue_X + Bike_Size >= Arena_X_Max)    // Bike hits right edge
					new_collision_blue = 1'b1;  
				else if (Blue_X <= Arena_X_Min + Bike_Size)    // Bike hits left edge
					new_collision_blue = 1'b1;

				// w key - up
				if(keycode == 8'h1A)
					begin
						Blue_X_M_new = 10'd0;
						Blue_Y_M_new = (~(Bike_Y_Step) + 1'b1);  // 2's complement.
						Blue_dir_new = up;
						
						// Make sure key press doesn't override bounce
						if( Blue_Y + Bike_Size >= Arena_Y_Max )  // Bike hits bottom edge
							new_collision_blue = 1'b1;
					end
				
				// a key - left
				else if(keycode == 8'h04)
					begin
						Blue_X_M_new = 10'd0;
						Blue_Y_M_new = (~(Bike_X_Step) + 1'b1);  // 2's complement.
						Blue_dir_new = left;
						
						// Make sure key press doesn't override bounce
						if ( Blue_Y <= Arena_Y_Min + Bike_Size )  // Bike hits top edge
							new_collision_blue = 1'b1;
					end
					
				// s key - down
				else if (keycode == 8'h16)
					begin
						Blue_X_M_new = 10'd0;
						Blue_Y_M_new = Bike_Y_Step;
						Blue_dir_new = down;
						
						// Make sure key press doesn't override bounce
						if (Blue_X + Bike_Size >= Arena_X_Max)    // Bike hits right edge
							new_collision_blue = 1'b1; 
					end
					
				// d key - right
				else if (keycode == 8'h07)
					begin
						Blue_Y_M_new = 10'd0;
						Blue_X_M_new = Bike_X_Step;
						Blue_dir_new = right;
						
						// Make sure key press doesn't override bounce
						if (Blue_X <= Arena_X_Min + Bike_Size)    // Bike hits left edge
							new_collision_blue = 1'b1;
					end
					
            // Update the bike's position with its motion
            Blue_X_new = Blue_X + Blue_X_M;
            Blue_Y_new = Blue_Y + Blue_Y_M;
        end
    end

	 
	 // for the red bike
	 always_comb
    begin
        // default
		  // no collisions
		  new_collision_red = 1'b0;
		  // keep motion and position unchanged

		  Red_X_new = Red_X
		  Red_Y_new = Red_Y
		  Red_X_M_new = Red_X_M
		  Red_Y_M_new = Red_Y_M
		  Red_dir_new = Red_Dir
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
				
				// Collision Detection

				if(Red_Y + Bike_Size >= Arena_Y_Max)        // Bike hits bottom edge
                new_collision_red = 1'b1;  
            else if (Red_Y <= Arena_Y_Min + Bike_Size )  // Bike hits top edge
                new_collision_red = 1'b1;
				else if (Red_X + Bike_Size >= Arena_X_Max)    // Bike hits right edge
					new_collision_red = 1'b1;  
				else if (Red_X <= Arena_X_Min + Bike_Size)    // Bike hits left edge
					new_collision_red = 1'b1;
					
				// arrow key - up
				if(keycode == 8'h52)
					begin
						Red_X_M_new = 10'd0;
						Red_Y_M_new = (~(Bike_Y_Step) + 1'b1);  // 2's complement.
						Red_dir_new = up;
						
						// Make sure key press doesn't override bounce
						if( Red_Y + Bike_Size >= Arena_Y_Max )  // Bike hits bottom edge
							new_collision_red = 1'b1;
					end
				
				// arrow key - left
				else if(keycode == 8'h50)
					begin
						Red_X_M_new = 10'd0;
						Red_Y_M_new = (~(Bike_X_Step) + 1'b1);  // 2's complement.
						Red_dir_new = left;
						
						// Make sure key press doesn't override bounce
						if ( Red_Y <= Arena_Y_Min + Bike_Size )  // Bike hits top edge
							new_collision_red = 1'b1;
					end
					
				// arrow key - down
				else if (keycode == 8'h51)
					begin
						Red_X_M_new = 10'd0;
						Red_Y_M_new = Bike_Y_Step;
						Red_dir_new = down;
						
						// Make sure key press doesn't override bounce
						if (Red_X + Bike_Size >= Arena_X_Max)    // Bike hits right edge
							new_collision_red = 1'b1; 
					end
					
				// arrow key - right
				else if (keycode == 8'h4f)
					begin
						Red_Y_M_new = 10'd0;
						Red_X_M_new = Bike_X_Step;
						Red_dir_new = right;
						
						// Make sure key press doesn't override bounce
						if (Red_X <= Arena_X_Min + Bike_Size)    // Bike hits left edge
							new_collision_red = 1'b1;
					end
					
            // Update the bike's position with its motion
            Red_X_new = Red_X + Red_X_M;
            Red_Y_new = Red_Y + Red_Y_M;
        end
    end
	 
endmodule
