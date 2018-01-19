namespace eval ::namd {}


#---------------------------------------------------
# Read the number of steps needed to run
# total_steps: total number steps needed for the entire simulation
# xsc_file: file name of the last xsc file
proc ::namd::stepsToRun {total_steps xsc_file} {
    return [expr $total_steps - [::namd::lastTimeStep $xsc_file]]
}