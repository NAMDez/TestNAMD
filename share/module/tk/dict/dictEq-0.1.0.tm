namespace eval ::_::dict {}

# package require isDict

proc ::_::dict::eq {d1 d2} {
    set keys1 [lsort [::dict keys $d1]]
    set keys2 [lsort [::dict keys $d2]]

    if {[llength $keys1] != [llength $keys2]} {
        return false
    } else {
        foreach k1 $keys1 k2 $keys2 {
            if {$k1 ne $k2} {
                return false
            } else {
                set v1 [::dict get $d1 $k1]
                set v2 [::dict get $d2 $k2]
                if {[::_::dict::isDict $v1] && [::_::dict::isDict $v2]} {
                    if {![::_::dict::eq $v1 $v2]} {
                        return false
                    }
                } elseif {![::_::dict::isDict $v1] && ![::_::dict::isDict $v2]} {
                    if {$v1 ne $v2} {
                        return false
                    }
                } else {
                    return false
                }
             }
        }
    }
    return true
}