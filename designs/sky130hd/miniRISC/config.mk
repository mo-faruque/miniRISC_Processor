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

# =============================================================================
# Multi-Corner PVT Analysis (Optional)
# =============================================================================
# To enable multi-corner analysis, download additional lib files from sky130 PDK:
#   https://github.com/google/skywater-pdk/tree/main/libraries/sky130_fd_sc_hd/latest/timing
#
# Available corners:
#   - tt_025C_1v80 (typical-typical, 25°C, 1.8V) - DEFAULT
#   - ff_n40C_1v95 (fast-fast, -40°C, 1.95V)     - Best case
#   - ss_100C_1v60 (slow-slow, 100°C, 1.6V)      - Worst case
#
# Uncomment and add paths to enable:
# export ADDITIONAL_LIBS = \
#     $(DESIGN_HOME)/$(PLATFORM)/miniRISC/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib \
#     $(DESIGN_HOME)/$(PLATFORM)/miniRISC/lib/sky130_fd_sc_hd__ss_100C_1v60.lib
#
# For STA multi-corner analysis:
# export CORNER_LIST = tt ff ss
# export LIB_FILES_tt = $(PLATFORM_DIR)/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
# export LIB_FILES_ff = $(DESIGN_HOME)/$(PLATFORM)/miniRISC/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib
# export LIB_FILES_ss = $(DESIGN_HOME)/$(PLATFORM)/miniRISC/lib/sky130_fd_sc_hd__ss_100C_1v60.lib
