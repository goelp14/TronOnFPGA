/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

 module  frameRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
            
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((640*480)-1)];

    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/menu.txt", mem);
    end
    
    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    endmodule

module  bikeDownBlueRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((32*32)-1)];
    
    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_down_blue.txt", mem);
    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeUpBlueRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((32*32)-1)];
    
    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_up_blue.txt", mem);
    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeLeftBlueRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((32*32)-1)];
    
    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_left_blue.txt", mem);
    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeRightBlueRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((32*32)-1)];
    
    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_right_blue.txt", mem);
    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeDownRedRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((32*32)-1)];
    
    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_down_red.txt", mem);
    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeUpRedRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((32*32)-1)];
    
    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_up_red.txt", mem);
    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeLeftRedRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((32*32)-1)];
    
    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_left_red.txt", mem);
    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule

module  bikeRightRedRAM
    (
            input [7:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [7:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [7:0] mem [0:((32*32)-1)];
    
    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG-To-Hex/SRAM/sprite_bytes/bike_right_red.txt", mem);
    end

    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule