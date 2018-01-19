#########################################
### Namd Test Suite: f1 ATP synthase  ###
### Chang Sun
### update
### Resolvate/ionize the system
### ~770K atom, 150 mM NaCl
#########################################

#########################################
### 1.System Overview                 ###
#########################################
The f1ATPsynthase system is initially put together by Barry Isralewitz and Emad Tajkhorshid using PDB 1E79 (Bovine F1-ATPase inhibited by DCCD (dicyclohexylcarbodiimide), 2.4 Angstrom resolution).In addition to the existing residues, two short loops are also built to fill the gaps in the gamma subunit. A box of TIP3 water along with 0.1 M NaCl is used to solvate the protein. The final system has a dimension of 178.3 x 131.5 x 132.4 (angstrom) and 327506 atoms.

To equilibrate the system, 10-ns of NPT simulation is performed at 310 K with namd 2.12. The final coordinate, velocity and extended system files are prefixed with "f1ATPsynthase_10ns_310K_NPT". 

#########################################
### 2. Numerical Accuracy Test        ###
#########################################
To run the Numerical Accuracy Test, simply type "./Numerical_Accuracy_test.sh", it takes about 9 minutes to finish with 12 cores.

2.1 NPT run to test Temperature and Pressure.
50 individual 1-ps NPT runs are started using the same coordinates, velocity and extended system. Then their output log files are lumped together, serving as the reference data. To test the Numerical Accuracy, another 1-ps NPT run is started, its log file is then parsed and compared with the reference data in R using Kolmogorov-Smirnov test. Basically, if the reported p-value is less than 0.05, then it suggests the new namd run is significantly different from the reference.
(NOTE: the namd log file parsing is written in perl for performance purpose. This whole process is automated using a bash script)

2.2 NVE run to test the Volume and Energy.
Similarly, 50 individual 1-ps NVE runs are started using the same coordinates, velocity and extended system. Then their output log files are lumped together, serving as the reference data. To test the Numerical Accuracy, another 1-ps NPT run is started, its log file is then parsed and compared with the reference data in R using Kolmogorov-Smirnov test.

#########################################
### 3. Namd functional Test           ###
#########################################
I would like to Rotate the f1 ATP synthase using rotating constant. But this would take some time to develop.
