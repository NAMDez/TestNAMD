namespace eval ::namd::rx {}
source module/const/kB-0.1.0.tm

#----------------------------------------------------------------------
# communicate with neighbors to get the 
#  change in the sum of two grid energies
# Args:
# thisAddress (int): this address
# otherAddress (int): neighbor's address
# deltaE_self (float): change in grid energy
#       before and after the exchange
# T (float): temperature
#----------------------------------------------------------------------

proc ::namd::rx::chatDeltaGrid {thisAddress otherAddress deltaE_self T} {
    puts "=== chatDeltaGrid thisAddress = $thisAddress otherAddress = $otherAddress"
    set kB [::namd::const::kB] ;# kcal/mol/K
    #----------------------------------------------
    # If the otherAddress is on the left, do `send`.
    # If the otherAddress is on the right, do 'receive'.
    # If the otherAddress is itself, do nothing.
    #----------------------------------------------
    if {$thisAddress > $otherAddress} {
        ::replicaSend $deltaE_self $otherAddress
        return {}
    } elseif {$thisAddress < $otherAddress} {
        set deltaE_other [::replicaRecv $otherAddress]
        set dE [expr ($deltaE_self + $deltaE_other)]
        puts "=== dE = $dE"
        return [list [expr $dE/($T*$kB)]]
    } else {
        # Because the energy difference between one
        # replica and itself is exactly zero.
        # This is true when one replica is compared
        # to itself because it is the first or the last
        # replica.
        return [list 0]
    }
}