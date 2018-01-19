namespace eval ::namd {}

#-----------------------------------------------------------------
# Run MD steps with gradually decreasing force constant
# Args:
# step: number of steps to run before changing force constant
# number_steps: total number of steps to run
# initial: initial scaling factor to the force constant
# final: final scaling factor to the force constant
#-----------------------------------------------------------------

proc ::namd::kRun {params} {
    set defaults [dict  create \
        number_steps undefined \
        step undefined \
        initial undefined \
        final undefined \
    ]
    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::kRun"
    set p [dict merge $defaults $params]

    set step [dict get $p step]
    set number_steps [dict get $p number_steps]
    set initial [dict get $p initial]
    set final   [dict get $p final]

    if {[expr $number_steps % $step] != 0} {
        puts "============================================================================"
        puts stderr "Error hint(::namd::kRun): number_steps must be a multiple of step"
        puts "============================================================================"
        exit
    }

    set N [expr $number_steps/$step - 1] ;# integer division

    if {$N < 1} {
        puts "============================================================================"
        puts stderr "Error hint(::namd::kRun): \"number_steps\" must be at least twice the \"step\""
        puts "============================================================================"
        exit
    }

    ::run $step
    for {set i 1} {$i <= $N} {incr i} {
        set gamma [expr $initial * (1.0 - $i/double($N))]
        puts "==================================================="
        puts ">>> Change force constant scaling factor to: $gamma"
        puts "==================================================="
        constraintScaling $gamma
        ::run $step
    }
}
