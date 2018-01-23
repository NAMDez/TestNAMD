namespace eval ::namd::rx {}
source module/rx/updateGrid-0.1.0.tm

#-----------------------------------------------
# create symbolic links to grid files
#-----------------------------------------------
# Args:
#   all_grid_files (list[list]): a list of all grid files for all resolutions
#   link_files (list[str]): list of local file names
#   grid_params (dict): grid force parameters
# Return:
#   a list of tags for loaded grids
#-----------------------------------------------
proc ::namd::rx::initializeGrid {all_grid_files link_files grid_params} {
    set thisState [::myReplica]
    set src_files [::lindex $all_grid_files $thisState]
    set grid_tags_placeholder {}

    ::namd::rx::updateGrid \
        $src_files \
        $link_files \
        $grid_tags_placeholder

    set grid_tags [::namd::gridForce $grid_params]

    return $grid_tags
}
