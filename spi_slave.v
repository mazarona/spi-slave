module spi_slave(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_valid, rx_data);
    /* States */
    parameter IDLE = 3'b000;
    parameter CHK_CMD = 3'b001;
    parameter WRITE = 3'b010;
    parameter READ_ADD = 3'b011;
    parameter READ_DATA = 3'b100;
    reg [2:0] cs, ns;

    /* Input Ports */
    input MOSI, SS_n, clk, rst_n, tx_valid;
    input [7:0] tx_data;

    /* Output Ports */
    output MISO;
    output reg rx_valid;
    output [9:0] rx_data;


    /* Wait 10 clock cycles To covert MOSI serial input to rx_data parallel output and rasie the rx_valid flag */
    wire [3:0] wait_cnt;
    assign start_wait_cnt = (cs == WRITE || cs == READ_ADD || cs == READ_DATA)? 1 : 0;
    trigger_up_counter_UB #(.W(4), .UPPER_BOUND(10)) c1(clk, rst_n, start_wait_cnt, wait_cnt);

    /* Let the SPI slave memorize if it has recived the read adress already to
    * determine the next state transition from CHK_CMD */
    reg has_read_addr;
    always@(posedge rx_valid)begin
        if(rx_data[9:8] == 2'b10)
            has_read_addr <= 1;
        else if(rx_data[9:8] == 2'b11)
            has_read_addr <= 0;
    end
    
    /*** FSM ***/
    /* 1. State Memory */
    always@(posedge clk)begin
        if(~rst_n) cs <= IDLE;
        else cs <= ns;
    end

    /* 2. Next State Logic */ 
    always@(cs, SS_n, MOSI)begin
        case(cs)
            IDLE: 
                if(~SS_n) ns = CHK_CMD; 
                else ns = IDLE;
            CHK_CMD:
                if(~SS_n)begin
                    if(~MOSI)
                        ns = WRITE;
                    else
                        if(has_read_addr) ns = READ_DATA;
                        else ns = READ_ADD;
                end
                else
                    ns = IDLE;
            WRITE: 
                if(~SS_n) ns = WRITE;
                else ns = IDLE;
            READ_ADD: 
                if(~SS_n) ns = READ_ADD; 
                else ns = IDLE;
            READ_DATA: 
                if(~SS_n) ns = READ_DATA; 
                else ns = IDLE;
        endcase
    end

    /* 3. Output Logic */
    always@(posedge clk) begin
        // the counter will never start if we are not in a valid state that
        // requires stalling the clock
        if(wait_cnt == 9) rx_valid <= 1;
        else rx_valid <= 0;
    end

    /* serial to parallel shift register to convert MOSI serial input to rx_data parallel output*/
    serial_to_parallel_sr #(10) stp(clk, MOSI, rst_n, rx_data);
    /* Parallel to serial shift register to convert tx_data parllel input to MISO serial ouput*/
    parallel_to_serial_sr #(8)  pts(clk, tx_valid, tx_data, rst_n, MISO);
endmodule
