namespace eval ::namd::rx {}

# Write replica-exchange log file
proc ::namd::rx::saveState {log_file_name content} {
    set OUT [open $log_file_name w]
    puts $OUT $content
    close $OUT
}
