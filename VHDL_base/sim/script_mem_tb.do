vcom -93 -work ./work ../src/risc_package.vhd
vcom -93 -work ./work ../src/instruction_memory.vhd
vcom -93 -work ./work ../src/reg_instruction_IF_ID.vhd

vcom -93 -work ./work ../src/data_memory.vhd

vcom -93 -work ./work ../tb/tb_RISCV.vhd

vsim work.tb_RISCV

add wave *
run 3000 ns

