# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the sources.
vlog -sv ../src/asynchronous_fifo.sv ../src/fifo_mem.sv ../src/rptr_handler.sv ../src/wptr_handler.sv ../src/synchronizer.sv

vlog +cover -sv ../tb/interfaces.sv  ../tb/sequences_write.sv ../tb/sequences_read.sv ../tb/coverage.sv ../tb/scoreboard.sv ../tb/modules.sv ../tb/tests.sv ../tb/tb.sv ../tb/async_fifo_tb.sv 

#coverage -assert -directive -cvg -codeAll

# Simulate the design.
vsim -coverage -c top
run -all
exit