	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"Test_Bench"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"1 us"
#	set run_time			"-all"


#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog +acc -incr -source +define+SIM $hdl_path/and.v
	vlog +acc -incr -source +define+SIM $hdl_path/c1.v
	vlog +acc -incr -source +define+SIM $hdl_path/c2.v
	vlog +acc -incr -source +define+SIM $hdl_path/controller.v
	vlog +acc -incr -source +define+SIM $hdl_path/control_block.v
	vlog +acc -incr -source +define+SIM $hdl_path/counter.v
	vlog +acc -incr -source +define+SIM $hdl_path/d_ff.v
	vlog +acc -incr -source +define+SIM $hdl_path/datapath.v
	vlog +acc -incr -source +define+SIM $hdl_path/first_not_and.v
	vlog +acc -incr -source +define+SIM $hdl_path/full_adder.v
	vlog +acc -incr -source +define+SIM $hdl_path/modules.v
	vlog +acc -incr -source +define+SIM $hdl_path/mult.v
	vlog +acc -incr -source +define+SIM $hdl_path/or.v
	vlog +acc -incr -source +define+SIM $hdl_path/s1.v
	vlog +acc -incr -source +define+SIM $hdl_path/s2.v
	vlog +acc -incr -source +define+SIM $hdl_path/shift_ff.v
	vlog +acc -incr -source +define+SIM $hdl_path/shiftreg.v
	vlog +acc -incr -source +define+SIM $hdl_path/t_ff.v
	vlog +acc -incr -source +define+SIM $hdl_path/top_module.v
	vlog +acc -incr -source +define+SIM $hdl_path/xor.v


	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	