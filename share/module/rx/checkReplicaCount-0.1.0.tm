namespace eval ::namd::rx {namespace export checkReplicaCount}

proc ::namd::rx::checkReplicaCount {n} {
    if { $n != [numReplicas] } {
        set msg [join \
            [list \
                "\n" \
                "=========================================================" \
                "Error hint: wrong number of replicas in NAMD config file." \
                "  You specified: $n replica(s)" \
                "  Should be:     [numReplicas] replica(s)" \
                "=========================================================" \
            ] \
            "\n" \
        ]
        error $msg
    } else {
        set msg [join \
            [list \
                "\n" \
                "=========================================================" \
                "             [numReplicas] replica(s)" \
                "=========================================================" \
            ] \
            "\n" \
        ]
        puts $msg
        return true
    }
}
