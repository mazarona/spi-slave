module spi_wrapper(clk, rst_n, SS_n, MOSI, MISO);
    input clk, rst_n, SS_n, MOSI;
    output MISO;

    // internal wires
    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;

    spi_slave ss(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_valid, rx_data);
    prmemtst1 mem(clk, rx_data, tx_data, rst_n, rx_valid, tx_valid);

endmodule
