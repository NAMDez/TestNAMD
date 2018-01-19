namespace eval ::namd::rx {}

# return a dictionary of available replica-exchange difference
# functions

proc ::namd::rx::deltaFunctionCatalog {} {
    return [::dict create \
        grid ::namd::rx::deltaGrid \
        T    ::namd::rx::deltaT \
    ]
}