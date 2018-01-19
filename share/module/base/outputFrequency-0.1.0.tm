namespace eval ::namd {}


#----------------------------------------------------------------------
# Set the output saving frequency
# Input is a dictionary with the following keys:
#   dcd
#   restart
#   xst
#   energy
#   pressure
#----------------------------------------------------------------------
proc ::namd::outputFrequency {params} {
    set defaults [dict create \
        dcd      5000 \
        restart  5000 \
        xst      5000 \
        energy   5000 \
        pressure 5000 \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::outputFrequency"
    set p [dict merge $defaults $params]

    dcdfreq             [dict get $p "dcd"]
    restartfreq         [dict get $p "restart"]     
    xstFreq             [dict get $p "xst"]
    outputEnergies      [dict get $p "energy"]
    outputPressure      [dict get $p "pressure"]
}