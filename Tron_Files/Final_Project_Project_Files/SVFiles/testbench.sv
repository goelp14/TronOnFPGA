module testbench();

 timeunit 10ns;
 timeprecision 1ns;

 logic Clk = 0;              // 50 MHz clock
 logic Reset_Score;     // Active-high reset signal
 logic frame_clk = 0;        // The clock indicating a new frame (~60Hz)
 logic [2:0]   Game_State;			  
 logic [9:0] Blue_X_real, Blue_Y_real, Red_X_real, Red_Y_real;
 logic [7:0] Blue_X, Blue_Y, Red_X, Red_Y;
 logic [1:0] Blue_dir, Red_dir;
 
arena arena(.*);
 
 always begin : CLOCK_GENERATION

#1 Clk = ~Clk;
end

initial begin : CLOCK_INITIALIZATION

   Clk = 0;
	
	end
 
 
 
initial begin : TEST_VECTORS

	 Reset_Score = 1'b1;
	 Game_State = 3'd1;
	 
	 #2 Reset_Score = 1'b0;
	 #10 red_color = 8'b0;
	 #44 red_color = 8'b1;
	 #58 blue_color = 8'b0;
	 #85 blue_color = 8'b1;
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