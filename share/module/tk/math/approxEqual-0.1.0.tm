namespace eval ::_::math {}

# test whether two numbers are approximately equal
# Args:
#   n1 (number): number 1
#   n2 (number): number 2
#   tol (double): tolerance (default: 1e-5)

proc ::_::math::approxEqual {n1 n2 {tol 1e-5}} {
    set diff [expr abs($n1 - $n2)]
    if {$diff < $tol} {
        return true
    } else {
        return false
    }
}
