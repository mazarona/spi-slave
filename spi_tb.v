module spi_tb();
    reg clk, rst_n, SS_n, MOSI;
    wire MISO;
    spi_wrapper dut(clk, rst_n, SS_n, MOSI, MISO);
    reg[9:0] command;
    
    // clock generation
    initial begin
        clk = 0;
        rst_n = 0;
        SS_n = 1;
        $readmemh("mempr.txt", dut.mem.mempr);
        forever
            #1 clk = ~clk;
    end

    integer k = 1;
    always@(posedge clk)begin
        if(k == 1) begin
            $display("=========================================================================");
            k = k + 1;
        end
            
        if(dut.ss.cs == 3'b010 && command[9:8] == 2'b00 && dut.ss.rx_valid) begin
            $display("ALERT!");
            $display("Command type: Write (Address) | rx[7:0] value = %d", dut.ss.rx_data[7:0]);
            $display("=========================================================================");
        end
        if(dut.ss.cs == 3'b010 && command[9:8] == 2'b01 && dut.ss.rx_valid) begin
            $display("ALERT!");
            $display("Command type: Write  (Data)   | rx[7:0] value = %d", dut.ss.rx_data[7:0]);
            $display("=========================================================================");
        end
        if(dut.ss.cs == 3'b011 && dut.ss.rx_valid) begin
            $display("ALERT!");
            $display("Command type: Read (Address)  | rx[7:0] value = %d", dut.ss.rx_data[7:0]);
            $display("=========================================================================");
        end
        if(dut.ss.cs == 3'b100 && dut.ss.rx_valid) begin
            $display("ALERT!");
            $display("Command type: Read   (Data)   | rx[7:0] value = %d (Garbage value)", dut.ss.rx_data[7:0]);
            $display("=========================================================================");
        end
        if(dut.ss.tx_valid)begin
            $display("ALERT!");
            $display("Data is sent from Memory to SPI slave | tx value = %d", dut.ss.tx_data);
            $display("=========================================================================");
        end
    end

    integer i;
    initial begin
        #2; 
        rst_n = 1;
        /*** 1. Master sends WRITE command (Address) ***/
        SS_n = 0;
        #2;
        MOSI = 0;
        #2;
        command = 10'b00_0000_0101;
        for(i = 0; i < 10; i = i + 1) begin
            MOSI = command[9-i];
            #2;
        end
        SS_n = 1;
        #2;

        /*** 2. Master sends WRITE command (Data) ***/
        SS_n = 0;
        #2;
        MOSI = 0;
        #2;
        command = {2'b01, 8'b00100101};
        for(i = 0; i < 10; i = i + 1) begin
            MOSI = command[9-i];
            #2;
        end
        #2;
        SS_n = 1;
        #2;

        /*** 3. Master sends READ command (Address) ***/
        SS_n = 0;
        #2;
        MOSI = 1;
        #2;
        command = 10'b10_0000_0101;
        for(i = 0; i < 10; i = i + 1) begin
            MOSI = command[9-i];
            #2;
        end
        #2;
        SS_n = 1;
        #2;

        /*** 4. Master sends READ command (wait for Data) ***/
        SS_n = 0;
        #2;
        MOSI = 1;
        #2;
        command = 10'b11_0000_0000; 
        for(i = 0; i < 10; i = i + 1) begin
            MOSI = command[9-i];
            #2;
        end
        #16;
        SS_n = 1;
        #10;
        $stop;
    end
endmodule
