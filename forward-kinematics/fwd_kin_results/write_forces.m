% run this script from the folder 'fwd_kin_results'
% trial_num = input('What is the number of the trial? ');
trial_num = 4;
trial_folder = ['\Trial ', num2str(trial_num), '\muscled_up_analyses\'];
force_reporter_filename = 'fwd_cyclingleg_ForceReporter_forces.sto';
point_kin_filename = 'fwd_cyclingleg_PointKinematics_PedalClip_pos.sto';
if startsWith(pwd, 'C:\Users\david')
    % if David Gonzalez is running this code on his machine, this block
    % automatically moves into the correct folder
    cd C:\Users\david\GitHub\spec-opensim\forward-kinematics\fwd_kin_results;
end
return2here = pwd;
try
    if ~endsWith(return2here, '\fwd_kin_results')
        ME = MException('write_forces:IncorrectPath',...
            'Not being ran from correct folder. Navigate to "fwd_kin_results".');
        throw(ME)
    end
    force_file_path = [pwd, trial_folder];
    cd(force_file_path)
    force_report = importdata(force_reporter_filename, '\t');
    pedalclip_pos = importdata(point_kin_filename, '\t');
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
    pedal_force_headers = force_report.colheaders(force_indices);
    t  = force_report.data(:, 1);
    % 'raw' data from simulated forward kinematics with potential spikes in
    % force magnitudes
    Fx = force_report.data(:, force_indices(1));
    Fy = force_report.data(:, force_indices(2));
    Fz = force_report.data(:, force_indices(3));
    Px = pedalclip_pos.data(:, 2);
    Py = pedalclip_pos.data(:, 3);
    Pz = pedalclip_pos.data(:, 4);
    % 'rloess' smoothing:
    % Robust quadratic regression over each window of A. 
    % This method is a more computationally expensive version of the method 'loess', 
    % but it is more robust to outliers.
    % window size = 100 data points
    smooth_Fx = smoothdata(force_report.data(:, force_indices(1)), 'rloess', 100);
    smooth_Fy = smoothdata(force_report.data(:, force_indices(2)), 'rloess', 100);
    smooth_Fz = smoothdata(force_report.data(:, force_indices(3)), 'rloess', 100);
    smooth_Px = smoothdata(pedalclip_pos.data(:, 2), 'rloess', 100);
    smooth_Py = smoothdata(pedalclip_pos.data(:, 3), 'rloess', 100);
    smooth_Pz = smoothdata(pedalclip_pos.data(:, 4), 'rloess', 100);
    smooth_data = [t, smooth_Fx, smooth_Fy, smooth_Fz, smooth_Px, smooth_Py, smooth_Pz];
%     figure(1); clf; hold on; box on; grid on;
%     colororder([0.7 0 0; 0 0 0.7; 0 0.7 0; 0.4 0 0; 0 0 0.4; 0 0.4 0])
%     plot(t, smooth_Fx, 'LineWidth', 1.5)
%     plot(t, smooth_Fy, 'LineWidth', 1.5)
%     plot(t, smooth_Fz, 'LineWidth', 1.5)
%     plot(t, Fx, '--')
%     plot(t, Fy, '--')
%     plot(t, Fz, '--')
%     xlabel('Time - t [s]')
%     ylabel('Pedal force on midfoot - F [N]')
%     ylim([-600 3000])
%     title('External / Constraint forces during Simulated Forward Kinematics')
%     set(gca,'FontSize', 13)
%     legend('Smooth F_x', 'Smooth F_y', 'Smooth F_z', 'Fx', 'Fy', 'Fz', 'FontSize', 10)
%     hold off;
    cd(return2here)
    filename = ['external_pedal_forces_trial_', num2str(trial_num)];
    modelname = 'simplified_cycling_modelV4_const_cadence';
    % writes smoothed data to a .mot tab-delimited file
    colheaders = {'time', force_report.colheaders{force_indices}, ...
        'PedalClip_calcn_r_Px', 'PedalClip_calcn_r_Py', 'PedalClip_calcn_r_Pz'};
    write_mot4forces(filename, modelname, 1, size(smooth_data,1), ...
        size(smooth_data,2), 'yes', colheaders, smooth_data);
    % writes smoothed data to a .xml file
    write_xml4forces(filename);
catch ME
    if strcmp(ME.identifier,'MATLAB:cd:NonExistentFolder')
        msg = 'That folder does not exist. Try with a different trial number.';
        causeException = MException('MATLAB:cd:NonExistentFolder',msg);
        ME = addCause(ME, causeException);
    end
    cd(return2here);
    rethrow(ME)
end
