#-------------------------------------
# AUTHOR: YUHANG(STEVEN) WANG
# LINCENSE: MIT/X11
# DATE: 2016-11-30
#-------------------------------------
namespace eval ::_::tk::math { namespace export range }
#-------------------------------------
# Return a list of numbers inside a range [a, b)
# It produces the same results as python's range()/
#
# Arguments
#-------------------------------------
# first=0: staring number
# last: last number
# step=1: step size
#-------------------------------------
proc ::_::tk::math::range_aux {first last step} {
    set output {}
    for {set i $first} {$i < $last} {set i [expr $i +$step]} {
        lappend output $i
    }
    return $output
}

proc ::_::tk::math::range {args} {
    if {[llength $args] == 0} {
        return {}
    } elseif {[llength $args] == 1} {
        return [::_::tk::math::range_aux 0 [lindex $args 0] 1]
    } elseif {[llength $args] == 2} {
        lassign $args first last
        return [::_::tk::math::range_aux $first $last 1]
    } else {
        lassign $args first last step
        return [::_::tk::math::range_aux $first $last $step]
    }
}
