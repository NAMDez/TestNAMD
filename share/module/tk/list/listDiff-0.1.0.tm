source module/tk/list/inList-0.1.0.tm

namespace eval ::namd::tk::list { namespace export listDiff }

# Return  list of items in L2 but not in L1
proc ::namd::tk::list::listDiff {L1 L2} {
    set diff {}

    foreach k $L2 {
        if {! [::namd::tk::list::inList $k $L1]} {
            lappend diff $k
        }
    }
    
    return $diff
}
