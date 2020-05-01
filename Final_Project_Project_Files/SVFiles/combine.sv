module combine(
	input Clk, Reset, frame_clk, WE,        // The clock indicating a new frame (~60Hz)
	input [9:0] DrawX, DrawY,
	input [3:0] Data_In_Bike,
	input [18:0] write_address,
    output logic [3:0]  color_enum         
    );


	logic [15:0] data_In_b, data_In_r;
	logic [19:0] read_address;
	logic [15:0] data_Out;
	logic [3:0]  out_byte;

	always_comb begin
		if (Data_In_Bike == 8'h15)
			begin
				read_address = DrawX/2 + DrawY * (640/2);
				if (DrawX % 2 == 1)
					out_byte = data_Out [3:0];
				else
					out_byte = data_Out [7:4];
			end
		else
			out_byte = Data_In_Bike;
	end
	
	frameRAM frame_buffer (.data_In(data_In),.write_address(write_address),.read_address(read_address),.we(WE),.Clk(Clk),.data_Out(data_Out));
	assign color_enum = out_byte;

endmodule