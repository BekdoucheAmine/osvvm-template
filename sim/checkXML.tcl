package require xml

global DEBUG
global xmlFile

# Read file into xmlData
set fh [open $xmlFile r]
set xmlData [read $fh]
close $fh

# assumes DEBUG is 0 or 1
if {$DEBUG} {puts "\x1b[33m(DEBUG)\x1b[0m.xml file found : $xmlFile\n Parsing..."}

set errors 1
set failures 1
set skipped 1

proc startElement {name attList} {
    global DEBUG

    global errors
    global failures
    global skipped

    array set attrs $attList

    if {$DEBUG} {puts "\x1b[33m(DEBUG)\x1b[0m startElement \n name: $name\n attList: $attList"}

    if {$name eq "testsuites"} {
        set errors $attrs(errors)
        set failures $attrs(failures)
        set skipped $attrs(skipped)

        if {$DEBUG} {puts "\x1b[33m(DEBUG)\x1b[0m errors = $errors, failures = $failures, skipped = $skipped"}
    }
}

xml::parser p -elementstartcommand startElement
p parse $xmlData

if {$errors != 0 || $failures != 0 || $skipped != 0} {
    puts ".xml File: $xmlFile"
    puts " \x1b[31mBuild: FAILLED\x1b[0m, Errors: $errors, Failures: $failures, Skipped: $skipped";
    set exit_code 1
} else {
    puts ".xml File: $xmlFile"
    puts " \x1b[32mBuild: PASSED\x1b[0m, Errors: $errors, Failures: $failures, Skipped: $skipped";
    set exit_code 0
}

if {$exit_code} {quit -code $exit_code -f}
