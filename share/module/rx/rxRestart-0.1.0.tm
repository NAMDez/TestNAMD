namespace eval ::namd::rx {}
source module/tk/io/readAll-0.1.0.tm
source module/rx/initializeReplicaInfo-0.1.0.tm

# read restarting file (if exists)
# Args:
#   p (dict): replica exchange params
proc ::namd::rx::restart {p} {
    if {[::dict exists $p restart] && \
            [::file exists [::dict get $p restart]]} {
        set restart_file [::dict get $p restart]
        set replicaInfo [::_::io::readAll $restart_file]
        puts "=== restart replica-exchange: $replicaInfo"
    } else {
        puts "=== initialize new replica info"
        set replicaInfo [::namd::rx::initializeReplicaInfo]
    }
    return $replicaInfo
}
