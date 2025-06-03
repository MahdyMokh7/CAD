	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"tb"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"1 us"
#	set run_time			"-all"


#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog +acc -incr -source +define+SIM $hdl_path/adder.v
	vlog +acc -incr -source +define+SIM $hdl_path/controller.v
	vlog +acc -incr -source +define+SIM $hdl_path/datapath.v
	vlog +acc -incr -source +define+SIM $hdl_path/equal.v
	vlog +acc -incr -source +define+SIM $hdl_path/mod4.v
	vlog +acc -incr -source +define+SIM $hdl_path/mult.v
	vlog +acc -incr -source +define+SIM $hdl_path/mux2to1_1bit.v
	vlog +acc -incr -source +define+SIM $hdl_path/mux2to1_3bit.v
	vlog +acc -incr -source +define+SIM $hdl_path/mux2to1_16bit.v
	vlog +acc -incr -source +define+SIM $hdl_path/mux2to1.v
	vlog +acc -incr -source +define+SIM $hdl_path/mux4to1_1bit.v
	vlog +acc -incr -source +define+SIM $hdl_path/mux4to1.v
	vlog +acc -incr -source +define+SIM $hdl_path/register_signals.v
	vlog +acc -incr -source +define+SIM $hdl_path/register.v
	vlog +acc -incr -source +define+SIM $hdl_path/rom.v
	vlog +acc -incr -source +define+SIM $hdl_path/top.v


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
	