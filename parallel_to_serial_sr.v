module parallel_to_serial_sr (clk, tx_valid, tx_data, rst_n, SO);
    parameter W = 8;
    input  clk, tx_valid, rst_n;
    input [W-1:0] tx_data; 
    output SO; 

    reg [W-1:0] temp;
    always @(posedge tx_valid) begin 
        temp <= tx_data;
    end

    always @(posedge clk) begin 
        if(~rst_n)
            temp <= 0;
        else
            temp <= {temp[W-2:0], 1'b0};
    end 
    assign SO = temp[W-1];
endmodule
