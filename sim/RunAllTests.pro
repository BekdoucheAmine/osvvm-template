#----------------------------------------
# Initialize Library
#----------------------------------------
library osvvm_example

#----------------------------------------
# Compile Testbench
#----------------------------------------
analyze ../tb/TestCtrl_e.vhd
analyze ../tb/example_tb.vhd

#----------------------------------------
# List of tests
#----------------------------------------
RunTest ../tb/example_tb_SimpleTest.vhd
RunTest ../tb/example_tb_RandomTest.vhd