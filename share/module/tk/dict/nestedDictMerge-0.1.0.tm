namespace eval ::_::dict {}

# package require isDict

proc ::_::dict::merge {dict1 dict2} {
    set keys [::lsort -unique [concat [::dict keys $dict1] [::dict keys $dict2]]]
    set output {}
    foreach k $keys {
        if {[::dict exists $dict1 $k] && [::dict exists $dict2 $k]} {
            if {[::_::dict::isDict [::dict get $dict1 $k]] && \
                [::_::dict::isDict [::dict get $dict2 $k]]} {
                lappend output $k [::_::dict::merge \
                    [::dict get $dict1 $k] \
                    [::dict get $dict2 $k] \
                ]
            } else {
                lappend output $k [::dict get $dict2 $k]
            }
        } elseif {[::dict exists $dict1 $k]} {
            lappend output $k [::dict get $dict1 $k]
        } elseif {[::dict exists $dict2 $k]} {
            lappend output $k [::dict get $dict2 $k]
        } else {
            error "This should have been impossible to happen"
        }
    }
    return $output
}
