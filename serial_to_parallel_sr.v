module serial_to_parallel_sr(clk, SI, rst_n, PO);
    parameter W = 8;
    input  clk, SI, rst_n; 
    output reg [W-1:0] PO; 
    always @(posedge clk) begin 
        if(~rst_n)
            PO <= 0;
        else
            PO <= {PO[W-2:0], SI}; 
    end 
endmodule
