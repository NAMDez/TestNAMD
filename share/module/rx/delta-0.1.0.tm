namespace eval ::namd::rx {}
source module/rx/deltaGrid-0.1.0.tm
source module/rx/deltaT-0.1.0.tm
source module/rx/deltaFunctionCatalog-0.1.0.tm



#-----------------------------------------------
# Compute the difference before and after
#  the replica-exchange attempt.
# Args:
#   neighborAddress (int): neighbor's replica address
#   thisState (int): this replica's state
#   neighborState   (int): neighbor's state
#   rx_variable (str): rx reaction coordinate 
#   rx_params (dict): additional parameters needed for replica-exchange
#-----------------------------------------------
proc ::namd::rx::delta {\
    neighborAddress \
    thisState \
    neighborState \
    rx_variable \
    rx_params} {
    set available_functions [::namd::rx::deltaFunctionCatalog]

    if {[::dict exists $available_functions $rx_variable]} {
        set f_compute [::dict get $available_functions $rx_variable]
        return [$f_compute \
            $neighborAddress $thisState $neighborState $rx_params]
    } else {
        return {}
    }
}
