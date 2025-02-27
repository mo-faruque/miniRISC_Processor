# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "dec_exec_inst" -parent ${Page_0}
  ipgui::add_param $IPINST -name "delay_next_inst" -parent ${Page_0}
  ipgui::add_param $IPINST -name "fetch_inst" -parent ${Page_0}
  ipgui::add_param $IPINST -name "idle" -parent ${Page_0}
  ipgui::add_param $IPINST -name "next_inst" -parent ${Page_0}
  ipgui::add_param $IPINST -name "sense_halt" -parent ${Page_0}


}

proc update_PARAM_VALUE.dec_exec_inst { PARAM_VALUE.dec_exec_inst } {
	# Procedure called to update dec_exec_inst when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.dec_exec_inst { PARAM_VALUE.dec_exec_inst } {
	# Procedure called to validate dec_exec_inst
	return true
}

proc update_PARAM_VALUE.delay_next_inst { PARAM_VALUE.delay_next_inst } {
	# Procedure called to update delay_next_inst when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.delay_next_inst { PARAM_VALUE.delay_next_inst } {
	# Procedure called to validate delay_next_inst
	return true
}

proc update_PARAM_VALUE.fetch_inst { PARAM_VALUE.fetch_inst } {
	# Procedure called to update fetch_inst when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.fetch_inst { PARAM_VALUE.fetch_inst } {
	# Procedure called to validate fetch_inst
	return true
}

proc update_PARAM_VALUE.idle { PARAM_VALUE.idle } {
	# Procedure called to update idle when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.idle { PARAM_VALUE.idle } {
	# Procedure called to validate idle
	return true
}

proc update_PARAM_VALUE.next_inst { PARAM_VALUE.next_inst } {
	# Procedure called to update next_inst when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.next_inst { PARAM_VALUE.next_inst } {
	# Procedure called to validate next_inst
	return true
}

proc update_PARAM_VALUE.sense_halt { PARAM_VALUE.sense_halt } {
	# Procedure called to update sense_halt when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.sense_halt { PARAM_VALUE.sense_halt } {
	# Procedure called to validate sense_halt
	return true
}


proc update_MODELPARAM_VALUE.idle { MODELPARAM_VALUE.idle PARAM_VALUE.idle } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.idle}] ${MODELPARAM_VALUE.idle}
}

proc update_MODELPARAM_VALUE.fetch_inst { MODELPARAM_VALUE.fetch_inst PARAM_VALUE.fetch_inst } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.fetch_inst}] ${MODELPARAM_VALUE.fetch_inst}
}

proc update_MODELPARAM_VALUE.dec_exec_inst { MODELPARAM_VALUE.dec_exec_inst PARAM_VALUE.dec_exec_inst } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.dec_exec_inst}] ${MODELPARAM_VALUE.dec_exec_inst}
}

proc update_MODELPARAM_VALUE.next_inst { MODELPARAM_VALUE.next_inst PARAM_VALUE.next_inst } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.next_inst}] ${MODELPARAM_VALUE.next_inst}
}

proc update_MODELPARAM_VALUE.sense_halt { MODELPARAM_VALUE.sense_halt PARAM_VALUE.sense_halt } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.sense_halt}] ${MODELPARAM_VALUE.sense_halt}
}

proc update_MODELPARAM_VALUE.delay_next_inst { MODELPARAM_VALUE.delay_next_inst PARAM_VALUE.delay_next_inst } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.delay_next_inst}] ${MODELPARAM_VALUE.delay_next_inst}
}

