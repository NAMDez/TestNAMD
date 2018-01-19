namespace eval ::namd {}


#---------------------------------------------------
# Interaction parameters
# Input dictionary keys (default values):
#   exclude ("scaled1-4") - CHARMM 1-4 bounded interaction exclusion
#   1-4_scaling (1.0) - 1-4 bounded atom interaction scaling
#   cutoff (12.0) - cutoff for all non-bonded interactions
#   switching ("on") - using switching scheme
#   vdw_force_switching("on") - use force based switching to reach
#                        better lipid density when using CHARMM36
#                    (see )
#   switch_dist (10.) - distance where switching starts
#   pair_list_dist (13.5) - cutoff for pair-wise nonbonded interactions
#   lj_correction (no) -  
#      New as of version 2.12: The energy and virial terms 
#      added by LJcorrection on are now also controlled by 
#       the vdW $ \lambda $ schedule. The average Lennard-Jones 
#       $ A$ and $ B$ coefficients are computed separately at both 
#      endpoints and then coupled linearly. In most practical situations 
#     the energy difference is extremely negligible, but this is more 
#    theoretically sound than the old behavior of averaging both endpoints 
#    together. However, the kinetic energy component of the virial does
#    still count the endpoints together, as if annihilated alchemical 
#    atoms were an ideal gas. Again, this is likely quite negligible, 
#    nor is it clear that this should be treated specially. 
#    (http://www.ks.uiuc.edu/Research/namd/cvs/ug/node62.html)
#---------------------------------------------------
proc ::namd::interaction {params} {
    set defaults [dict create \
        exclude       "scaled1-4" \
        1-4_scaling    1.0 \
        switch_dist    10.0 \
        cutoff         12.0 \
        switching      on \
        vdw_force_switching on \
        lj_correction  off \
        pair_list_dist 13.5 \
    ]
    
    ::namd::tk::dict::assertDictKeyLegal $defaults $params "::namd::interaction"
    set p [dict merge $defaults $params]

    exclude             [dict get $p exclude]
    1-4scaling          [dict get $p 1-4_scaling]
    cutoff              [dict get $p cutoff]
    switching           [dict get $p switching]
    switchdist          [dict get $p switch_dist]
    pairlistdist        [dict get $p pair_list_dist]
    vdwForceSwitching   [dict get $p vdw_force_switching]
    LJCorrection        [dict get $p lj_correction]
}
