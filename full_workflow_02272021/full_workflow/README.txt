Date updated: 2/24/2021

Workflow:
1. Saddle Position Sx,y is selected for the cycling model
2. Simulated Forward Kinematics is performed with a muscled-up constant cadence .osim
Current model "sfk_cyclingleg.osim" is taken from "simplified_cycling_modelV4_const_cadence.osim" (2/24/2021)
3. Analysis Tool is used to get data files for kinematics, muscle lengths, muscle velocities, and PedalClip constraint forces
4. MATLAB script write_mot4forces.m is run to clean up the data and prepare .xml files for CMC
5. CMC is performed using a less constrained .osim
Current model "cmc_cyclingleg.osim" is taken from "simplified_cycling_modelV4_cec_r2.osim" (2/24/2021)
6. Data for muscle activations, muscle forces, and metabolic energy expenditure is captured
7. TODO: post-processing of these data

Navigation:
Simulated_Forward_Kinematics
- contains sfk_cyclingleg.osim, Analyze setup .xml, and MATLAB scripts for writing out PedalClip forces to Results
Computed_Muscle_Control
- contains cmc_cyclingleg.osim, CMC setup .xml
Results
- subfolders based on trials (named after saddle position)
- contains all results / data from SFK and CMC in their respective folders