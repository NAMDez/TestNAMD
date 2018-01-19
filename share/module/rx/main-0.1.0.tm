namespace eval ::namd::rx {}
source module/base/logInfo-0.1.0.tm
source module/rx/negotiate-0.1.0.tm
source module/rx/rxSaveState-0.1.0.tm 
source module/rx/rxUpdate-0.1.0.tm 
source module/tk/io/write-0.1.0.tm
source module/tk/io/appendln-0.1.0.tm


#------------------------------------------------
# Main execution logic of `rx`.
#
# Args:
#   replicaInfo (dict): replica info dictionary
#   total_steps (int): total number of steps to run
#   block_steps (int): number steps between exchanges
#   state_file (str): output log file name
#   rx_specs (dict): replica-exchange parameters
#------------------------------------------------
proc ::namd::rx::main { \
    replicaInfo \
    total_steps \
    block_steps \
    state_file\
    rx_specs \
} {   
    set left  [dict get $replicaInfo L]
    set right [dict get $replicaInfo R]
    set root_name [::file rootname $state_file]
    set thisAddress [::myReplica]
    set history_file ${root_name}.${thisAddress}.history

    ::_::io::write $state_file ""
    ::_::io::write $history_file ""

    # Total number of exchange attempts
    set N [expr int($total_steps/$block_steps)]
    
    ::namd::logInfoSetUp
    set ccc 0

    while {$ccc < $N} {
        if {[llength $replicaInfo] == 0} {
            error ">>>> address $thisAddress:: \
                exchange $ccc, replicaInfo = $replicaInfo"
            exit
        }

        set oldState [::dict get $replicaInfo state]
        set oldStep  [::dict get $replicaInfo step]

        # save the current replica info before the new run
        ::namd::rx::saveState ${state_file}.old $replicaInfo

        # Run some MD steps
        ::namd::run $block_steps
        set step [expr $oldStep + $block_steps]

        # attempt exchange
        set replicaInfo [::namd::rx::negotiate \
            $ccc $step $replicaInfo $rx_specs]

        # save new replica info
        ::namd::rx::saveState $state_file $replicaInfo
        set newState [::dict get $replicaInfo state]
        # update reaction coordinate
        if {$newState != $oldState} {
            ::namd::rx::update $oldState $newState $rx_specs
        }

        # save history (for later trajectory sorting)
        ::_::io::appendln $history_file "$step $newState $newState $thisAddress"

        puts ">>> step = $step newState = $newState"

        incr ccc
    }
}
