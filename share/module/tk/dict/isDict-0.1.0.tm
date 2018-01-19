namespace eval ::_::dict {}


# assert whether the keys from two dictionaries are equal
proc ::_::dict::isDict {x} {
    return [expr [string is list $x] && [expr [expr [llength $x] % 2] == 0] ? true : false]
}
