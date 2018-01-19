namespace eval ::_::io {}

# write string to file with an ending newline
proc ::_::io::write {file_name content} {
    set OUT [open "$file_name" w]
    puts $OUT "$content"
    close $OUT
}
