module combine(
	input Clk, Reset, frame_clk, WE,        // The clock indicating a new frame (~60Hz)
	input [9:0] DrawX, DrawY,
	input [15:0] Data_In,
	input [3:0] Data_In_Bike,
	input [18:0] write_address,
	input [1:0] r_or_b,
	input [9:0] Blue_X_real, Blue_Y_real, Red_X_real, Red_Y_real,
	input [1:0] Blue_dir, Red_dir,
   output logic [3:0]  color_enum,
	output logic [7:0] red_color, blue_color,
	output logic [15:0] dOut
    );


	logic [15:0] data_In_b, data_In_r;
	logic [19:0] read_address, writeaddress;
	logic [15:0] data_Out;
	logic [7:0] red, blue;
	logic [3:0]  out_byte;
	
	logic bool;
	
//	parameter [9:0] Bike_Size = 10'd16;
//	
//	int DistX_blue, DistY_blue;
//   assign DistX_blue = DrawX - Blue_X_real - Bike_Size;
//	assign DistY_blue = DrawY - Blue_Y_real + Bike_Size;
//	
//	int DistX_red, DistY_red;
//   assign DistX_red = DrawX - Red_X_real - Bike_Size;
//	assign DistY_red = DrawY - Red_Y_real + Bike_Size;
//	
//	always_comb
//		begin
//			// for blue
//			if (Blue_dir == 2'b00)
//				begin
//					tempoffsetbluex = 10'd0;
//					tempoffsetbluey = 10'd4;
//				end
//			else if (Blue_dir == 2'b01)
//				begin
//					tempoffsetbluex = 10'd0;
//					tempoffsetbluey = -10'd4;
//				end
//			else if (Blue_dir == 2'b10)
//				begin
//					tempoffsetbluex = 10'd4;
//					tempoffsetbluey = 10'd0;
//				end
//			else
//				begin
//					tempoffsetbluex = -10'd4;
//					tempoffsetbluey = 10'd0;
//				end	
//				
//			if (Red_dir == 2'b00)
//				begin
//					tempoffsetredx = 10'd0;
//					tempoffsetredy = 10'd4;
//				end
//			else if (Red_dir == 2'b01)
//				begin
//					tempoffsetredx = 10'd0;
//					tempoffsetredy = -10'd4;
//				end
//			else if (Red_dir == 2'b10)
//				begin
//					tempoffsetredx = 10'd4;
//					tempoffsetredy = 10'd0;
//				end
//			else
//				begin
//					tempoffsetredx = -10'd4;
//					tempoffsetredy = 10'd0;
//				end	
//		end
		
	
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

//				if (Blue_dir == 2'b00)
//					begin
//						if ( (DistX_blue <= Bike_Size * 2) && (DistY_blue <= Bike_Size - 1) )
//							begin
////								read_address = DrawX/2 + DrawY * (640/2);
//								if (data_Out[3:0] != 4'h08 || data_Out[11:8] != 4'h08)
//									blue = 8'b0;
//							end
//					end
//				else if (Blue_dir == 2'b01)
//					begin
//						if ( (DistX_blue <= Bike_Size * 2) && (DistY_blue >= Bike_Size + 1) )
//							begin
////								read_address = DrawX/2 + DrawY * (640/2);
//								if (data_Out[3:0] != 4'h08 || data_Out[11:8] != 4'h08)
//									blue = 8'b0;
//							end
//					end
//				else if (Blue_dir == 2'b10)
//					begin
//						if ( (DistX_blue <= Bike_Size) && (DistY_blue <= Bike_Size * 2) )
//							begin
////								read_address = DrawX/2 + DrawY * (640/2);
//								if (data_Out[3:0] != 4'h08 || data_Out[11:8] != 4'h08)
//									blue = 8'b0;
//							end
//					end
//				else
//					begin
//						if ( (DistX_blue >= Bike_Size) && (DistY_blue <= Bike_Size * 2) )
//							begin
////								read_address = DrawX/2 + DrawY * (640/2);
//								if (data_Out[3:0] != 4'h08 || data_Out[11:8] != 4'h08)
//									blue = 8'b0;
//							end
//					end
//				if (r_or_b == 2'b00)
//					begin
//						if ((offsetbx == tempoffsetbluex) && (offsetby = tempoffsetbluey))
//							begin
//								if (data_Out[3:0] != 4'h08 || data_Out[11:8] != 4'h08)
//									blue = 8'b1;
//							end
//					end
//				else if (r_or_b == 2'b01)
//					begin
//						if ((offsetrx == tempoffsetredx) && (offsetry = tempoffsetredy))
//							begin
//								if (data_Out[3:0] != 4'h08 || data_Out[11:8] != 4'h08)
//									red = 8'b1;
//							end
//					end
				if (r_or_b == 2'b00)
					begin
//						if(data_Out [3:0] == 4'h08 || data_Out [11:8] == 4'h08)
//							blue = 1'b1;
						if (data_Out [3:0] == 4'h06 || data_Out [11:8] == 4'h06)
							blue = 8'b0;
						else if (data_Out [3:0] == 4'h0e || data_Out [11:8] == 4'h0e)
							blue = 8'b0;
//						else
							
						
					end
				else if (r_or_b == 2'b01)
					begin
//						if(data_Out [3:0] != 4'h08 && data_Out [11:8] != 4'h08)
//							red = 8'b0;
						if(data_Out [3:0] == 4'h04 || data_Out [11:8] == 4'h04)
							red = 8'b0;
						else if (data_Out [3:0] == 4'h0e || data_Out [11:8] == 4'h0e)
							red = 8'b0;
					end
				out_byte = Data_In_Bike;
			end
	end
	
	frameRAM frame_buffer (.data_In(Data_In),.write_address(write_address),.read_address(read_address),.we(WE),.Clk(Clk),.data_Out(data_Out));
	assign color_enum = out_byte;
	assign red_color = red;
	assign blue_color = blue;
	assign dOut = data_Out;

endmodule