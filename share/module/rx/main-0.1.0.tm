namespace eval ::namd::rx {}
source module/base/logInfo-0.1.0.tm
source module/rx/negotiate-0.1.0.tm
source module/rx/rxSaveState-0.1.0.tm 
source module/rx/rxUpdate-0.1.0.tm 
source module/tk/io/write-0.1.0.tm
source module/tk/io/appendln-0.1.0.tm
source module/tk/dict/nestedDictMerge-0.1.0.tm


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
    set exchange_rate_file ${root_name}.${thisAddress}.xrate

    ::_::io::write $state_file ""
    ::_::io::write $history_file ""
    ::_::io::write $exchange_rate_file ""

    # Total number of exchange attempts
    set N [expr int($total_steps/$block_steps)]
    
    ::namd::logInfoSetUp
    
    set attempt [::dict get $replicaInfo attempt]
    while {$attempt < $N} {
        if {[llength $replicaInfo] == 0} {
            error ">>>> address $thisAddress:: \
                exchange $ccc, replicaInfo = $replicaInfo"
            exit
        }

        set old_state [::dict get $replicaInfo state]
        set old_step  [::dict get $replicaInfo step]
        set old_num_exchanges [::dict get $replicaInfo exchange]

        # save the current replica info before the new run
        ::namd::rx::saveState ${state_file}.old $replicaInfo

        # Run some MD steps
        ::namd::run $block_steps

        # attempt exchange
        incr attempt
        set step [expr $old_step + $block_steps]
        set replicaInfo [::namd::rx::negotiate \
            $attempt $step $replicaInfo $rx_specs]
        set new_state [::dict get $replicaInfo state]

        # update reaction coordinate
        if {$new_state != $old_state} {
            ::namd::rx::update $old_state $new_state $rx_specs

            set new_num_exchanges [expr $old_num_exchanges + 1]
            set replicaInfo [::_::dict::merge \
                $replicaInfo \
                [::dict create exchange $new_num_exchanges] \
            ]
        }

        # save new replica info
        ::namd::rx::saveState $state_file $replicaInfo

        # save history (for later trajectory sorting)
        ::_::io::appendln $history_file "$step $new_state $new_state $thisAddress"

        # save exchange rate (progressive)
        set num_attempts  [::dict get $replicaInfo attempt]
        set num_exchanges [::dict get $replicaInfo exchange]
        set exchange_rate [format "%.2f" \
            [expr double($num_exchanges) / double($num_attempts)]]
        ::_::io::appendln $exchange_rate_file \
            "$step $num_attempts $num_exchanges $exchange_rate"
        
        puts ">>> step = $step new_state = $new_state"
    }
}
