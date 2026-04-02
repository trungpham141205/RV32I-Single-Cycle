# Tạo thư viện
vlib work
vmap work work

# Compile core
vlog src/core/alu.v
vlog src/core/alu_control.v
vlog src/core/branch_jump.v
vlog src/core/control_unit.v
vlog src/core/immediate_generate.v
vlog src/core/mux.v
vlog src/core/pc_increment.v
vlog src/core/program_counter.v
vlog src/core/register_file.v
vlog src/core/riscv_top.v

# Compile memory
vlog src/memory/instruction_memory.v
vlog src/memory/data_memory.v

# Compile testbench
vlog tb/tb_riscv.v

# Run simulation
vsim -voptargs=+acc work.tb_riscv

# Add waveform
add wave -r *

# Run
run 500ns
