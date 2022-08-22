module prmemtst1(clk, din, dout, rst_n, rx_valid, tx_valid);
	parameter MEM_WIDTH = 8;
	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;
	input clk, rst_n, rx_valid;
	input [9:0] din;
	reg [ADDR_SIZE-1:0] addr_rd, addr_wr;
	output reg [ADDR_SIZE-1:0] dout;
    output reg tx_valid;

	reg [MEM_WIDTH-1:0] mempr [MEM_DEPTH-1:0];

	//Read/Write Operation
	always @(posedge clk) begin 
        tx_valid <= 0;
		if(~rst_n)
			dout <= 'b0;
        else if(rx_valid) begin
            case (din[9:8])
                2'b00: begin addr_wr <= din[7:0]; tx_valid <= 0; end
                2'b01: begin mempr [addr_wr] <= din[7:0]; tx_valid <= 0; end
                2'b10: begin addr_rd <= din[7:0]; tx_valid <= 0; end
                2'b11: begin dout <= mempr[addr_rd]; tx_valid <= 1; end
            endcase
        end
	end
			


endmodule 
