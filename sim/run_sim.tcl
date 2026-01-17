# Set DEBUG to 0
set DEBUG 0

# Build OSVVM 
build build.pro

# Specify xml file location
set xmlFile sim_build/sim_build.xml

# Check Build Status
source checkXML.tcl

# Run All Tests
build RunAllTests.pro

# Specify xml file location
set xmlFile sim_RunAllTests/sim_RunAllTests.xml

# Check Simulation Status
source checkXML.tcl