# Set OSVVM installation directory
set OSVVM_DIR $env(HOME)/osvvm

# Source OSVVM startup
source "$OSVVM_DIR/Scripts/StartUp.tcl"

# Build OSVVM libraries
build $OSVVM_DIR