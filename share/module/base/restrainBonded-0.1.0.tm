namespace eval ::namd {}

#-------------------------------------------------------
# Add additional bonded interactions
# files: a list of files with extra bonded interaction definitions
# ------------------------------------------------------
proc ::namd::restrainBonded {files} {
    extraBonds on
    foreach f $files {
        extraBondsFile $f
    }
}
