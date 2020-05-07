// this module saves where the trails are in the world, and also detects collisions
// In the RAM: 0 = nothing, 1 = B_HORIZ, 2 = B_VERT, 3 = R_HORIZ, 4 = R_VERT, 5 = CORNER

// handles what type of trail to save to the frame buffer


module trails ( input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					
					output logic [15:0] write,
					output logic [19:0] trail_addr,
					output logic we,
					
               input logic [7:0] Blue_X, Blue_Y, Red_X, Red_Y,
					input logic [1:0] Blue_dir, Red_dir,
					input logic [2:0] Game_State
					);
					
					// play area is 448x448
					// 14x14 offset from top left corner
					logic [2:0] write_b, write_b_ff, write_r, write_r_ff;

					logic [1:0] Blue_dir_old, Red_dir_old;
					
					logic [7:0] Blue_X_old, Red_X_old, Blue_Y_old, Red_Y_old;

					// update old values
					always_ff @ (posedge Clk) 
					begin
					if (Game_State == 3'b10)
						begin
						Blue_dir_old <= Blue_dir;
						Red_dir_old  <= Red_dir;
						Blue_X_old   <= Blue_X;
						Red_X_old    <= Red_X;
						Blue_Y_old   <= Blue_Y;
						Red_Y_old    <= Red_Y;
						end
					end
					
					always_ff @ (posedge Clk) 
					begin
					if (Game_State != 3'b10)
						begin
							write_b_ff <= 3'b0;
							write_r_ff <= 3'b0;
						end
					else
						begin
							write_b_ff <= write_b;
							write_r_ff <= write_r;
						end
					
					end
					
					
					always_comb
					begin
						// default
//						collision_blue = 1'b0;
//						collision_blue = 1'b0;
						write_b = write_b_ff;
						write_r = write_r_ff;
						
						// check if new locations
						// blue
						if ((Blue_X_old != Blue_X) && (Blue_Y_old != Blue_Y))
							begin
								// update trails
								// corner
								if (Blue_dir != Blue_dir_old)
									write_b = 3'b101;
								// up or down
								else if ((Blue_dir == 2'b00) || (Blue_dir == 2'b01))
									write_b = 3'b010;
								// left or right
								else if ((Blue_dir == 2'b10) || (Blue_dir == 2'b11))
									write_b = 3'b001;
								else
									write_b = 3'b0;
							end
						else
							write_b = write_b_ff;
						
						// red
						if ((Red_X_old != Red_X) && (Red_Y_old != Red_Y))
						begin
							// update trails
							// corner
							if (Red_dir != Red_dir_old)
								write_r = 3'b101;
							// up or down
							else if ((Red_dir == 2'b00) || (Red_dir == 2'b01))
								write_r = 3'b100;
							// left or right
							else if ((Red_dir == 2'b10) || (Red_dir == 2'b11))
								write_r = 3'b011;
							else
								write_r = 3'b0;
						end
						else
							write_r = write_r_ff;
					end

// for transferring data
logic [19:0] address, nextaddr, ocm_addr, ocm_nextaddr, red_addr, blue_addr;
logic [15:0] temp, next_temp;
// assign address
assign red_addr = (Blue_X+20)*2+320*(Blue_Y+20)*4;
assign blue_addr = (Red_X)*2+320*(Red_Y)*4;

// logic for transferring data
logic [15:0] output_mapped, output_bus, b_h, b_v, r_h, r_v, corner;
// map the different ways of storing
assign output_bus = temp;
assign output_mapped [3:0] = output_bus[3:0];
assign output_mapped [11:8] = output_bus[7:4];
assign write = output_mapped;

assign trail_addr = ocm_addr;
// states
enum logic [2:0] {idle, prep, read_b_s, write_b_s, reset_addr, read_r_s, write_r_s, done} state, nextState;

// update state
always_ff @ (posedge Clk)
begin
	if (Reset || Game_State != 3'b10)
		state <= idle;
	else
		state <= nextState;
end
// update addr and temp
always_ff @ (posedge Clk)
begin
	if (Reset || Game_State != 3'b10)
		begin
		address <= 20'd0;
		ocm_addr <= 20'd0;
		temp <= 16'b0;
		end
	else
		begin
		address <= nextaddr;
		ocm_addr <= ocm_nextaddr;
		temp <= next_temp;
		end
end


// set next state

// keep on reading 16 bits from sram and then writing to OCM until end char
always_comb 
begin
	// set defaults
	nextState = state;
	
	unique case (state)
		idle:
			if (write_b_ff != 3'b0 || write_r_ff != 3'b0)
				nextState = prep;
		prep: nextState = read_b_s;
		read_b_s: nextState = write_b_s;
		write_b_s:
			if (temp > 16'h000F || write_b_ff == 3'b0) // worst case senario: h00FF
				nextState = reset_addr;
			else
				nextState = read_b_s;
		reset_addr:
			nextState = read_r_s;
		read_r_s:
			nextState = write_r_s;
		write_r_s:
			begin
				if (temp > 16'h000F || write_r_ff == 3'b0) // worst case senario: h00FF
					nextState = done;
				else
					nextState = read_r_s;
			end
		done:
			nextState = idle;
		default:
			nextState = idle;
	endcase
end

// set control signals and stuff
always_comb 
begin
	// set defaults
	nextaddr = address;
	next_temp = temp;
	we = 1'b0;
	ocm_nextaddr = 20'b0;
	unique case (state)
		idle:
			begin
			nextaddr = 20'b0;
			ocm_nextaddr = 20'b0;
			end
		prep: 
			begin
			ocm_nextaddr = blue_addr;
			nextaddr = 20'b0;
			end
		read_b_s:
			begin
				unique case (write_b_ff)
					3'b001: next_temp = b_h;
					3'b010: next_temp = b_v;
					3'b101: next_temp = corner;
					default: next_temp = 16'd15;
				endcase
				nextaddr = address + 1'b1;
			end
		write_b_s:
			begin
				we = 1'b1;
				ocm_nextaddr = ocm_addr+20'b1;
			end
		// reset address for red sprite
		reset_addr: 
			begin
			nextaddr = 20'b0;
			ocm_nextaddr = red_addr;
			end
		read_r_s:
			begin
				unique case (write_r_ff)
					3'b011: next_temp = r_h;
					3'b100: next_temp = r_v;
					3'b101: next_temp = corner;
					default: next_temp = 16'd12;
				endcase
			nextaddr = address + 1'b1;				
			end
		write_r_s:
		begin
			we = 1'b1;
			ocm_nextaddr = ocm_addr+20'b1;
		end
		done: nextaddr = 20'b0;
		default: ;
	endcase
end

trailVertBlueRAM trail_v_b (.data_In(16'b0),.write_address(16'b0),.read_address(address),.we(1'b0),.Clk(Clk),.data_Out(b_v));
trailHorizBlueRAM trail_h_b (.data_In(16'b0),.write_address(16'b0),.read_address(address),.we(1'b0),.Clk(Clk),.data_Out(b_h));
trailVertRedRAM trail_v_r (.data_In(16'b0),.write_address(16'b0),.read_address(address),.we(1'b0),.Clk(Clk),.data_Out(r_v));
trailVertBlueRAM trail_h_r (.data_In(16'b0),.write_address(16'b0),.read_address(address),.we(1'b0),.Clk(Clk),.data_Out(r_h));
trailCornerRAM trail_corner (.data_In(16'b0),.write_address(16'b0),.read_address(address),.we(1'b0),.Clk(Clk),.data_Out(corner));

endmodule
