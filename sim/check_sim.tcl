# -------------------------------
# Parse OSVVM test log and fail CI if needed
# -------------------------------

# Path to the log file (adjust as needed)
set logFile "$env($GITHUB_WORKSPACE)/sim/sim_RunAllTests/logs/sim_RunAllTests.log"

# Read the entire log
if {![file exists $logFile]} {
    puts "ERROR: Log file $logFile not found"
    quit -code 1 -f
}

set fh [open $logFile r]
set content [read $fh]
close $fh

# Split into lines
set lines [split $content "\n"]

# Search backwards for the line containing "sim_RunAllTests"
set resultLine ""
for {set i [expr {[llength $lines]-1}]} {$i >= 0} {incr i -1} {
    set line [lindex $lines $i]
    if {[string match "*sim_RunAllTests*" $line]} {
        set resultLine $line
        break
    }
}

# Validate we found it
if {$resultLine eq ""} {
    puts "ERROR: sim_RunAllTests result not found in log"
    quit -code 1 -f
}

# Extract overall status (PASSED / FAILED)
if {[regexp {sim_RunAllTests\s+(PASSED|FAILED)} $resultLine -> status]} {
    puts "Test suite status: $status"
} else {
    puts "ERROR: Could not parse test status in line: $resultLine"
    quit -code 1 -f
}

if {$status eq "FAILED"} {
    puts "ERROR: sim_RunAllTests FAILED"
    quit -code 1 -f
} else {
    puts "All tests passed."
    quit -f
}