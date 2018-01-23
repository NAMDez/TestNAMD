namespace eval ::namd::rx {}
source module/rx/MetroHast-0.1.0.tm
source module/rx/delta-0.1.0.tm


#---------------------------------------------------
# Decide whether to do a swapping
# Args:
#   neighborAddress (int): neighbor replica's address
#   thisState (int): this replica's state
#   neighborState (int): neighbor replica's state
#   rx_specs (dict): specification of replica-exchange
#---------------------------------------------------
proc ::namd::rx::swap? {neighborAddress thisState neighborState rx_specs} {
    # special cases: 
    # (1) single replica
    # (2) boundary replica
    if {[::numReplicas] == 1 || [::myReplica] == $neighborAddress} {
        return false
    }

    set availableAlgo [::dict create \
        MH ::namd::rx::MetroHast \
    ]

    set algorithm [::dict get $rx_specs algorithm]
    
    if {[::dict exists $availableAlgo $algorithm]} {
        set rxAlgorithm [::dict get $availableAlgo $algorithm]
    } else {
        error "(from ::namd::rx::swap?) unknown replica exchange algorithm \"$algorithm\""
    }

    set info [::namd::rx::delta \
        $neighborAddress \
        $thisState \
        $neighborState \
        [::dict get $rx_specs variable] \
        [::dict get $rx_specs params] \
    ]

    if {[llength $info] > 0} {
        set decision [$rxAlgorithm $info]
        # send swapping decision to its neighbor
        ::replicaSend $decision $neighborAddress
        return $decision
    } else {
        # get swapping decision from its neighbor
        return [::replicaRecv $neighborAddress]
    }
}
