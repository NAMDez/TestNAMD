namespace eval ::namd::rx {}
source module/tk/math/approxEqual-0.1.0.tm


# Update temperature
# Args:
#   old_T (float): old temperature
#   new_T (float): new temperature

proc ::namd::rx::updateT {old_T new_T} {
    if {[::_::math::approxEqual $old_T $new_T]} {
        puts "=== (rx::updateT) same temperature ($new_T), no need to update"
    } else {
        puts "== old_T = $old_T"
        puts "== new_T = $new_T"
        ::rescalevels [expr sqrt(double($new_T)/double($old_T))]
        langevinTemp $new_T        
    }
}
