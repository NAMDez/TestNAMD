namespace eval ::namd::tk::dict {}
source module/tk/math/isEven-0.1.0.tm
source module/tk/list/assertEqual-0.1.0.tm


proc ::namd::tk::dict::assertEqual {d1 d2} {
    if {[llength $d1] != [llength $d2]} {
        return false
    }

    if {[::namd::tk::math::isEven [llength $d1]]} {
        set keys1 [dict keys $d1]
        set keys2 [dict keys $d2]
        if {[llength $keys1] != [llength $keys2]} {
            return false
        } else {
            foreach k $keys1 {
                return [::namd::tk::dict::assertEqual \
                    [dict get $d1 $k] \
                    [dict get $d2 $k] \
                ]
            }
        }
    } else {
        return [::namd::tk::list::assertEqual $d1 $d2]
    }
}
