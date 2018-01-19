namespace eval ::namd {set __NAMD_LOG_INFO__ {}}
source module/tk/convert/list2dict-0.1.0.tm

#-------------------------------
# Either loop up a keyword in the
# the NAMD log info dictionary or
# return the whole dictionary if 
# no keys are given.
#
# Note: this function ::namd::logInfoSetup 
#  must be called before the "run" command
#  to inform NAMD to use this procedure.
#  Otherwise ::namd::logInfo will return empty dict {}.
# 
# Note to developers:
# NAMD doesn't make it easy to get its internal information
# in a functional programming way.
# Using the global variables (bad practice which lead to bugs)
# seems to be unavoidable.
# I tried "upvar" and "uplevel". Neither worked.
# Using global variable is ugly, but I tried my best
# to confine this demon inside the namespace "::namd"
# with proper hiding. The client will not notice 
# its existence. Steven(Yuhang) Wang 07/09/2017
#-------------------------------
proc ::namd::logInfo_aux {namd_keys namd_values} {
    global ::namd::__NAMD_LOG_INFO__
    set ::namd::__NAMD_LOG_INFO__ [::namd::tk::convert::list2dict $namd_keys $namd_values]
}

proc ::namd::logInfoSetUp {} {
    ::callback ::namd::logInfo_aux
}

proc ::namd::logInfo {{key {}}} {
    global ::namd::__NAMD_LOG_INFO__

    if {[llength $key] == 0} {
        return $::namd::__NAMD_LOG_INFO__
    } else {
        if {[dict exists $::namd::__NAMD_LOG_INFO__ $key]} {
            return [dict get $::namd::__NAMD_LOG_INFO__ $key]
        } else {
            return {}
        }
    }
}
