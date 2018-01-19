namespace eval ::_::io {}

# write string to file with an ending newline
proc ::_::io::appendln {file_name content} {
    set OUT [open "$file_name" a]
    puts $OUT "$content"
    close $OUT
}
