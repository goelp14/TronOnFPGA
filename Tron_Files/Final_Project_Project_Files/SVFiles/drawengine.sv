module drawengine(
	input Clk, Reset, frame_clk,       // The clock indicating a new frame (~60Hz)
	input [2:0] gamestate,
	input [9:0] DrawX, DrawY,
	input [1:0] Blue_dir, Red_dir,       // Current pixel coordinates
	input [9:0] Blue_X_real, Blue_Y_real, Red_X_real, Red_Y_real,
	input [1:0] score_blue, score_red,
	output[1:0] r_or_b,
	output logic is_blocked, is_blocked2,
    output logic [3:0]  color_enum          // Whether current pixel belongs to ball or background
    );

	parameter [9:0] Bike_Size = 10'd16;        // Ball size
	parameter [9:0] blocking_Size = 10'd32;
	logic toggleBit, count;
	// logic [15:0] data_In_bub, data_In_blb, data_In_brb, data_In_bdb, data_In_bur, data_In_blr, data_In_brr, data_In_bdr;
	// logic [19:0] write_address_bub, read_address_bub, write_address_blb, read_address_blb, write_address_brb, read_address_brb, write_address_bdb, read_address_bdb, write_address_bur, read_address_bur, write_address_blr, read_address_blr, write_address_brr, read_address_brr, write_address_bdr, read_address_bdr;
    // logic we_bub, we_blb, we_brb, we_bdb, we_bur, we_blr, we_brr, we_bdr;
    // logic [15:0] data_Out_bub, data_Out_blb, data_Out_brb, data_Out_bdb, data_Out_bur, data_Out_blr, data_Out_brr, data_Out_bdr;
	
	logic [15:0] data_In_b, data_In_r;
	logic [19:0] write_address_b, read_address_b, write_address_r, read_address_r, read_address;
	logic [15:0] data_Out_bub, data_Out_blb, data_Out_brb, data_Out_bdb, data_Out_bur, data_Out_blr, data_Out_brr, data_Out_bdr, data_Out;
	logic [3:0]  blue_upper, blue_lower, red_upper, red_lower, out_byte;
	logic [1:0] rb;


    // logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    // logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    

    int DistX_blue, DistY_blue;
    assign DistX_blue = DrawX - Blue_X_real - Bike_Size;
	assign DistY_blue = DrawY - Blue_Y_real + Bike_Size;
	
	int DistX_red, DistY_red;
    assign DistX_red = DrawX - Red_X_real - Bike_Size;
	assign DistY_red = DrawY - Red_Y_real + Bike_Size;
	
	int DistX, DistY, Size;
    assign DistX = DrawX - 485;
    assign DistY = DrawY - 125;
    assign Size = blocking_Size;
	 
	int DistX2, DistY2;
	
    assign DistX2 = DrawX - 485;
    assign DistY2 = DrawY - 220;
    always_comb begin
		if(gamestate == 3'b001 || gamestate == 3'b010)
		  begin
			  if (score_blue == 2'b01)
					begin
					  if ( ( DistX*2) <= (blocking_Size*2) &&  ( DistY*2) <= (blocking_Size*2)) 
							is_blocked = 1'b1;
					  else
							is_blocked = 1'b0;
					end
			  else if (score_blue == 2'b10)
					begin
					  if ( ( DistX*2) <= (blocking_Size*4) &&  ( DistY*2) <= (blocking_Size*2)) 
							is_blocked = 1'b1;
					  else
							is_blocked = 1'b0;
					end
			  else if (score_blue == 2'b11)
					begin
					  if ( ( DistX*2) <= (blocking_Size*6) &&  ( DistY*2) <= (blocking_Size*2)) 
							is_blocked = 1'b1;
					  else
							is_blocked = 1'b0;
					end
			  else
					is_blocked = 1'b0;
			end		
		else
			is_blocked = 1'b0;
    end
	 
	always_comb begin
		if(gamestate == 3'b001 || gamestate == 3'b010)
		  begin
			  if (score_red == 2'b01)
					begin
					  if ( ( DistX2*2) <= (blocking_Size*2) &&  ( DistY2*2) <= (blocking_Size*2)) 
							is_blocked2 = 1'b1;
					  else
							is_blocked2 = 1'b0;
					end
			  else if (score_red == 2'b10)
					begin
					  if ( ( DistX2*2) <= (blocking_Size*4) &&  ( DistY2*2) <= (blocking_Size*2)) 
							is_blocked2 = 1'b1;
					  else
							is_blocked2 = 1'b0;
					end
			  else if (score_red == 2'b11)
					begin
					  if ( ( DistX2*2) <= (blocking_Size*6) &&  ( DistY2*2) <= (blocking_Size*2)) 
							is_blocked2 = 1'b1;
					  else
							is_blocked2 = 1'b0;
					end
			  else
					is_blocked2 = 1'b0;
			end		
		else
			is_blocked2 = 1'b0;
    end
	

	always_comb begin
		if(gamestate == 3'b001 || gamestate == 3'b010)
			begin
			if ( ( DistX_blue <= Bike_Size * 2) && (DistY_blue <= Bike_Size*2) )
				begin
					rb = 2'b00;
					read_address_b = DistX_blue/2 + DistY_blue * (32/2);
					write_address_b = read_address_b;
					read_address_r = read_address_b;
					write_address_r = read_address_r;
					read_address = write_address_r;
					if (Blue_dir == 2'd0)
						begin
							if (DistX_blue % 2 == 0)
								out_byte = data_Out_bub [3:0];
							else
								out_byte = data_Out_bub [7:4]; 
						end
					else if (Blue_dir == 2'd2)
						begin
							if (DistX_blue % 2 == 0)
								out_byte = data_Out_blb [3:0];
							else
								out_byte = data_Out_blb [7:4]; 
						end
					else if (Blue_dir == 2'd1)
						begin
							if (DistX_blue % 2 == 0)
								out_byte = data_Out_bdb [3:0];
							else
								out_byte = data_Out_bdb [7:4]; 
						end
					else
						begin
							if (DistX_blue % 2 == 0)
								out_byte = data_Out_brb [3:0];
							else
								out_byte = data_Out_brb [7:4]; 
						end
				end
			else if (( DistX_red <= Bike_Size * 2) && (DistY_red <= Bike_Size*2))
				begin
					read_address_r = DistX_red/2 + DistY_red*(32/2);
					write_address_r = read_address_r;
					read_address_b = write_address_r;
					write_address_b = read_address_b;
					read_address = write_address_b;
					rb = 2'b01;
					if (Red_dir == 2'd0)
						begin
							if (DistX_red % 2 == 0)
								out_byte = data_Out_bur [3:0];
							else
								out_byte = data_Out_bur [7:4]; 
						end
					else if (Red_dir == 2'd2)
						begin
							if (DistX_red % 2 == 0)
								out_byte = data_Out_blr [3:0];
							else
								out_byte = data_Out_blr [7:4]; 
						end
					else if (Red_dir == 2'd1)
						begin
							if (DistX_red % 2 == 0)
								out_byte = data_Out_bdr [3:0];
							else
								out_byte = data_Out_bdr [7:4]; 
						end
					else
						begin
							if (DistX_red % 2 == 0)
								out_byte = data_Out_brr [3:0];
							else
								out_byte = data_Out_brr [7:4]; 
						end
				end
			else
				begin
					read_address_r = 20'd8;
					write_address_r = read_address_r;
					read_address_b = write_address_r;
					write_address_b = read_address_b;
					read_address = write_address_b;
					out_byte = 4'hf;
					rb = 2'b10;
					
				end
			end
		else
			begin
				read_address_r = 20'd8;
				write_address_r = read_address_r;
				read_address_b = write_address_r;
				write_address_b = read_address_b;
				read_address = write_address_b;
				out_byte = 4'hf;
				rb = 2'b10;
			end
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

	assign color_enum = out_byte;
	assign r_or_b = rb;
endmodule