namespace eval ::namd {}


#---------------------------------------------------
# Integrator parameters
# input dictionary keys (default values):
#   time_step (2.0 fs)
#   nonbounded_freq (1 step)
#   elec_freq (2 steps)
#   steps_per_cycle (20 steps)
#   rigid_bonds ("all")
#---------------------------------------------------
proc ::namd::integrator {params} {
    set defaults [dict create \
        time_step        2.0 \
        nonbonded_freq   1 \
        elec_freq        2 \
        steps_per_cycle  20 \
        rigid_bonds      all \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::integrator"
    set p [dict merge $defaults $params]

    rigidBonds          [dict get $p rigid_bonds]
    timestep            [dict get $p time_step]
    nonbondedFreq       [dict get $p nonbonded_freq]
    fullElectFrequency  [dict get $p elec_freq]
    stepspercycle       [dict get $p steps_per_cycle]
}
