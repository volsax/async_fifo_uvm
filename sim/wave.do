onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /async_fifo_TB/rclk
add wave -noupdate /async_fifo_TB/r_en
add wave -noupdate /async_fifo_TB/data_out
add wave -noupdate /async_fifo_TB/wdata
add wave -noupdate /async_fifo_TB/full
add wave -noupdate /async_fifo_TB/empty
add wave -noupdate /async_fifo_TB/data_in
add wave -noupdate /async_fifo_TB/w_en
add wave -noupdate /async_fifo_TB/wclk
add wave -noupdate /async_fifo_TB/wrst_n
add wave -noupdate /async_fifo_TB/rrst_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1597 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {1486 ns} {2252 ns}
