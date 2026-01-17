package require tdom

# Get arguments
set xmlFile [lindex $argv 0]
set DEBUG   [lindex $argv 1]

# Read XML file
set fh [open $xmlFile r]
set xmlData [read $fh]
close $fh

if {$DEBUG} {
    puts "\033\[33mDEBUG\033\[0m .xml file found : $xmlFile\nParsing..."
}

# Parse XML using tdom
set doc  [dom parse $xmlData]
set root [$doc documentElement]  ;# <testsuites>

# Extract attributes
set errors   [$root getAttribute errors 0]
set failures [$root getAttribute failures 0]
set skipped  [$root getAttribute skipped 0]

if {$DEBUG} {
    puts "\033\[33mDEBUG\033\[0m errors=$errors, failures=$failures, skipped=$skipped"
}

# Print results
puts ".xml File: $xmlFile"

if {$errors != 0 || $failures != 0 || $skipped != 0} {
    puts "Build: \033\[31mFAILED\033\[0m, Errors: $errors, Failures: $failures, Skipped: $skipped"
    exit 1
} else {
    puts "Build: \033\[32mPASSED\033\[0m, Errors: $errors, Failures: $failures, Skipped: $skipped"
    exit 0
}
