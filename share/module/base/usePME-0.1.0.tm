namespace eval ::namd {}


#---------------------------------------------------
# Apply PME
# Input dictionary keys
#   spacing - PME grid spacing 
#---------------------------------------------------
proc ::namd::usePME {params} {
    set defaults [dict create \
        spacing 1.0 \
    ]
    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::usePME"
    set p [dict merge $defaults $params]
    PME yes
    PMEGridSpacing [dict get $p spacing]
}
