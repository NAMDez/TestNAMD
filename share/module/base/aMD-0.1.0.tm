namespace eval ::namd {}


#-------------------------------------------------------
# Accelerated MD
# Args:
# alpha: boost factor. The larger, the less boost.
# E: threshold energy
# alpha_t: alpha for the total potential energy (only available if "dual" is "on")
# E_t: threshold total potential energy (only available if "dual" is "on")
# start: first time step where aMD starts
# stop (0): last time step where aMD should stop
#       The default is "0", meaning aMD will be applied forever.
# log: the output frequency of aMD boost potentials
# dihedral (off): if "on", turn on dihedral boost and turn off total boost
#       if "off", turn on total boost and turn off dihedral boost
# dual (off): if "on", then both dihedral and total boost are applied.
# ------------------------------------------------------
proc ::namd::aMD {params} {
    set defaults [dict create \
        alpha    undefined \
        E        undefined \
        start    undefined \
        stop     0 \
        log      undefined \
        dihedral off \
        dual     off \
        alpha_t  undefined \
        E_t      undefined \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::aMD"
    set p [dict merge $defaults $params]
    
    accelMD on
    accelMDalpha     [dict get $p alpha]
    accelMDE         [dict get $p E]
    accelMDdihe      [dict get $p dihedral]
    accelMDdual      [dict get $p dual]
    accelMDFirstStep [dict get $p start]
    accelMDLastStep  [dict get $p stop]
    accelMDOutFreq   [dict get $p log]
    if {[string is true [dict get $p dual]]} {
        # only available when ::accelMDdual is "on"
        accelMDTalpha   [dict get $p alpha_t]
        accelMDTE       [dict get $p E_t]
    }
}
