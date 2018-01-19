namespace eval ::namd::rx {}

#---------------------------------------
# Metropolis-Hastings algorithms
# Args:
#   delta_factor: deltaE/(kB*T)
#---------------------------------------
proc ::namd::rx::MetroHast {delta_factor} {

    if {$delta_factor < 0} {
        return true
    } else {
        set coin_flip [expr rand()]
        if {[expr exp(-$delta_factor) > $coin_flip]} {
            return true
        } else {
            return false
        }
    }
}
