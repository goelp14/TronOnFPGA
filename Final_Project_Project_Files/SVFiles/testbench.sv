 module testbench();

 timeunit 10ns;
 timeprecision 1ns;

 logic Clk = 0;              // 50 MHz clock
 logic Reset_Score;     // Active-high reset signal
 logic frame_clk = 0;        // The clock indicating a new frame (~60Hz)
 logic [2:0]   Game_State;			  
 logic [7:0] red_color, blue_color;
 logic Blue_W, Red_W, reset_round;
 logic [1:0] score_blue, score_red;
 
 score scorer(.*);
 
 always begin : CLOCK_GENERATION

#1 Clk = ~Clk;
end

initial begin : CLOCK_INITIALIZATION

   Clk = 0;
	
	end
 
 
 
initial begin : TEST_VECTORS

    red_color = 8'b1;
	 blue_color = 8'b1;
	 Reset_Score = 1'b1;
	 Game_State = 3'd1;
	 
	 #2 Reset_Score = 1'b0;
	 #5 red_color = 8'b0;
	 #5 red_color = 8'b1;
	 #8 blue_color = 8'b0;
	 #8 blue_color = 8'b1;
	 #11 red_color = 8'b0;
	 #11 red_color = 8'b1;
	 #16 blue_color = 8'b0;
	 #16 blue_color = 8'b1;
	 #20 blue_color = 8'b0;
	 #20 blue_color = 8'b1;
	 #25 Game_State = 3'd4;
	 

 

 end 
//
//	initial begin: TEST_VECTORS
//	
//		#2 keycode = 8'h28;
//		#2 keycode = 8'h28;
////	#10	S			= 16'h0002;
//		
// // XOR Test 
//// 		#2    Reset		= 0;
//// 		#2    Reset 	= 1;
//// 		#4    Run      = 0;
//// 		#4    Run      = 1;
//// 		      S        = 16'h0014;
////		#4	Continue = 0;
////		S        = 16'h0001;
////		#10  Continue = 1;
////		#4   Continue = 0;
////		S        = 16'h0001;
////		#4   Continue = 1;
////		#10  Continue = 0;
////		#2   Continue = 1;
//	
//	end
endmodule 