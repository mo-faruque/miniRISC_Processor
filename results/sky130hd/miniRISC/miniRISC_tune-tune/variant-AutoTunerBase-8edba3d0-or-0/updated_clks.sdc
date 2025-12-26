###############################################################################
# Created by write_sdc
###############################################################################
current_design miniRISC
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name core_clock -period 4.2781 [get_ports {clk}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[0]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[10]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[11]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[12]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[13]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[14]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[15]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[1]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[2]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[3]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[4]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[5]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[6]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[7]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[8]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {din[9]}]
set_input_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {sys_rst}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[0]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[10]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[11]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[12]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[13]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[14]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[15]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[1]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[2]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[3]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[4]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[5]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[6]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[7]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[8]}]
set_output_delay 1.5408 -clock [get_clocks {core_clock}] -add_delay [get_ports {dout[9]}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
