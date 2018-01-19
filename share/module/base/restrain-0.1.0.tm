namespace eval ::namd {}


#----------------------------------------------------------------------
# Restrain atoms with harmonic restraints
# input is dictionary with the following keys:
#   ref - a pdb file with reference positions
#   label - a pdb file with selected atoms labeled
#   column - which column contains the labels (0 values means no restraint)
#   scaling - scaling of the restraining forces
#   exponent - exponent for constraints
#   x (on) - restraints along x
#   y (on) - restraints along y
#   z (on) - restraints along z
#----------------------------------------------------------------------
proc ::namd::restrain {params} {
    set defaults [dict create \
        ref    "undefined" \
        label  "undefined" \
        column "undefined" \
        scaling 1.0 \
        exponent  2 \
        x on \
        y on \
        z on \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::restrain"
    set p [dict merge $defaults $params]

    constraints       on
    consexp           [dict get $p exponent]
    consref           [dict get $p ref]
    conskfile         [dict get $p label]
    conskcol          [dict get $p column]
    constraintScaling [dict get $p scaling]
    selectConstraints on
    selectConstrX     [dict get $p x]
    selectConstrY     [dict get $p y]
    selectConstrZ     [dict get $p z]
}
