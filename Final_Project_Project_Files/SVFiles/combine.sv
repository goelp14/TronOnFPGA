module combine(
	input Clk, Reset, frame_clk, WE,        // The clock indicating a new frame (~60Hz)
	input [9:0] DrawX, DrawY,
	input [15:0] Data_In,
	input [3:0] Data_In_Bike,
	input [18:0] write_address,
	input [1:0] r_or_b,
   output logic [3:0]  color_enum,
	output logic [7:0] red_color, blue_color 
    );


	logic [15:0] data_In_b, data_In_r;
	logic [19:0] read_address, writeaddress;
	logic [15:0] data_Out;
	logic [7:0] red, blue;
	logic [3:0]  out_byte;
	
	logic bool;
	
//	assign bool = data_Out [3:0] != 4'h08 || data_Out [11:8] != 4'h08 || data_Out [3:0] != 4'h00 || data_Out [11:8] != 4'h00;	
	always_comb begin
		red = 8'b1;
		blue = 8'b1;
		if (Data_In_Bike == 4'hf)
			begin
				read_address = DrawX/2 + DrawY * (640/2);
				if (DrawX % 2 == 0)
					out_byte = data_Out [3:0];
				else
					out_byte = data_Out [11:8];
			end
		else
			begin
				read_address = DrawX/2 + DrawY * (640/2);
				if (r_or_b == 2'b00)
					begin
						if(data_Out [3:0] != 4'h08 || data_Out [11:8] != 4'h08)
							begin
								if(data_Out [3:0] != 4'h06 || data_Out [11:8] != 4'h06)
									blue = 8'b0;
							end
						
					end
				else if (r_or_b == 2'b01)
					begin
						if(data_Out [3:0] != 4'h08 || data_Out [11:8] != 4'h08)
							begin
								if(data_Out [3:0] != 4'h04 || data_Out [11:8] != 4'h04)
									red = 8'b0;
							end
					end
				out_byte = Data_In_Bike;
			end
	end
	
	frameRAM frame_buffer (.data_In(Data_In),.write_address(write_address),.read_address(read_address),.we(WE),.Clk(Clk),.data_Out(data_Out));
	assign color_enum = out_byte;
	assign red_color = red;
	assign blue_color = blue;

endmodule