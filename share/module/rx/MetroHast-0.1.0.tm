namespace eval ::namd::rx {}
source module/const/kB-0.1.0.tm

#---------------------------------------
# Metropolis-Hastings algorithms
# Args:
#   p (dict): a dictionary with the required energies and temperatures
#       example: {
#           E1 {
#               old 10
#               new 11
#           }
#           E2 {
#               old 12    
#               new 13
#           }
#           T1 300
#           T2 320
#       }
#---------------------------------------
proc ::namd::rx::MetroHast {p} {
    set k [::namd::const::kB]
    set E1_old [::dict get $p E1 old]
    set E1_new [::dict get $p E1 new]
    set E2_old [::dict get $p E2 old]
    set E2_new [::dict get $p E2 new]
    set T1 [::dict get $p T1]
    set T2 [::dict get $p T2]

    set old1 [expr -$E1_old/($k * $T1)]
    set old2 [expr -$E2_old/($k * $T2)]
    set new1 [expr -$E1_new/($k * $T2)]
    set new2 [expr -$E2_new/($k * $T1)]
    set expo [expr ($new1 + $new2) - ($old1 + $old2)]
    set factor [expr exp($expo)]

    puts "=== Metropolis-Hastings exponent = $expo factor = $factor"

    if {$factor >= 1} {
        return true
    } else {
        set coin_flip [expr rand()]
        if {$coin_flip < $factor} {
            return true
        } else {
            return false
        }
    }
}
