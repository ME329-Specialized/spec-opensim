Date updated: 3/28/2021

What is the "Full_Workflow" folder?
This the folder the Stanford student team stored all of the different OpenSim models and results for the simulations performed at the end of the winter quarter in 2021.

# Navigation
## "Simulated_Forward_Kinematics"
	Contains all models used for the SFK step of the workflow. These models have a prescribed function at the crank angle that drives the pedaling motion at a constant cadence of 80 rpm.

	Additionally, there are MATLAB scripts here for processing the reaction forces due to the PedalClip constraint and readying the data to be used for the CMC simulations.
	  * write_forces.m is the main script that needs to be run for post-processing of the PedalClip forces
	  * write_mot4forces.m writes a motion file (tab delimited) which is interpretable for OpenSim
	  * write_xml4forces.m writes a xml file which is needed in the setup files for the CMC setup files


## "Computed_Muscle_Control"
	Contains all models used for the CMC step of the workflow. These models do not have a prescribed function at the crank angle. They are ready to use with OpenSim's CMC Tool.

## "Results"
	Subfolders are for each of the 6 saddle positions for which the full workflow was iterated over. In each trial folder, there is both a folder for SFK outputs and for CMC outputs.

## MATLAB scripts
	"plot_metabolics_and_active_force.m" utilizes all other MATLAB scripts in this folder. It will plot the force capacity for all muscles for all trials, metabolic energy expenditure rates for all muscles for all trials, and plots with only some of the data for easier interpretation.

	"get_muscle_states.m" is the script for fetching the muscle fiber lengths and muscle fiber velocities from "Results" for the Simulated Forwrad Kinematic simulations.

	"get_metabolics.m" is the script for fetching the metabolic energy expenditure rates from "Results" for the Computed Muscle Control simulations.

	The MATLAB scripts in this immediate folder are for utilizing the outputs from the simulations stored in "Results".
	
	The "Thelen2003" live functions are utilized to calculate the active force capacity of the muscles based on the muscle fiber lengths and velocities.
