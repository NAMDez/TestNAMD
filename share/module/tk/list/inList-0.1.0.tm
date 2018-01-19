namespace eval ::namd::tk::list { namespace export inList }

proc ::namd::tk::list::inList {x L} {
    foreach y $L {
        if {$x == $y} {
            return 1
        }
    }
    return 0
}
