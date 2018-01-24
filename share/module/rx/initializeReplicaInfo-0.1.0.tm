namespace eval ::namd::rx {}

#--------------------------------------------------------
# Initialize a dictionary of information of this state
#--------------------------------------------------------
proc ::namd::rx::initializeReplicaInfo {} {
    set here   [::myReplica]
    set lower  [expr $here - 1]
    set higher [expr $here + 1]

    if {[expr $here + 1] < [::numReplicas]} {
        set right $higher
    } else {
        set right $here
    }

    if {$here > 0} {
        set left $lower
    } else {
        set left $here
    }

    return [dict create \
        state $here \
        address $here \
        L [dict create \
            state $left \
            address $left \
          ] \
        R [dict create \
            state  $right \
            address $right \
          ] \
        step 0 \
        attempt 0 \
        exchange 0 \
    ]
    # note: "exchange": number of successful exchanges
    #   "attempt": which replica exchange attempt
}
