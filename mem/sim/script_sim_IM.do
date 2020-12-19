vcom -93 -work ./work ../src/risc_package.vhd
vcom -93 -work ./work ../src/instruction_memory.vhd
vcom -93 -work ./work ../src/reg_instruction_IF_ID.vhd
vcom -93 -work ./work ../tb/tb_instruction_memory.vhd


vsim work.tb_instruction_memory

add wave *
run 1000 ns
