namespace eval ::namd::rx {}
source module/tk/dict/nestedDictMerge-0.1.0.tm

#------------------------------------------
# Update replica information
# Args:
#   activeNeighbor (str): either "L" or "R"
#   otherNeighbor (str): complement of $activeNeighbor
#   newAddress (int): new computer address to move to (MPI rank ID)
#   replicaInfo (dict): {replica ... L {replica ... address ...} R {replica ... address ...}}
#------------------------------------------
proc ::namd::rx::updateReplicaInfo {activeNeighbor otherNeighbor newAddress replicaInfo} {
    # note: $activeNeighbor will move here
    #   and $otherNeigbor will move to somewhere (need to send a message to ask)
    set thisAddress  [::myReplica]
    set otherNeighborAddress [dict get $replicaInfo \
        $otherNeighbor address]
    set msg "$newAddress"

    # Whether doing the exchange or not, 
    # we always need to do two things:
    # 1. inform the other (non-exchanging) neighbor about the decision
    # 2. ask the other (non-exchanging) neighbor its updated address
    # note: grammar for sending/receiving information simultaneously
    # ref: http://www.ks.uiuc.edu/Research/namd/2.12/ug/node9.html
    #   replicaSendrecv data dest source
    set otherNeighborNewAddress [::replicaSendrecv $msg \
        $otherNeighborAddress \
        $otherNeighborAddress]

    puts ">>> address $thisAddress: updating replicaInfo"
    if {$newAddress == $thisAddress} {
        return [::_::dict::merge \
            $replicaInfo \
            [::dict create \
                $otherNeighbor [::dict create \
                    address $otherNeighborNewAddress \
                ] \
            ] \
        ]
    } else {
        # Because we know the activeNeighbor will be moving to
        # this address after the exchange.
        set activeNeighborNewAddress $thisAddress

        set newAddressBook [::dict create \
            address $newAddress \
            $activeNeighbor [::dict create \
                address $activeNeighborNewAddress \
            ] \
            $otherNeighbor [::dict create \
                address $otherNeighborNewAddress \
            ] \
        ]
        set updatedReplicaInfo [::_::dict::merge \
            $replicaInfo \
            $newAddressBook]

        # Pack everything and relocate to a new address!
        return [::replicaSendrecv $updatedReplicaInfo \
            $newAddress $newAddress]
    }
}
