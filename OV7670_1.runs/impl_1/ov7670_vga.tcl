proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  debug::add_scope template.lib 1
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.cache/wt [current_project]
  set_property parent.project_path H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.xpr [current_project]
  set_property ip_repo_paths h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.cache/ip [current_project]
  set_property ip_output_repo h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.cache/ip [current_project]
  add_files -quiet H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.runs/synth_1/ov7670_vga.dcp
  add_files -quiet H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.runs/clk_wiz_0_synth_1/clk_wiz_0.dcp
  set_property netlist_only true [get_files H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.runs/clk_wiz_0_synth_1/clk_wiz_0.dcp]
  add_files -quiet H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.runs/DIV_32_32_synth_1/DIV_32_32.dcp
  set_property netlist_only true [get_files H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.runs/DIV_32_32_synth_1/DIV_32_32.dcp]
  add_files -quiet H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.runs/blk_mem_gen_0_synth_1/blk_mem_gen_0.dcp
  set_property netlist_only true [get_files H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.runs/blk_mem_gen_0_synth_1/blk_mem_gen_0.dcp]
  read_xdc -mode out_of_context -ref clk_wiz_0 -cells inst h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0_ooc.xdc
  set_property processing_order EARLY [get_files h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clk_wiz_0 -cells inst h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0_board.xdc
  set_property processing_order EARLY [get_files h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0_board.xdc]
  read_xdc -ref clk_wiz_0 -cells inst h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0.xdc
  set_property processing_order EARLY [get_files h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0.xdc]
  read_xdc -mode out_of_context -ref DIV_32_32 -cells U0 h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/DIV_32_32_2/DIV_32_32_ooc.xdc
  set_property processing_order EARLY [get_files h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/DIV_32_32_2/DIV_32_32_ooc.xdc]
  read_xdc -mode out_of_context -ref blk_mem_gen_0 -cells U0 h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/blk_mem_gen_0_1/blk_mem_gen_0_ooc.xdc
  set_property processing_order EARLY [get_files h:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/sources_1/ip/blk_mem_gen_0_1/blk_mem_gen_0_ooc.xdc]
  read_xdc H:/Desktop/OV7670_XY_GREEN_YELLOW_1/OV7670_XY_ok1/OV7670_1/OV7670_1.srcs/constrs_1/new/ov7670_1.xdc
  link_design -top ov7670_vga -part xc7a35tcpg236-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force ov7670_vga_opt.dcp
  catch {report_drc -file ov7670_vga_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file ov7670_vga.hwdef}
  place_design 
  write_checkpoint -force ov7670_vga_placed.dcp
  catch { report_io -file ov7670_vga_io_placed.rpt }
  catch { report_utilization -file ov7670_vga_utilization_placed.rpt -pb ov7670_vga_utilization_placed.pb }
  catch { report_control_sets -verbose -file ov7670_vga_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force ov7670_vga_routed.dcp
  catch { report_drc -file ov7670_vga_drc_routed.rpt -pb ov7670_vga_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file ov7670_vga_timing_summary_routed.rpt -rpx ov7670_vga_timing_summary_routed.rpx }
  catch { report_power -file ov7670_vga_power_routed.rpt -pb ov7670_vga_power_summary_routed.pb }
  catch { report_route_status -file ov7670_vga_route_status.rpt -pb ov7670_vga_route_status.pb }
  catch { report_clock_utilization -file ov7670_vga_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force ov7670_vga.bit 
  catch { write_sysdef -hwdef ov7670_vga.hwdef -bitfile ov7670_vga.bit -meminfo ov7670_vga.mmi -ltxfile debug_nets.ltx -file ov7670_vga.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

