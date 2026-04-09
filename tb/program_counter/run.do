set ROOT ../../

# create lib
vlib work
vmap work work

# compile
vlog $ROOT/src/core/program_counter.v
vlog $ROOT/tb/program_counter/tb_program_counter.v

# simulate
vsim -voptargs="+acc" work.tb_program_counter

add wave *
run -all
wave zoom full
