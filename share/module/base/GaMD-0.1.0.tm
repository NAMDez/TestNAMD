namespace eval ::namd {}


#-------------------------------------------------------
# Gaussian accelerated MD
# Args:
# type (lower): set E to user lower (default) or upper bound
#
# start: first time step where aMD starts
#
# stop (0): last time step where aMD should stop
#       The default is "0", meaning aMD will be applied forever.
# log: the output frequency of aMD boost potentials
#
# dihedral (off): if "on", turn on dihedral boost and turn off total boost
#       if "off", turn on total boost and turn off dihedral boost
#
# dual (off): if "on", then both dihedral and total boost are applied.
#
# sample
#   total (1000000): total number of steps for sampling energies
#   ignore (0): total number of steps to be ignored from sampling
#
# boost
#   total (1000000): total number of steps for adding boost potentials
#   static (200000): total number of steps for adding boost potentials with
#           static E and k0 based on sampling
#
# std
#   total (6.0): upper bound for standard deviations of total boost potentials
#   dihedral (6.0): upper bound for standard deviations of dihedral boost potentials
#
# restart_file: GaMD restart file name
#
#
# References: http://gamd.ucsd.edu/manual_namd.html
# ------------------------------------------------------
proc ::namd::GaMD {params} {
    set defaults [dict create \
        type    "lower"   \
        dihedral off \
        dual     off \
        start    undefined \
        stop     0\
        log      undefined \
        sample  [dict create \
                    total 1000000 \
                    ignore 0 \
                ] \
        boost   [dict create \
                    total 1000000 \
                    static 200000 \
                ] \
        std     [dict create \
                    total 6.0 \
                    dihedral  6.0 \
                ] \
        restart_file undefined \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::GaMD"
    set p [dict merge $defaults $params]
    
    accelMDG on
    if {[dict get $p type] eq "lower"} {
        accelMDGiE 1
    } else {
        accelMDGiE 2
    }
    accelMDGcMDPrepSteps  [dict get $p sample ignore]
    accelMDGcMDSteps      [dict get $p sample total]
    accelMDGEquiPrepSteps [dict get $p boost static]
    accelMDGEquiSteps     [dict get $p boost total]

    if {[string is false [dict get $p dihedral]] || \
        [string is true [dict get $p dual]] } {
        accelMDGSigma0P   [dict get $p std total]
    }

    if {[string is true [dict get $p dihedral]] || \
        [string is true [dict get $p dual]] } {
        accelMDGSigma0D   [dict get $p std dihedral]
    }

    if {[dict get $p restart_file] ne "undefined"} {
        accelMDGRestart on
        accelMDGRestartFile [dict get $p restart_file]
    } else {
        accelMDGRestart off
    }

    accelMD          on
    accelMDdihe      [dict get $p dihedral]
    accelMDdual      [dict get $p dual]
    accelMDFirstStep [dict get $p start]
    accelMDLastStep  [dict get $p stop]
    accelMDOutFreq   [dict get $p log]
}
