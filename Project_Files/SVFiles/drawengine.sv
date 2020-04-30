module drawengine(
	input Clk, Reset, frame_clk,          // The clock indicating a new frame (~60Hz)
	input [9:0] DrawX, DrawY,
	input [1:0] Blue_dir, Red_dir       // Current pixel coordinates
	input [9:0] Blue_X_real, Blue_Y_real, Red_X_real, Red_Y_real,
    output logic [3:0]  color_enum             // Whether current pixel belongs to ball or background
    );

    parameter [9:0] Bike_Size = 10'd16;        // Ball size
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= Ball_Y_Step;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        
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