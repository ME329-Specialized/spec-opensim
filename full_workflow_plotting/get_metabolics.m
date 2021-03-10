function [metabolics_report, crank_angles] = get_metabolics(Sx,Sy)
    % for the saddle position defined with an Sx and an Sy, fetch the data
    % outputted by Computed Muscle Control Metabolics Reporter:
    % require normalized muscle fiber lengths and muscle fiber
    % velocities (these will be normalized afterwards) 
    % to calculate maximum possible active force versus time
    % for the duration of the simulation episode
    
    trial_name = ['Saddle_x_',num2str(Sx),'_y_',num2str(Sy)];
    trial_folder = [pwd,'\Results\', trial_name, '\CMC\'];
    
    prefix = 'CMC_leg_';

    metabolics_reporter = [trial_folder, prefix, ...
        'MetabolicsReporter_probes.sto'];
    kinematics_q = [trial_folder, prefix, ...
        'Kinematics_q.sto'];
    
    metabolics_report = importdata(metabolics_reporter,'\t');
    kinematics = importdata(kinematics_q,'\t');
    crank_angles = -kinematics.data(:,2);
end

