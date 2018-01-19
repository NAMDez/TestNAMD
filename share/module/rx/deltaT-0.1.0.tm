namespace eval ::namd::rx {}
source module/base/logInfo-0.1.0.tm
source module/base/run-0.1.0.tm
source module/const/kB-0.1.0.tm

#---------------------------------------------
# Get total energy difference
#   before and after the exchange
#   temperatures
#
# Args:
#   neighborAddress (int): neighbor replica's address
#   thisState(int): this replica's state
#   neighborState (int): neighbor replica's state
#   rx_params (dict): parameters needed for calculating differences
#       between replicas
# Returns:
#   a boolean "true" or "false" for deciding
#   whether to exchange with this neighborAddress
#   
#---------------------------------------------
proc ::namd::rx::deltaT {neighborAddress \
        thisState neighborState rx_params} {
    set thisAddress [::myReplica]
    set Ts      [dict get $rx_params Ts]
    set thisT   [::lindex $Ts $thisState]
    set otherT  [::lindex $Ts $neighborState]
    set thisE   [::namd::logInfo "POTENTIAL"]

    set kB [::namd::const::kB] ;# kcal/mol/K
    #----------------------------------------------
    # If the neighborAddress is on the left, do `send`.
    # If the neighborAddress is on the right, do 'receive'.
    # If the neighborAddress is itself, do nothing.
    #----------------------------------------------
    if {$thisAddress > $neighborAddress} {
        ::replicaSend $thisE $neighborAddress
        return {}
    } elseif {$thisAddress < $neighborAddress} {
        set otherE [::replicaRecv $neighborAddress]
        set dE [expr $thisE - $otherE]
        set inverse_dT [expr (1.0/$thisT) - (1.0/$otherT)] 
        set factor [expr $dE * (1.0/$kB) * $inverse_dT]
        puts "=== dE = $dE"
        puts "=== delta-factor = $factor"
        return [list $factor]
    } else {
        # Because the energy difference between one
        # replica and itself is exactly zero.
        # This is true when one replica is compared
        # to itself because it is the first or the last
        # replica.
        return [list 0]
    }
}
