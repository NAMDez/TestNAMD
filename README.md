# TestNAMD
Test suite for NAMD

# System Sizes
* POPC membrane 77K (Paween & Tao)
* apoA1 92K (Shashank & Nandan)
* ATP synthase 332K (Charles & Steven)

# Example
## Regular MD simulation
```
cd apoA1
namd2 +p32 namd/md/r1.namd | tee r1.log
```

## Temperature replica exchange MD
```
cd apoA1
../run.sh namd/txmd/r1.namd 1 32 2
```
where 1 is the stage of the MD  ,
`32` is the number CPU cores,  
and `2` is the number of replicas.
The configuration file is designed to
accommodate any number of replicas
without changing the config file.


