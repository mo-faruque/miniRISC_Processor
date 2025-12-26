export DESIGN_NAME = miniRISC
export PLATFORM    = sky130hd

export VERILOG_FILES = $(DESIGN_HOME)/src/miniRISC/miniRISC_core.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/miniRISC/constraint.sdc

# Design configuration - balanced optimization
export CORE_UTILIZATION = 60
export PLACE_DENSITY    = 0.65

# Synthesis optimization (1=area, 0=speed)
export ABC_AREA = 1

# Power optimization - use smaller buffers where timing allows
export REPAIR_TIE_FANOUT = 1

export TNS_END_PERCENT  = 100
