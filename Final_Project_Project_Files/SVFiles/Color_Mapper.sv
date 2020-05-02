//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input [3:0] color_pallete_enum,            // Whether current pixel belongs to ball 
                    //    input [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin 
        case (color_pallete_enum)
		  default: ;
        16'd0:
            begin
                Red = 8'hff; // white, 
                Green = 8'hff;
                Blue = 8'hff;
            end
        16'd1:
            begin
//                Red = 8'hFF; // pink for testing
//                Green = 8'hC0;
//                Blue = 8'hCB;
					 Red = 8'h0e; // dark grey (tyres)
                Green = 8'h0e;
                Blue = 8'h0e;
            end
        16'd2:
            begin
//						Red = 8'hFF; // Orange for testing
//						Green = 8'h45;
//						Blue = 8'h00;
                Red = 8'h3b; // light grey
                Green = 8'h3b;
                Blue = 8'h3b;
            end
        16'd3:
            begin
                Red = 8'h21; // bike blue
                Green = 8'h95;
                Blue = 8'hf3;
            end
        16'd4:
            begin
                Red = 8'h00; // light trail blue
                Green = 8'hbb;
                Blue = 8'hd4;
            end
         16'd5:
            begin
                Red = 8'hcf; // bike red
                Green = 8'h10;
                Blue = 8'h10;
            end
         16'd6:
            begin
                Red = 8'hff; // light trail red
                Green = 8'h52;
                Blue = 8'h52;
            end
         16'd7:
            begin
//                Red = 8'hf8; // yellow for testing
//                Green = 8'hd5;
//                Blue = 8'h68;
					 Red = 8'h24; // lighter grey
                Green = 8'h24;
                Blue = 8'h24;
            end
         16'd8:
            begin
                Red = 8'h16;
                Green = 8'h16;
                Blue = 8'h16;
            end
         16'd9:
            begin
                Red = 8'hAA;
                Green = 8'hAA;
                Blue = 8'hAA;
            end
         16'd10:
            begin
                Red = 8'hAA;
                Green = 8'hAA;
                Blue = 8'hAA;
            end
         16'd11:
            begin
                Red = 8'hAA;
                Green = 8'hAA;
                Blue = 8'hAA;
            end
         16'd12:
            begin
                Red = 8'hAA;
                Green = 8'hAA;
                Blue = 8'hAA;
            end
         16'd13:
            begin
                Red = 8'h00;
                Green = 8'h71;
                Blue = 8'h0e;
            end
         16'd14:
            begin
//                Red = 8'h00; // neon green for testing
//                Green = 8'hff;
//                Blue = 8'h00;                
					 Red = 8'h00; // black
                Green = 8'h00;
                Blue = 8'h00;
            end
         16'd15:
            begin
                Red = 8'hf2; // clear background (pink)
                Green = 8'h00;
                Blue = 8'hff;
            end
        endcase
    end 
    
endmodule
