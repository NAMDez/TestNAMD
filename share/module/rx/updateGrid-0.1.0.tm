namespace eval ::namd::rx {}
source module/tk/file/file_link-0.1.0.tm

# Update all local grids for the current replica
# Args:
#   src_files (list[list]): source grid files at the new state
#   link_files (list): names for local links to the real grid files
#   grid_tags (list[str]): a list of tags for the grids
proc ::namd::rx::updateGrid {\
    src_files \
    link_files \
    grid_tags} {

    # $src_files must have same number of items as $link_files
    if {[::llength $src_files] != [::llength $link_files]} {
        error "ERROR HINT: number of grid files ([::llength $src_files] != \
            number of link files ([::llength $link_files])"
        exit
    }
   
    foreach link_file $link_files src_file $src_files  {
        ::_::file::link -symbolic $link_file $src_file
    }

    foreach tag $grid_tags {
        puts "==== update grid: $tag"
        reloadGridforceGrid $tag
    }
}
