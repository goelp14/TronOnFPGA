//-------------------------------------------------------------------------
//      Mem2IO.vhd                                                       --
//      Stephen Kempf                                                    --
//                                                                       --
//      Revised 03-15-2006                                               --
//              03-22-2007                                               --
//              07-26-2013                                               --
//              03-04-2014                                               --
//              02-13-2017                                               --
//                                                                       --
//      For use with ECE 385 Experiment 6                                --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  Mem2IO ( 	input logic Clk, Reset,
					input logic CE, UB, LB, OE, WE,
					input logic [2:0] SRAMFRAME,
					input logic [19:0] ADDR,
					input logic [307199:0] Data_from_REG, Data_from_SRAM,
					output logic [307199:0] Data_to_REG, Data_to_SRAM
					);
   
	// Load data from switches when address is xFFFF, and from SRAM otherwise.
	always_comb
    begin 
        Data_to_REG = 307200'd0;
		if (WE && ~OE)
			if (ADDR == 19'h00000 && SRAMFRAME == 3'b000)
				Data_to_REG = Data_from_SRAM;
			else if (ADDR == 19'h4B000 && SRAMFRAME == 3'b001)
				Data_to_REG = Data_from_SRAM;
			else if (ADDR == (19'h4B000 * 2) && SRAMFRAME == 3'b010)
				Data_to_REG = Data_from_SRAM;
    end

    // Pass data from CPU to SRAM
	assign Data_to_SRAM = Data_from_REG;
endmodule
