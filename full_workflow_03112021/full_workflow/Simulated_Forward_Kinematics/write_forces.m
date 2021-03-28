% if running this code on David's laptop, change directory to here for
% proper pathing
if startsWith(pwd,'C:\Users\david')
    cd( 'C:\Users\david\GitHub\spec-opensim\full_workflow_03112021\full_workflow\Simulated_Forward_Kinematics')
end
% choose which trial folder to use based on Saddle Position R and θ
prompt = {'\fontsize{10} Enter angle θ in degrees:','\fontsize{10} Enter radius r in meters:'};
dlgtitle = 'Saddle position?';
dims = [1 60];
definput = {'102','0.8196'};
opts.Interpreter = 'tex';
opts.Resize = 'on';
polar_input = inputdlg(prompt,dlgtitle,dims,definput,opts);
try
    theta = polar_input{1};
    radius = polar_input{2};
    trial_folder = ['Saddle_t_',theta,'_r_',radius];
    saddle_pos = ['S_{R,θ} = (',num2str(radius),'m, (',num2str(theta),'°)'];
    disp(['Writing reaction force files for ',trial_folder])
catch ME
    disp('Force file generation aborted');
    return;
end

%% ------------------------------------------------------------------------
try
    % retrieve PedalClip forces from ForceReporter_forces.sto
    results_path = [pwd,'\..\Results\',trial_folder,'\SFK\'];    
    force_reporter = [results_path, 'sfk_cyclingleg_ForceReporter_forces.sto'];
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
    ws = 50;
    smooth_Fx = smoothdata(Fx, 'rloess', ws);
    smooth_Fy = smoothdata(Fy, 'rloess', ws);
    while max(abs(smooth_Fx)) > 1000
        prev_max = max(abs(smooth_Fx));
        disp(['max smooth Fx = ', num2str(prev_max) , ' N']);
        smooth_Fx = smoothdata(smooth_Fx, 'rloess', ws);
        new_max = max(abs(smooth_Fx));
        if abs(prev_max - new_max)/prev_max < 1e-4
            break;
        end
        ws = ws + 50;
    end
    ws = 50;
    while max(abs(smooth_Fy)) > 1000
        prev_max = max(abs(smooth_Fy));
        disp(['max smooth Fy = ', num2str(prev_max) , ' N']);
        smooth_Fy = smoothdata(smooth_Fy, 'rloess', ws);
        new_max = max(abs(smooth_Fy));
        if abs(prev_max - new_max)/prev_max < 1e-4
            break;
        end
        ws = ws + 50;
    end
    % currently zero-ing out all Fz at PedalClip since forces are
    % unreasonable, even after smoothing
    smooth_Fz = 0 * Fz;
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
%% ------------------------------------------------------------------------
% plotting of force profiles
time = force_report.data(:,1);
% if ~exist('force_fig')
%     force_fig = figure; clf;
% end
% if ~ishandle(force_fig)
%     force_fig = figure; clf;
% else
%     clf(force_fig);
% end
figure;
box on; grid on; hold on; 
plot(time, smooth_Fx, 'r', 'DisplayName', 'Fx');
plot(time, smooth_Fy, 'b', 'DisplayName', 'Fy');
legend
xlabel('Time [s]');
ylabel('Pedal Force [N]');
title(trial_folder,'Interpreter','none')
hold off;