namespace eval ::namd::rx {}
source module/base/logInfo-0.1.0.tm
source module/base/run-0.1.0.tm
source module/rx/updateGrid-0.1.0.tm
source module/rx/chatDeltaGrid-0.1.0.tm
source module/tk/math/min-0.1.0.tm

#---------------------------------------------
# Get total energy difference
#   before and after the exchange
#   for the two exchanging neighbors
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
proc ::namd::rx::deltaGrid {neighborAddress \
        thisState neighborState rx_params} {
    set thisAddress [::myReplica]
    set thisT  [::lindex [::dict get $rx_params Ts] $thisState]

    set scaling [::lindex \
        [::dict get $rx_params scalings] \
        [::_::math::min $thisState $neighborState] \
    ]

    puts "=== $thisState $neighborState scaling = $scaling"

    set E_before [::namd::logInfo "MISC"]

    set all_grid_files [::dict get $rx_params grid_files]

    # update grids and get the new grid energy 
    # if the exchange does happy
    ::namd::rx::updateGrid \
        [::lindex $all_grid_files $neighborState] \
        [::dict get $rx_params link_files] \
        [::dict get $rx_params grid_tags]
    ::namd::run 0 ;# recompute grid energy

    set E_after [::namd::logInfo "MISC"]

    # Revert grid update
    ::namd::rx::updateGrid \
        [::lindex $all_grid_files $thisState] \
        [::dict get $rx_params link_files] \
        [::dict get $rx_params grid_tags]

    set info [::dict create \
        E_old $E_before \
        E_new $E_after \
        T [expr $scaling * $thisT] \
    ]

    return [::namd::rx::chatDeltaGrid \
        $thisAddress \
        $neighborAddress \
        $info]
}
