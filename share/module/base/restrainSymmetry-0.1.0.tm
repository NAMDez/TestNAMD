namespace eval ::namd {}


#----------------------------------------------------------------------
# Restrain atoms with symmetry restraints
# input is dictionary with the following keys:
#   matrix: file name that contains the symmetry transformation matrices
#   label: symmetry group labeling PDB
#   k: either a number specifying the force constant (will be scaled down
#       by the number of target atoms),
#      or a file name with a per-atom force constant the occupancy column.
#----------------------------------------------------------------------
proc ::namd::restrainSymmetry {params} {
    set defaults [dict create \
        matrix    undefined \
        label     undefined \
        k         undefined \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::restrainSymmetry"
    set p [dict merge $defaults $params]

    symmetryRestraints on
    symmetryMatrixFile [dict get $p matrix]
    symmetryFile       [dict get $p label]

    set k [dict get $p k]
    if {[string is double $k] || [string is integer $k]} {
        symmetryk     $k
    } else {
        symmetrykFile $k
    }
}
