namespace eval ::namd::rx {}

# Update temperature
# Args:
#   old_T (float): old temperature
#   new_T (float): new temperature
proc ::namd::rx::updateT {old_T new_T} {
    puts "== old_T = $old_T"
    puts "== new_T = $new_T"
    ::rescalevels [expr sqrt(double($new_T)/double($old_T))]
    langevinTemp $new_T
}
