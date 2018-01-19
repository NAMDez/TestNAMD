namespace eval ::namd {}


#------------------------------------------------------------
# Force field parameters
# Args:
#   ff_list - a list of force field file names
#------------------------------------------------------------
proc ::namd::forceField {ff_type ff_list} {
    if {$ff_type eq "charmm"} {
        paraTypeCharmm on
    } else {
        error "Error hint: unknown parameter type \"$ff_type\""
    }
    foreach ff $ff_list {
      parameters $ff
    }
}
