set ROOT ../../

#create lib
vlib work
vmap work work

#compile 
vlog $ROOT/src/memory/instruction_memory.v
vlog $ROOT/tb/instruction_memory/tb_instruction_memory.v

#simulate
vsim -voptargs="+acc" work.tb_instruction_memory

add wave *
run -all
wave zoom full
