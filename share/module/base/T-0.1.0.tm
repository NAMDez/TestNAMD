namespace eval ::namd {}

#---------------------------------------------------
# Set NAMD temperature
# If T_final exists, also set up simulated heating/annealing
#   T -- temperature or initial temperature
#   isRestart -- "true"/"false"
#   T_final -- final temperature
#   step -- temperature increment/decrement
#   freq -- frequency for reassigning temperature
#---------------------------------------------------
proc ::namd::T {p} {
    if {[string is false [dict get $p isRestart]]} {
        temperature [dict get $p T]
    } else {}

    if {[dict exists $p T_final]} {
        reassignFreq [dict get $p freq]
        reassignIncr [dict get $p step]
        reassignTemp [dict get $p T]
        reassignHold [dict get $p T_final]
    }
}
