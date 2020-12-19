vcom -93 -work ./work ../src/risc_package.vhd
vcom -93 -work ./work ../src/data_memory.vhd
vcom -93 -work ./work ../tb/tb_data_memory.vhd


vsim work.tb_data_memory

add wave *
run 1000 ns
