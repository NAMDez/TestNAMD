#----------------------------------------------------------------
# AUTHOR: YUHANG(STEVEN) WANG
# LINCENSE: MIT/X11
# DATE: 2016-11-22
# UPDATE: 2017-03-18
#----------------------------------------------------------------
namespace eval ::_::math {}
#----------------------------------------------------------------
# Return the smaller of the two input
# If one of them is "end", return the other one
#
# Arguments
#----------------------------------------------------------------
# x: input 1 (a number or "end")
# y: input 2 (a number or "end")
#----------------------------------------------------------------
proc ::_::math::min {x y} {
    if {[string equal $x end]} {
        return $y
    } elseif {[string equal $y end]} {
        return $x
    } elseif {$x <= $y} {
        return $x
    } else {
        return $y
    }
}
