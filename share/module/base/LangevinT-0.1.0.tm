namespace eval ::namd {}


#---------------------------------------------------
# Apply Langevin temperature control
# input dictionary keys (default values):
#   T (310) -- temperature
#   couple_H (off) -- whether to include hydrogens to the bath
#   damping (1) -- Langevin damping coefficient
#---------------------------------------------------
proc ::namd::LangevinT {params} {
    set defaults [dict create \
        damping 1 \
        couple_H off \
        T undefined \
    ]
    
    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::LangevinT"
    set p [dict merge $defaults $params]

    
    langevin            on              
    langevinTemp        [dict get $p "T"]
    langevinDamping     [dict get $p "damping"]
    langevinHydrogen    [dict get $p "couple_H"]
}
