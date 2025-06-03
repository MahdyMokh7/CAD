	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"TB"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
# 	set run_time			"1 us"
	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Buffer.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/Conv.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/counter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/DataLoader.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/DataProcessing.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/DataStorer.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/dff.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/FIFO.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/ReadAddrGen.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/ReadController.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/ScratchPad.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/WriteController.v
		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/dut/*
	add wave -hex -group -r		{all}				sim:/$TB/*
	add wave -dec sim:/$TB/dut/data_storer/PsumSPAD/mem

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	
