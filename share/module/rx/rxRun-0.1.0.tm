namespace eval ::namd::rx {namespace export run}
source module/rx/initializeReplicaInfo-0.1.0.tm
source module/rx/main-0.1.0.tm
source module/rx/initializeGrid-0.1.0.tm
source module/tk/io/write-0.1.0.tm
source module/tk/io/appendln-0.1.0.tm
source module/tk/dict/assertDictKeyLegal-0.1.0.tm
source module/tk/dict/nestedDictMerge-0.1.0.tm
source module/tk/io/readAll-0.1.0.tm

#----------------------------------------------------
# NAMD Replica Exchange
#
# Args:
# T (default 298): temperature used for Metropolis-Hasting algorithm
# rx (dict):
#   algorithm (default: MH): default is Metropolis-Hasting
#   type (str): which type of replica exchange
#       i.e., T, grid, etc.
#   T (double): temperature of the current system
#       Not needed for temperature replica-exchange
#----------------------------------------------------
proc ::namd::rx::run {params} {
    set defaults [::dict create \
        restart "" \
        steps [dict create \
            total undefined \
            block undefined \
        ] \
        state  undefined \
        rx [::dict create \
            variable undefined \
            algorithm undefined \
            params [dict create \
                T undefined \
            ] \
        ] \
    ]

    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::rx::run"
    set p [::_::dict::merge $defaults $params]
    
    if {[::dict get $p restart] eq ""} {
        set replicaInfo [::namd::rx::initializeReplicaInfo]
    } else {
        set replicaInfo [::_::io::readAll [::dict get $p restart]]
        puts "=== restart replica: $replicaInfo"
    }

    if {[::dict get $p rx variable] eq "grid"} {
        # initialize the grids
        set grid_tags [::namd::rx::initializeGrid [::dict get $p rx]]
        set rx_specs [::_::dict::merge \
            [::dict get $p rx] \
            [::dict create \
                params [::dict create \
                    grid_tags $grid_tags \
                ] \
            ] \
        ]
    } else  {
        set rx_specs [::dict get $p rx]
    }

    ::replicaBarrier
    ::namd::rx::main \
        $replicaInfo \
        [::dict get $p steps total] \
        [::dict get $p steps block] \
        [::dict get $p state] \
        $rx_specs
    ::replicaBarrier
}
