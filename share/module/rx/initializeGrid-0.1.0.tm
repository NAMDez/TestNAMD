namespace eval ::namd::rx {}
source module/rx/updateGrid-0.1.0.tm

#-----------------------------------------------
# create symbolic links to grid files
#-----------------------------------------------
# Args:
#   rx_specs (dict): rx specifications
# Return:
#   a list of tags for loaded grids
#-----------------------------------------------
proc ::namd::rx::initializeGrid {rx_specs} {
    set thisAddress [::myReplica]
    set thisState [::myReplica]
    set grid_tags_placeholder {}
    ::namd::rx::updateGrid \
        $thisAddress \
        $thisState \
        [::dict get $rx_specs params grid_files] \
        [::dict get $rx_specs params link_files] \
        $grid_tags_placeholder
    set grid_tags [::namd::gridForce \
        [::dict get $rx_specs params grid_params]]
    return $grid_tags
}
