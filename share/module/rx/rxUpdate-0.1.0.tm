namespace eval ::namd::rx {}
source module/rx/updateGrid-0.1.0.tm
source module/rx/updateT-0.1.0.tm

# update replica states
# Args:
#   old_state (int): old replica state
#   new_state (int): new replica state
#   rx_specs (dict): replica-exchange parameters
# -------------------------------------------------------
proc ::namd::rx::update {old_state new_state rx_specs} {
    set rx_variable [::dict get $rx_specs variable]
    set Ts [::dict get $rx_specs params Ts]
    set old_T [::lindex $Ts $old_state]
    set new_T [::lindex $Ts $new_state]
    if {$rx_variable eq "grid"} {
        set grid_files [::dict get $rx_specs params grid_files]
        set src_files [::lindex $grid_files $new_state]
        ::namd::rx::updateGrid \
            $src_files \
            [::dict get $rx_specs params link_files] \
            [::dict get $rx_specs params grid_tags]

        # also update temperature
        ::namd::rx::updateT $old_T $new_T

    } elseif {$rx_variable eq "T"} {
        ::namd::rx::updateT $old_T $new_T
    } else {
        puts stderr "ERROR: unsupported rx reaction coordinate: $rx_variable"
        exit
    }
}
