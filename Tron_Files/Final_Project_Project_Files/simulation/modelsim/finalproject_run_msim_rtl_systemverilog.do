transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/HP/Documents/Github/ECE-385/FinalProject/Final_Project_Project_Files/SVFiles {C:/Users/HP/Documents/Github/ECE-385/FinalProject/Final_Project_Project_Files/SVFiles/score.sv}
vlib finalproject_soc
vmap finalproject_soc finalproject_soc

vlog -sv -work work +incdir+C:/Users/HP/Documents/Github/ECE-385/FinalProject/Final_Project_Project_Files/SVFiles {C:/Users/HP/Documents/Github/ECE-385/FinalProject/Final_Project_Project_Files/SVFiles/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L finalproject_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 3000 ns
