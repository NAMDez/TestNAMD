namespace eval ::namd::tk::convert { namespace export list2dict }

#---------------------------------------
# convert two list of the same length to
# a dictionary
#---------------------------------------
proc ::namd::tk::convert::list2dict {keys values} {
    if {[llength $keys] != [llength $values]} {
        error "(list2dict) ERROR: two input lists must have equal length"
    } else {
        set d {}
        foreach a $keys b $values {
            lappend d $a $b
        }
        return $d
    }
}
