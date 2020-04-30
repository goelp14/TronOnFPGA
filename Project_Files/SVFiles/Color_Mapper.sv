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
module  color_mapper ( input [15:0] color_pallete_enum,            // Whether current pixel belongs to ball 
                    //    input [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
//    logic [7:0] Red, Green, Blue;
//    
//    // Output colors to VGA
//    assign VGA_R = Red;
//    assign VGA_G = Green;
//    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin 
        case (color_pallete_enum)
            16'd0:
            begin
                VGA_R = 8'hff;
                VGA_G = 8'hff;
                VGA_B = 8'hff;
            end
            16'd1:
            begin
                VGA_R = 8'h0e;
                VGA_G = 8'h0e;
                VGA_B = 8'h0e;
            end
            16'd2:
            begin
                VGA_R = 8'h3b;
                VGA_G = 8'h3b;
                VGA_B = 8'h3b;
            end
            16'd3:
            begin
                VGA_R = 8'h21;
                VGA_G = 8'h95;
                VGA_B = 8'hf3;
            end
            16'd4:
            begin
                VGA_R = 8'h00;
                VGA_G = 8'hbb;
                VGA_B = 8'hd4;
            end
            16'd5:
            begin
                VGA_R = 8'hcf;
                VGA_G = 8'h10;
                VGA_B = 8'h10;
            end
            16'd6:
            begin
                VGA_R = 8'hff;
                VGA_G = 8'h52;
                VGA_B = 8'h52;
            end
            16'd7:
            begin
                VGA_R = 8'h24;
                VGA_G = 8'h24;
                VGA_B = 8'h24;
            end
            16'd8:
            begin
                VGA_R = 8'hAA;
                VGA_G = 8'hAA;
                VGA_B = 8'hAA;
            end
            16'd9:
            begin
                VGA_R = 8'hAA;
                VGA_G = 8'hAA;
                VGA_B = 8'hAA;
            end
            16'd10:
            begin
                VGA_R = 8'hAA;
                VGA_G = 8'hAA;
                VGA_B = 8'hAA;
            end
            16'd11:
            begin
                VGA_R = 8'hAA;
                VGA_G = 8'hAA;
                VGA_B = 8'hAA;
            end
            16'd12:
            begin
                VGA_R = 8'hAA;
                VGA_G = 8'hAA;
                VGA_B = 8'hAA;
            end
            16'd13:
            begin
                VGA_R = 8'h00;
                VGA_G = 8'h71;
                VGA_B = 8'h0e;
            end
            16'd14:
            begin
                VGA_R = 8'h00;
                VGA_G = 8'h00;
                VGA_B = 8'h00;
            end
            16'd15:
            begin
                VGA_R = 8'hf2;
                VGA_G = 8'h00;
                VGA_B = 8'hff;
            end
        endcase
    end 
    
endmodule
