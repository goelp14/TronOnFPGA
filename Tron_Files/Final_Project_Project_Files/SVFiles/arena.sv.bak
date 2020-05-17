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


module  arena ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input 		  collision // signals to know if red/blue have collided into the trail
					input [7:0]   keycode,
               output logic [9:0] Blue_X, Blue_Y, Red_X, Red_Y,
					output logic [1:0] Blue_dir, Red_dir,
              );
    
    parameter [9:0] Arena_X_Spawn_blue = 10'd150;  // Center position on the X axis
	 parameter [9:0] Arena_X_Spawn_red = 10'd490;  // Center position on the X axis
    parameter [9:0] Arena_Y_Spawn = 10'd240;  // Center position on the Y axis
    parameter [9:0] Arena_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Arena_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Arena_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Arena_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Bike_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Bike_Y_Step = 10'd1;      // Step size on the Y axis
   
	 // logic to reset players+board without resetting score
	 logic reset_arena;
	 
	 logic [9:0] Blue_X, Blue_Y, Blue_X_M, Blue_Y_M, Blue_Y_M, Red_X, Red_Y, Red_X_M, Red_Y_M, Red_Y_M;
	 logic [9:0] Blue_X_new, Blue_Y_new, Blue_X_M_new, Blue_Y_M_new, Blue_Y_M_new, Red_X_new, Red_Y_new, Red_X_M_new, Red_Y_M_new, Red_Y_M_new;
	 
	 // logic to control which direction sprite is used
	 logic [1:0] Blue_dir, Red_dir, Blue_dir_new, Red_dir_new;
	 enum logic [1:0] {up, down, left, right};
	 

    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || reset_arena)
        begin
				// for blue bike
            Blue_X <= Arena_X_Spawn_blue;
            Blue_Y <= Arena_Y_Spawn;
            Blue_X_M <= Bike_X_Step;
            Blue_Y_M <= 10'd0;
				Blue_dir <= right;
				
				// for red bike
            Red_X <= Arena_X_Spawn_red;
            Red_Y <= Arena_Y_Spawn;
            Red_X_M <= ~(Bike_X_Step) + 1'b1;
            Red_Y_M <= 10'd0;
				Red_dir <= left;		
        end
        else
        begin
				// for blue bike
            Blue_X <= Blue_X_new;
            Blue_Y <= Blue_Y_new;
            Blue_X_M <= Blue_X_M_new;
            Blue_Y_M <= Blue_Y_M_new;
				Blue_dir <= Blue_dir_new;
				
				// for blue bike
            Red_X <= Red_X_new;
            Red_Y <= Red_Y_new;
            Red_X_M <= Red_X_M_new;
            Red_Y_M <= Red_Y_M_new;
				Red_dir <= Red_dir_new;
        end
    end

    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
		  // Blue
		  Blue_X_new = Blue_X
		  Blue_Y_new = Blue_Y
		  Blue_X_M_new = Blue_X_M
		  Blue_Y_M_new = Blue_Y_M
		  Blue_dir_new = Blue_Dir
		  //Red
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
            if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
            else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
                Ball_Y_Motion_in = Ball_Y_Step;
            // TODO: Add other boundary detections and handle keypress here.
			else if (Ball_X_Pos + Ball_Size >= Ball_X_Max) // Ball is at the right edge, BOUNCE!
				Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.
			else if (Ball_X_Pos <= Ball_X_Min + Ball_Size)// Ball is at the left edge, BOUNCE!
				Ball_X_Motion_in = Ball_X_Step;

				// w key - up
				if(keycode == 8'h1A)
					begin
						Ball_X_Motion_in = 10'd0;
						Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
						
						// Make sure key press doesn't override bounce
						if( Ball_Y_Pos <= Ball_Size + Ball_Y_Min )  // Ball is at the bottom edge, BOUNCE!
							Ball_Y_Motion_in = Ball_Y_Step;  // 2's complement.
					end
				
				// a key - left
				else if(keycode == 8'h04)
					begin
						Ball_Y_Motion_in = 10'd0;
						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.
						
						// Make sure key press doesn't override bounce
						if ( Ball_X_Pos <= Ball_X_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
							Ball_X_Motion_in = Ball_X_Step;
					end
					
				// s key - down
				else if (keycode == 8'h16)
					begin
						Ball_X_Motion_in = 10'd0;
						Ball_Y_Motion_in = Ball_Y_Step;  // 2's complement.
						
						// Make sure key press doesn't override bounce
						if (Ball_Y_Pos + Ball_Size >= Ball_Y_Max) // Ball is at the right edge, BOUNCE!
							Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
					end
					
				// d key - right
				else if (keycode == 8'h07)
					begin
						Ball_Y_Motion_in = 10'd0;
						Ball_X_Motion_in = Ball_X_Step;  // 2's complement.
						
						// Make sure key press doesn't override bounce
						if (Ball_X_Pos + Ball_Size >= Ball_X_Max) // Ball is at the left edge, BOUNCE!
							Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
					end
					
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end
        
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
              Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
              What is the difference between writing
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
              How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
            is_ball = 1'b1;
        else
            is_ball = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
    
endmodule
