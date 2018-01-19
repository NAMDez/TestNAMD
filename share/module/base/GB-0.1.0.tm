namespace eval ::namd {}


#-------------------------------------------------------
# Generalized Born implicit solvent model
# params: a list of dictionaries with the following keys:
#   sasa (on): whether to calculate hydrophobic energy
#   surface_tension (0.005): surface tension for computing
#       SASA based hydrophobic energy.
#   ion_molar (0.150): molar concentration of implicit ion
#   solvent_dielectric (80.0): solvent dielectric constant
#   born_cutoff (14.0): cutoff for calculating Born radius
# ------------------------------------------------------
proc ::namd::GB {params} {
    set defaults [dict create \
        sasa                  on \
        surface_tension       0.005 \
        ion_molar             0.150 \
        solvent_dielectric    80.0 \
        born_cutoff           14.0 \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::GB"
    set p [dict merge $defaults $params]
    
    gbis on
    sasa              [dict get $p sasa]
    surfaceTension    [dict get $p surface_tension]
    ionConcentration  [dict get $p ion_molar]
    solventDielectric [dict get $p solvent_dielectric]
    alphaCutoff       [dict get $p born_cutoff]
}
