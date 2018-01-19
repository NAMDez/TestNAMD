namespace eval ::namd {}


#------------------------------------------------------------
# Collective variables
# parameters:
# vector - electrostatic field vector, e.g., {0 0 -2.31}
# normalized - "yes" | "no"
#------------------------------------------------------------
proc ::namd::elecField {params} {
    set defaults [dict create \
       vector undefined \
       normalized undefined \
    ]
    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::elecField"
    set p [dict merge $defaults $params]

    eFieldOn              yes
    eField                [dict get $p vector]
    eFieldNormalized      [dict get $p normalized]
}
