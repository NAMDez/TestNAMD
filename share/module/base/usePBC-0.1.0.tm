namespace eval ::namd {}


#------------------------------------------------------------
# Apply periodic boundary conditions
# Input dictionary keys (default values):
#   size - box sizes, e.g. {100. 110. 100.}
#   center - box center e.g. {0. 0. 0.}
#   wrap_water ("on") - wrap water
#   wrap_all ("on") - wrap all contiguous clusters of bounded atoms
#   isRestart ("false") - whether this is a restart
#------------------------------------------------------------
proc ::namd::usePBC {params} {
    set defaults [dict create \
        wrap_water "on" \
        wrap_all   "on" \
        isRestart  "false" \
        size       undefined \
        center     undefined \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::usePBC"
    set p [dict merge $defaults $params]

    if {[dict get $p "isRestart"] == false} {
        lassign [dict get $p "size"] Lx Ly Lz
        cellBasisVector1 $Lx 0. 0.
        cellBasisVector2 0. $Ly 0.
        cellBasisVector3 0. 0. $Lz

        lassign [dict get $p "center"] x0 y0 z0
        cellOrigin $x0 $y0 $z0
    } else {}

    wrapWater [dict get $p "wrap_water"]
    wrapAll   [dict get $p "wrap_all"]
}
