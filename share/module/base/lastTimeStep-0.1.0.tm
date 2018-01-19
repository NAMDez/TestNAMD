namespace eval ::namd {}


#---------------------------------------------------
# Read the last time step from xsc files
# input:
# xsc_file: file name of the last xsc file
proc ::namd::lastTimeStep {xsc_file} {
    if {[file exists $xsc_file]} {
        set in [open $xsc_file r]
        set last_line [lindex [split [read -nonewline $in] "\n"] end]
        close $in
        return [lindex [split $last_line ] 0]
    } else {
        puts "WARNING ::namd::lastTimeStep xsc file $xsc_file doesn't exist"
        return 0
    }
}