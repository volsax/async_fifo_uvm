onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut_read1/rclk
add wave -noupdate /top/dut_write1/wclk
add wave -noupdate /top/dut_read1/rrst_n
add wave -noupdate /top/dut_write1/wrst_n
add wave -noupdate /top/dut_write1/w_en
add wave -noupdate /top/dut_read1/r_en
add wave -noupdate /top/dut_write1/data_in
add wave -noupdate /top/dut_read1/data_out
add wave -noupdate /top/dut_write1/full
add wave -noupdate /top/dut_read1/empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {630900 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5263200 ps}
