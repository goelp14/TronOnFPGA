module FB_tester(
	input [9:0] DrawX, DrawY,
	output [15:0] Data_Out,
	output [18:0] write_address,
	output we
    );

	 assign we = 1'b1;
//    assign write_address = DrawX/2 + DrawY * (640/2);
	 assign write_address = 19'd720;
	 assign Data_Out = 16'h3333;

endmodule