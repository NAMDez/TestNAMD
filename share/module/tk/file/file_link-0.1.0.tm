namespace eval ::_::file {}


# create a link to a file
# Args:

proc ::_::file::link {link_type raw_link_file raw_src_file} {
    #----------------------------------------
    # note: If linkName already exists, 
    #   or if target doesn't exist, 
    #   an error will be returned.
    # ---------------------------------------
    # file link [-linktype] linkname <target>
    # ---------------------------------------
    # note: On Unix, symbolic links can be made to relative paths, 
    # and those paths must be relative to the actual linkName's 
    # location (not to the cwd), but on all other platforms where 
    # relative links are not supported, target paths will always be 
    # converted to absolute, normalized form before the link is created 
    # (and therefore relative paths are interpreted as relative to the cwd).
    # source: http://wiki.tcl.tk/3482
    #---------
    # Thus it is important to always use absolute path

    set link_file [::file normalize $raw_link_file]
    set src_file  [::file normalize $raw_src_file]
    
    if {[::file exists $link_file]} {
        # syntax: file delete ?-force? ?--? pathname ?pathname ...?
        # ref: https://wiki.tcl.tk/10058
        # Note: When pathname is a symbolic link, 
        # that symbolic link is removed rather than the file it refers to.
        # This is exactly what I intend to do. So, no problem.
        file delete -- $link_file
        while {[file exists $link_file]} {} ;# wait
    }

    # Create a link to the new grid file
    ::file link $link_type $link_file $src_file
    while {![file exists $link_file]} {} ;# wait
}
