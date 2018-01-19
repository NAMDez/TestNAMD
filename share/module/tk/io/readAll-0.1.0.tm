namespace eval ::_::io {}

# read the file and return its content without the last new line
proc ::_::io::readAll {file_name {noLastNewLine true}} {
    set IN [open $file_name r]
    if {$noLastNewLine} {
        set content [::read -nonewline $IN]
    } else {
        set content [::read $IN]
    }
    close $IN
    return $content
}
