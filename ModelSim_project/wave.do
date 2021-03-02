onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Master1 /tb_top_level/dut_inst/Master_1_inst/master_ack
add wave -noupdate -group Master1 /tb_top_level/dut_inst/Master_1_inst/master_rdata
add wave -noupdate -group Master1 /tb_top_level/dut_inst/Master_1_inst/master_req
add wave -noupdate -group Master1 /tb_top_level/dut_inst/Master_1_inst/master_addr
add wave -noupdate -group Master1 /tb_top_level/dut_inst/Master_1_inst/master_cmd
add wave -noupdate -group Master1 /tb_top_level/dut_inst/Master_1_inst/master_wdata
add wave -noupdate -group Master2 /tb_top_level/dut_inst/Master_2_inst/master_ack
add wave -noupdate -group Master2 /tb_top_level/dut_inst/Master_2_inst/master_rdata
add wave -noupdate -group Master2 /tb_top_level/dut_inst/Master_2_inst/master_req
add wave -noupdate -group Master2 /tb_top_level/dut_inst/Master_2_inst/master_addr
add wave -noupdate -group Master2 /tb_top_level/dut_inst/Master_2_inst/master_cmd
add wave -noupdate -group Master2 /tb_top_level/dut_inst/Master_2_inst/master_wdata
add wave -noupdate -group Master3 /tb_top_level/dut_inst/Master_3_inst/master_ack
add wave -noupdate -group Master3 /tb_top_level/dut_inst/Master_3_inst/master_rdata
add wave -noupdate -group Master3 /tb_top_level/dut_inst/Master_3_inst/master_req
add wave -noupdate -group Master3 /tb_top_level/dut_inst/Master_3_inst/master_addr
add wave -noupdate -group Master3 /tb_top_level/dut_inst/Master_3_inst/master_cmd
add wave -noupdate -group Master3 /tb_top_level/dut_inst/Master_3_inst/master_wdata
add wave -noupdate -group Master4 /tb_top_level/dut_inst/Master_4_inst/master_ack
add wave -noupdate -group Master4 /tb_top_level/dut_inst/Master_4_inst/master_rdata
add wave -noupdate -group Master4 /tb_top_level/dut_inst/Master_4_inst/master_req
add wave -noupdate -group Master4 /tb_top_level/dut_inst/Master_4_inst/master_addr
add wave -noupdate -group Master4 /tb_top_level/dut_inst/Master_4_inst/master_cmd
add wave -noupdate -group Master4 /tb_top_level/dut_inst/Master_4_inst/master_wdata
add wave -noupdate -group Slave1 /tb_top_level/dut_inst/Slave_1_inst/slave_req
add wave -noupdate -group Slave1 /tb_top_level/dut_inst/Slave_1_inst/slave_cmd
add wave -noupdate -group Slave1 /tb_top_level/dut_inst/Slave_1_inst/slave_wdata
add wave -noupdate -group Slave1 /tb_top_level/dut_inst/Slave_1_inst/slave_ack
add wave -noupdate -group Slave1 /tb_top_level/dut_inst/Slave_1_inst/slave_rdata
add wave -noupdate -group Slave2 /tb_top_level/dut_inst/Slave_2_inst/slave_req
add wave -noupdate -group Slave2 /tb_top_level/dut_inst/Slave_2_inst/slave_cmd
add wave -noupdate -group Slave2 /tb_top_level/dut_inst/Slave_2_inst/slave_wdata
add wave -noupdate -group Slave2 /tb_top_level/dut_inst/Slave_2_inst/slave_ack
add wave -noupdate -group Slave2 /tb_top_level/dut_inst/Slave_2_inst/slave_rdata
add wave -noupdate -group Slave3 /tb_top_level/dut_inst/Slave_3_inst/slave_req
add wave -noupdate -group Slave3 /tb_top_level/dut_inst/Slave_3_inst/slave_cmd
add wave -noupdate -group Slave3 /tb_top_level/dut_inst/Slave_3_inst/slave_wdata
add wave -noupdate -group Slave3 /tb_top_level/dut_inst/Slave_3_inst/slave_ack
add wave -noupdate -group Slave3 /tb_top_level/dut_inst/Slave_3_inst/slave_rdata
add wave -noupdate -group Slave4 /tb_top_level/dut_inst/Slave_4_inst/slave_req
add wave -noupdate -group Slave4 /tb_top_level/dut_inst/Slave_4_inst/slave_cmd
add wave -noupdate -group Slave4 /tb_top_level/dut_inst/Slave_4_inst/slave_wdata
add wave -noupdate -group Slave4 /tb_top_level/dut_inst/Slave_4_inst/slave_ack
add wave -noupdate -group Slave4 /tb_top_level/dut_inst/Slave_4_inst/slave_rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1 ns}
