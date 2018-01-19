namespace eval ::namd {}

#--------------------------------------
# Reset time step
# Args
# n (default 0): time step
#--------------------------------------
proc ::namd::resetTime {{n 0}} {
    firsttimestep $n
}
