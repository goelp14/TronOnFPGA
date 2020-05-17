 module testbench();

 timeunit 10ns;
 timeprecision 1ns;

logic Clk, Reset, frame_clk;
logic [2:0] Game_State;
logic [7:0] keycode;
logic [9:0] Blue_X_real, Blue_Y_real, Red_X_real, Red_Y_real;
logic [7:0] Blue_X, Blue_Y, Red_X, Red_Y;
logic [1:0] Blue_dir, Red_dir;
 
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