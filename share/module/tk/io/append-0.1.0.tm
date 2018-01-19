namespace eval ::_::io {}

# write string to file without an ending newline
proc ::_::io::append {file_name content} {
    set OUT [open "$file_name" a]
    puts -nonewline $OUT "$content"
    close $OUT
}
