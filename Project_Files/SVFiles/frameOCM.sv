/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

 module  frameRAM
    (
            input [479:0] data_In,
            input [19:0] write_address, read_address,
            input we, Clk,
    
            output logic [479:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [479:0] mem [0:639];

    initial begin
        $readmemh("C:/Users/HP/Documents/Github/ECE-385/FinalProject/tools/ECE385-HelperTools/PNG To Hex/SRAM/sprite_bytes/menu.txt", mem);
    end
    
    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
    endmodule

module  bikeRAM
    (
            input [4:0] data_In,
            input [18:0] write_address, read_address,
            input we, Clk,
    
            output logic [4:0] data_Out
    );
    
    // mem has width of 480 bits and a total of 640 addresses
    logic [32:0] mem [0:639];
    
    always_ff @ (posedge Clk) begin
        if (we)
            mem[write_address] <= data_In;
        data_Out<= mem[read_address];
    end
    
endmodule