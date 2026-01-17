package require xml

global DEBUG
global xmlFile

# Read file into xmlData
set fh [open $xmlFile r]
set xmlData [read $fh]
close $fh

# assumes DEBUG is 0 or 1
if {$DEBUG} {puts ".xml file found : $xmlFile\n Parsing..."}

set errors 1
set failures 1
set skipped 1

proc startElement {name attList} {
    global DEBUG
    
    global errors
    global failures
    global skipped

    array set attrs $attList

    if {$DEBUG} {puts "startElement \n name: $name \n attList: $attList)"}

    if {$name eq "testsuites"} {
        set errors $attrs(errors)
        set failures $attrs(failures)
        set skipped $attrs(skipped)

        if {$DEBUG } {puts "errors = $errors, failures = $failures, skipped = $skipped"}
    }
}

xml::parser p -elementstartcommand startElement
p parse $xmlData

if {$errors != 0 || $failures != 0 || $skipped != 0} {
    puts "Build FAILLED";
    set exit_code 1
} else {
    puts "Build PASSED";
    set exit_code 0
}

quit -code $exit_code -f
