namespace eval ::namd::rx {}

#----------------------------------------------------------------------
# communicate with neighbors to get the 
#  change in the sum of two grid energies
# Args:
# thisAddress (int): this address
# otherAddress (int): neighbor's address
# info (dict): a dictionary about E and T
#   example: {E_old 10 E_new 11 T 300}
#----------------------------------------------------------------------

proc ::namd::rx::chatDeltaGrid {thisAddress otherAddress info} {
    #----------------------------------------------
    # If the otherAddress is on the left, do `send`.
    # If the otherAddress is on the right, do 'receive'.
    # If the otherAddress is itself, return the identity info dictionary
    #----------------------------------------------
    if {$thisAddress > $otherAddress} {
        ::replicaSend $info $otherAddress
        return {}
    } elseif {$thisAddress < $otherAddress} {
        set info2 [::replicaRecv $otherAddress]
        return [::dict create\
            E1 [::dict create \
                old [::dict get $info E_old] \
                new [::dict get $info E_new] \
            ] \
            E2 [::dict create \
                old [::dict get $info2 E_old] \
                new [::dict get $info2 E_new] \
            ] \
            T1 [::dict get $info T] \
            T2 [::dict get $info2 T] \
        ]
    } else {
        # Because the energy difference between one
        # replica and itself is exactly zero.
        # This is true when one replica is compared
        # to itself because it is the first or the last
        # replica.
        return {E1 {old 0 new 0} E2 {old 0 new 0} T1 1 T2 1}
    }
}
