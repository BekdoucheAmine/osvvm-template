package require xml

set xmlFile [lindex $argv 0]
set DEBUG   [lindex $argv 1]

# Read file into xmlData
set fh [open $xmlFile r]
set xmlData [read $fh]
close $fh

# assumes DEBUG is 0 or 1
if {$DEBUG} {puts "\033[33mDEBUG\033[0m .xml file found : $xmlFile\n Parsing..."}

set errors 1
set failures 1
set skipped 1

proc startElement {name attList} {
    global DEBUG

    global errors
    global failures
    global skipped

    array set attrs $attList

    if {$DEBUG} {puts "\033[33mDEBUG\033[0m startElement \n name: $name \n attList: $attList)"}

    if {$name eq "testsuites"} {
        set errors $attrs(errors)
        set failures $attrs(failures)
        set skipped $attrs(skipped)

        if {$DEBUG} {puts "\033[33mDEBUG\033[0m errors = $errors, failures = $failures, skipped = $skipped"}
    }
}

xml::parser p -elementstartcommand startElement
p parse $xmlData

if {$errors != 0 || $failures != 0 || $skipped != 0} {
    puts ".xml File: $xmlFile"
    puts " \033\[31mBuild: FAILLED\033[0m, Errors: $errors, Failures: $failures, Skipped: $skipped";
    set exit_code 1
} else {
    puts ".xml File: $xmlFile"
    puts " \033[32mBuild: PASSED\033[0m, Errors: $errors, Failures: $failures, Skipped: $skipped";
    set exit_code 0
}

exit $exit_code