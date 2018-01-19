namespace eval ::namd::tk::list { namespace export assertEqual }

proc ::namd::tk::list::assertEqual {x y} {
    if {[llength $x] != [llength $y]} {
        return false
    } else {
        foreach a $x b $y {
            if {$a ne $b} {
                return false
            }
        }
        return true
    }
}
