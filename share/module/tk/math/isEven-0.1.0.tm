namespace eval ::namd::tk::math {namespace export isEven}

proc ::namd::tk::math::isEven {n} {
    if {[expr int($n) % 2] == 0} {
        return true
    } else {
        return false
    }
}
