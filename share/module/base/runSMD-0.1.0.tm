namespace eval ::namd {}

#----------------------------------------------------
# NAMD input output parameters
# Input dictionary keys (default values)
#  ref -- a pdb file with occupancy column containing labels
#  k -- force constant
#  k2 -- force constant for force along the perpendicular direction
#  vel -- velocity (Angstrom/time step) 
#  direction -- a vector for pulling force direction
#  frequency -- output value printing frequency
proc ::namd::runSMD {params} {
    SMD on
    SMDFile [dict get $params ref]
    SMDk    [dict get $params k]
    SMDk2   [dict get $params k2]
    SMDVel  [dict get $params vel]
    SMDDir  [dict get $params direction]
    SMDOutputFreq [dict get $params frequency]
}
