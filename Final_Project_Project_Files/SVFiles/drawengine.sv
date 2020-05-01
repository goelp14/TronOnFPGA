module drawengine(
	input Clk, Reset, frame_clk, WE,        // The clock indicating a new frame (~60Hz)
	input [9:0] DrawX, DrawY,
	input [1:0] Blue_dir, Red_dir,       // Current pixel coordinates
	input [9:0] Blue_X_real, Blue_Y_real, Red_X_real, Red_Y_real,
	input [15:0] Data_In,
	input [18:0] write_address,
    output logic [3:0]  color_enum          // Whether current pixel belongs to ball or background
    );

	parameter [9:0] Bike_Size = 10'd16;        // Ball size
	logic toggleBit, count;
	// logic [15:0] data_In_bub, data_In_blb, data_In_brb, data_In_bdb, data_In_bur, data_In_blr, data_In_brr, data_In_bdr;
	// logic [19:0] write_address_bub, read_address_bub, write_address_blb, read_address_blb, write_address_brb, read_address_brb, write_address_bdb, read_address_bdb, write_address_bur, read_address_bur, write_address_blr, read_address_blr, write_address_brr, read_address_brr, write_address_bdr, read_address_bdr;
    // logic we_bub, we_blb, we_brb, we_bdb, we_bur, we_blr, we_brr, we_bdr;
    // logic [15:0] data_Out_bub, data_Out_blb, data_Out_brb, data_Out_bdb, data_Out_bur, data_Out_blr, data_Out_brr, data_Out_bdr;
	
	logic [15:0] data_In_b, data_In_r;
	logic [19:0] write_address_b, read_address_b, write_address_r, read_address_r, read_address;
	logic [15:0] data_Out_bub, data_Out_blb, data_Out_brb, data_Out_bdb, data_Out_bur, data_Out_blr, data_Out_brr, data_Out_bdr, data_Out;
	logic [7:0]  blue_upper, blue_lower, red_upper, red_lower, out_byte;


    // logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    // logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
	   from logic to int (signed by default) before they are multiplied. */

    int DistX_blue, DistY_blue;
    assign DistX_blue = DrawX - Blue_X_real - Bike_Size;
	assign DistY_blue = DrawY - Blue_Y_real + Bike_Size;
	
	int DistX_red, DistY_red;
    assign DistX_red = DrawX - Red_X_real - Bike_Size;
	assign DistY_red = DrawY - Red_Y_real + Bike_Size;
	

	always_comb begin
		if ( ( DistX_blue <= Bike_Size * 2) && (DistY_blue <= Bike_Size*2) )
			begin
				read_address_b = DistX_blue/2 + DistY_blue * (32/2);
				write_address_b = read_address_b;
				read_address_r = read_address_b;
				write_address_r = read_address_r;
				read_address = write_address_r;
				if (Blue_dir == 2'd0)
					begin
						if (DrawX % 2 == 1)
							out_byte = data_Out_bub [7:0];
						else
							out_byte = data_Out_bub [15:8]; 
					end
				else if (Blue_dir == 2'd1)
					begin
						if (DrawX % 2 == 1)
							out_byte = data_Out_blb [7:0];
						else
							out_byte = data_Out_blb [15:8]; 
					end
				else if (Blue_dir == 2'd2)
					begin
						if (DrawX % 2 == 1)
							out_byte = data_Out_bdb [7:0];
						else
							out_byte = data_Out_bdb [15:8]; 
					end
				else
					begin
						if (DrawX % 2 == 1)
							out_byte = data_Out_bdb [7:0];
						else
							out_byte = data_Out_bdb [15:8]; 
					end
			end
		else if (( DistX_red <= Bike_Size * 2) && (DistY_red <= Bike_Size*2))
			begin
				read_address_r = DistX_red/2 + DistY_red*(32/2);
				write_address_r = read_address_r;
				read_address_b = write_address_r;
				write_address_b = read_address_b;
				read_address = write_address_b;
				if (Red_dir == 2'd0)
					begin
						if (DrawX % 2 == 1)
							out_byte = data_Out_bur [7:0];
						else
							out_byte = data_Out_bur [15:8]; 
					end
				else if (Red_dir == 2'd1)
					begin
						if (DrawX % 2 == 1)
							out_byte = data_Out_blr [7:0];
						else
							out_byte = data_Out_blr [15:8]; 
					end
				else if (Red_dir == 2'd2)
					begin
						if (DrawX % 2 == 1)
							out_byte = data_Out_bdr [7:0];
						else
							out_byte = data_Out_bdr [15:8]; 
					end
				else
					begin
						if (DrawX % 2 == 1)
							out_byte = data_Out_bdr [7:0];
						else
							out_byte = data_Out_bdr [15:8]; 
					end
			end
		else
			begin
				read_address = DrawX/2 + DrawY * (640/2);
				read_address_r = 20'd6; //arbitrary value
				write_address_r = read_address_r;
				read_address_b = write_address_r;
				write_address_b = read_address_b;
				if (DrawX % 2 == 1)
					out_byte = data_Out [7:0];
				else
					out_byte = data_Out [15:8];
			end
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
	end
	
	// always_comb begin
        
			
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    // end
	
	bikeUpBlueRAM bike_up_blue (.data_In(data_In_b),.write_address(write_address_b),.read_address(read_address_b),.we(1'b0),.Clk(Clk),.data_Out(data_Out_bub));
	bikeLeftBlueRAM bike_left_blue (.data_In(data_In_b),.write_address(write_address_b),.read_address(read_address_b),.we(1'b0),.Clk(Clk),.data_Out(data_Out_blb));
	bikeRightBlueRAM bike_right_blue (.data_In(data_In_b),.write_address(write_address_b),.read_address(read_address_b),.we(1'b0),.Clk(Clk),.data_Out(data_Out_brb));
	bikeDownBlueRAM bike_down_blue (.data_In(data_In_b),.write_address(write_address_b),.read_address(read_address_b),.we(1'b0),.Clk(Clk),.data_Out(data_Out_bdb));

	bikeUpRedRAM bike_up_red (.data_In(data_In_r),.write_address(write_address_r),.read_address(read_address_r),.we(1'b0),.Clk(Clk),.data_Out(data_Out_bur));
	bikeLeftRedRAM bike_left_red (.data_In(data_In_r),.write_address(write_address_r),.read_address(read_address_r),.we(1'b0),.Clk(Clk),.data_Out(data_Out_blr));
	bikeRightRedRAM bike_right_red (.data_In(data_In_r),.write_address(write_address_r),.read_address(read_address_r),.we(1'b0),.Clk(Clk),.data_Out(data_Out_brr));
	bikeDownRedRAM bike_down_red (.data_In(data_In_r),.write_address(write_address_r),.read_address(read_address_r),.we(1'b0),.Clk(Clk),.data_Out(data_Out_bdr));

	frameRAM frame_buffer (.data_In(data_In),.write_address(write_address),.read_address(read_address),.we(WE),.Clk(Clk),.data_Out(data_Out));

	assign color_enum = out_byte;
endmodule