% run this script from the folder '../full_workflow/Simulated_Forward_Kinematics'
% trial_num = input('What is the number of the trial? ');
% trial_num = 4;
% trial_folder = ['\Trial ', num2str(trial_num), '\muscled_up_analyses\'];
% force_reporter_filename = 'simulated_forward_kinematics_cyclingleg_ForceReporter_forces.sto';
% point_kin_filename = 'fwd_cyclingleg_PointKinematics_PedalClip_pos.sto';
% if David Gonzalez is running this code on his machine, this block
% automatically moves into the correct folder
if startsWith(pwd, 'C:\Users\david')
    cd C:\Users\david\GitHub\spec-opensim\full_workflow\Simulated_Forward_Kinematics;
end

% choose which trial folder to use based on Saddle Position Sx and Sy
prompt = {'\fontsize{10} Enter x-distance S_x:','\fontsize{10} Enter y-distance S_y:'};
dlgtitle = 'Saddle position?';
dims = [1 60];
definput = {'-0.1','-0.5'};
opts.Interpreter = 'tex';
opts.Resize = 'on';
Sxy = inputdlg(prompt,dlgtitle,dims,definput,opts);
Sx = Sxy{1};
Sy = Sxy{2};
trial_folder = ['Saddle_x_',Sx,'_y_',Sy];
%% ------------------------------------------------------------------------
try
    % retrieve PedalClip forces from ForceReporter_forces.sto
    results_path = [pwd,'\..\Results\',trial_folder,'\SFK\'];    
    force_reporter = [results_path, 'sfk_leg_ForceReporter_forces.sto'];
    force_report = importdata(force_reporter, '\t');
    force_indices = zeros([1,3]);
    f = 1;
    for j = 1:length(force_report.colheaders)
        f_cols = force_report.colheaders{j};
        if startsWith(f_cols, 'PedalClip_calcn_r_F') 
            force_indices(f) = j;
            % 38, 39, 40
            f = f+1;
        end
    end
    pedalclip_headers = force_report.colheaders(force_indices);
    t  = force_report.data(:, 1);
    % 'raw' data from simulated forward kinematics with potential spikes in
    % force magnitudes
    Fx = force_report.data(:, force_indices(1));
    Fy = force_report.data(:, force_indices(2));
    Fz = force_report.data(:, force_indices(3));
    
    % smooth out the data for Fx and Fy to get rid of spikes in forces
    
    % 'rloess' smoothing:
    % Robust quadratic regression over each window of A. 
    % This method is a more computationally expensive version of the method 'loess', 
    % but it is more robust to outliers.
    % window size = 100 data points
    smooth_Fx = smoothdata(force_report.data(:, force_indices(1)), 'rloess', 100);
    smooth_Fy = smoothdata(force_report.data(:, force_indices(2)), 'rloess', 100);
    % currently zero-ing out all Fz at PedalClip since forces are
    % unreasonable, even after smoothing
    smooth_Fz = 0 * force_report.data(:, force_indices(3));
    % prepare data to be written to a .mot file
    smooth_data = [t, smooth_Fx, smooth_Fy, smooth_Fz];    
    
    % writes smoothed data to a .mot tab-delimited file
    colheaders = {'time', pedalclip_headers{1:3}};
    filename = 'pedal_clip_forces';
    write_mot4forces(results_path, filename, 1, size(smooth_data,1), ...
        size(smooth_data,2), 'yes', colheaders, smooth_data);
    
    % writes smoothed data to a .xml file
    write_xml4forces(results_path, filename);
    
catch ME
    if strcmp(ME.identifier,'MATLAB:cd:NonExistentFolder')
        msg = 'That folder does not exist. Try with a different trial number.';
        causeException = MException('MATLAB:cd:NonExistentFolder',msg);
        ME = addCause(ME, causeException);
    end
    rethrow(ME)
end
