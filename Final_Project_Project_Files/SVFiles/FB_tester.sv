module FB_tester(
	output [15:0] Data_Out,
	output [18:0] write_address,
	output we
    );

	 assign we = 1'b1;
    assign write_address = DrawX/2 + DrawY * (640/2);
	 assign Data_Out = 16'h0303;

endmodule