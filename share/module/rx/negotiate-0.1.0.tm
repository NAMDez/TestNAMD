namespace eval ::namd::rx {}
source module/tk/math/isEven-0.1.0.tm
source module/tk/dict/nestedDictMerge-0.1.0.tm
source module/rx/swap-0.1.0.tm
source module/rx/updateReplicaInfo-0.1.0.tm

#------------------------------------------------------------------
# Perform replica exchange core tasks: negotiate for relocation
# Key idea: the order of states stay the same throughout the simulation.
#   Only the addresses of these states change from time to time.
# Args:
#   stage (int): which stage of replica-exchange (0-based indexing)
#   step (int): current MD time step
#   replicaInfo (dict): replica info dictionary
#   rx_specs (dict): replica exchange parameters
#       algorithm
#       variable
#------------------------------------------------------------------
proc ::namd::rx::negotiate {stage step replicaInfo rx_specs} {
    #----------------------------------------------------
    # If the exchange stage and the state are both even or both odd,
    #   then use talk to the right neighbor.
    # Otherwise, talk to the left neighbor.
    #----------------------------------------------------
    set thisAddress [::myReplica]
    set currentState [::dict get $replicaInfo state]

    if {[::namd::tk::math::isEven $stage] == \
        [::namd::tk::math::isEven $currentState]} {
        set activeNeighbor R
        set otherNeighbor L
    } else {
        set activeNeighbor L
        set otherNeighbor R
    }

    if {[llength $replicaInfo] == 0} {
            error ">>>> ERROR: replicaInfo became empty for \
                address $thisAddress \
                exchange $ccc \
                replicaInfo = $replicaInfo"
            exit
    }


    set activeNeighborAddress [dict get $replicaInfo \
        $activeNeighbor address]

    set activeNeighborState [::dict get $replicaInfo \
        $activeNeighbor state]

    set doSwap [::namd::rx::swap? \
        $activeNeighborAddress \
        $currentState \
        $activeNeighborState \
        $rx_specs]

    if {$doSwap} {
        set newAddress $activeNeighborAddress
    } else {
        set newAddress $thisAddress
    }

    return [::_::dict::merge \
        [::namd::rx::updateReplicaInfo \
            $activeNeighbor \
            $otherNeighbor \
            $newAddress \
            $replicaInfo] \
        [::dict create step $step] \
    ]
}
