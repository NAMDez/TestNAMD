namespace eval ::namd {}


#-------------------------------------------------------
# Add Langevin pressure control
# grid_params: a dictionary with the following keys:
#   flexible_cell (undefined) -- whether to decouple pressure control in each dimension
#   constant_area (undefined) -- whether to keep X-Y plane area constant
#   constant_ratio (undefined) -- whether to key X-Y plane ratio constant
#   group ("yes") - whether to use hydrogen-group based pseudo-molecular virial
#                   and kinetic energy. 
#   target (1.01325  bar) - target pressure in bars
#   period (200 fs) - Piston period
#                   Recommend 200 fs piston periold as suggested by 
#                   http://www.ks.uiuc.edu/Research/namd/2.10/ug/node37.html
#                   Larger number means slower fluctuation.
#   decay (100 fs) - piston oscillation decay time
#               Recommend 100 fs piston decay time as suggested by 
#               http://www.ks.uiuc.edu/Research/namd/2.10/ug/node37.html
#               Smaller value means larger random forces and increased coupling to bath
# ------------------------------------------------------
proc ::namd::LangevinP {params} {
    set defaults [dict create \
        group     yes \
        target    1.01325 \
        period    200. \
        decay     100. \
        flexible_cell undefined \
        constant_area undefined \
        constant_ratio undefined \
        T         undefined \
    ]
    
    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::LangevinP"
    set p [dict merge $defaults $params]

    useGroupPressure      [dict get $p "group"] ;# needed for 2fs steps
    useFlexibleCell       [dict get $p "flexible_cell"]
    useConstantArea       [dict get $p "constant_area"]
    useConstantRatio      [dict get $p "constant_ratio"]

    langevinPiston        on
    langevinPistonTemp    [dict get $p "T"]
    langevinPistonTarget  [dict get $p "target"] ;#  bar -> 1 atm
    langevinPistonPeriod  [dict get $p "period"] ;# 
    langevinPistonDecay   [dict get $p "decay"]  ;# 1
}
