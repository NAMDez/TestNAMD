namespace eval ::namd {}


#----------------------------------------------------
# NAMD input output parameters
# Input dictionary keys (default values)
#   structure (undefined) -- e.g., my.psf
#   coordinates (undefined) -- e.g., my.pdb
#   output_prefix (undefined) -- output file prefix
#   input_prefix (undefined) -- input file prefix
#   first_time_step (0) - (optional) first time step
#       only used when "isRestart" is "true".
#   isRestart (false) - whether this is a restart
#----------------------------------------------------
proc ::namd::IO {params} {
    set defaults [dict create \
        isRestart       false \
        isReplica       false \
        first_time_step undefined \
        structure       undefined \
        coordinates     undefined \
        output_prefix   undefined \
        input_prefix    undefined \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::IO"
    set p [dict merge $defaults $params]

    if {[string is true [dict get $p isReplica]]} {
        set input_prefix  [format [dict get $p input_prefix] [myReplica]]
        set output_prefix [format [dict get $p output_prefix] [myReplica]]
    } else {
        set input_prefix  [dict get $p input_prefix]
        set output_prefix [dict get $p output_prefix]
    }

    outputname      $output_prefix
    structure       [dict get $p structure]
    coordinates     [dict get $p coordinates]
    
    if {[string is true [dict get $p isRestart]]} {
        if {![string equal [dict get $p first_time_step] undefined]} {
            firsttimestep   [dict get $p first_time_step]
        } else {
            firsttimestep   [::namd::lastTimeStep "${input_prefix}.xsc"]
        }
    }
    
    if {[dict get $p "isRestart"] == true} {
        binCoordinates   "${input_prefix}.coor"
        binVelocities    "${input_prefix}.vel"
        extendedSystem   "${input_prefix}.xsc"
    }
}
