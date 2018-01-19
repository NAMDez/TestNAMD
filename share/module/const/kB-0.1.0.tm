namespace eval ::namd::const {}

# Boltzman constant
proc ::namd::const::kB {} {
    # ref https://en.wikipedia.org/wiki/Boltzmann_constant
    return 0.0019872041 ;# kcal/mol/K
}
