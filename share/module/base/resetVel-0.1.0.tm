namespace eval ::namd {}

#--------------------------------
# Reset velocities
# Args.
# T: temperature
#--------------------------------
proc ::namd::resetVel {T} {
    ::reinitvels $T
}