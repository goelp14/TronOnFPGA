/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

 module  frameRAM
    (
            input [15:0] data_In,
            input [18:0] write_address, read_address,
            input we, Clk,
            
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((640*240)-1)];

//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/menu_2bytes.txt", mem);
//    end
    
    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    endmodule

module  bikeDownBlueRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((32*32/2)-1)];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_down_blue_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeUpBlueRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [8:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((32*32/2)-1)];
//    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_up_blue_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeLeftBlueRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((32*32/2)-1)];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_left_blue_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeRightBlueRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((32*32/2)-1)];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_right_blue_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeDownRedRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((32*32/2)-1)];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_down_red_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeUpRedRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((32*32/2)-1)];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_up_red_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeLeftRedRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((32*32/2)-1)];
//    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_left_red_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeRightRedRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((32*32/2)-1)];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_right_red_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  trailVertBlueRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((4*4/2))];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/trail_vert_blue_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  trailHorizBlueRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((4*4/2))];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/trail_horiz_blue_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  trailVertRedRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((4*4/2))];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/trail_vert_red_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  trailHorizRedRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((4*4/2))];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/trail_horiz_red_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  trailCornerRAM
    (
            input [15:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [15:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [15:0] mem [0:((4*4/2))];
    
//    initial begin
//        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/trail_corner_2bytes.txt", mem);
//    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule