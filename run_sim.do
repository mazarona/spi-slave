vlib work
vlog spi_tb.v spi_wrapper.v spi_slave.v prjmem.v parallel_to_serial_sr.v serial_to_parallel_sr.v up_counter_UB.v 
vsim -voptargs=+acc work.spi_tb
add wave -position insertpoint  \
sim:/spi_tb/clk \
sim:/spi_tb/rst_n \
sim:/spi_tb/SS_n \
sim:/spi_tb/MOSI \
sim:/spi_tb/MISO \
sim:/spi_tb/dut/ss/rx_valid \
sim:/spi_tb/dut/ss/rx_data \
sim:/spi_tb/dut/ss/tx_valid \
sim:/spi_tb/dut/ss/tx_data \
sim:/spi_tb/dut/mem/mempr
run -all
layout zoomwindow wave
view -dock wave
#quit -sim
