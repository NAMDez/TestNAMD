namespace eval ::_::tk::list {}

# replicate an item a certain number of times
# Args:
#   n (int): number of times
#   item (obj): any object

proc ::_::tk::list::replicate_aux {n item accum} {
    if {$n <= 0} {
        return $accum
    } else {
        return [::_::tk::list::replicate_aux \
            [expr $n - 1] \
            $item \
            [::concat $accum [::list $item]]\
        ]
    }
}

proc ::_::tk::list::replicate {n item} {
    return [::_::tk::list::replicate_aux $n $item {}]
}
