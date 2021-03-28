% plot pedal reaction forces
radius = [0.8196 0.8396];
theta = [102 105 108];
if ~exist('fig')
    fig = figure;
end
if ~ishandle(fig)
    fig = figure;
else
    clf(fig);
end
colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
    0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
set(groot,'DefaultLineLineWidth',1.5);
hold on; box on; grid on;
for ri = 1:length(radius)
    for ti = 1:length(theta)
        trial_folder = ['Saddle_t_',num2str(theta(ti)),'_r_',num2str(radius(ri))];
        saddle_pos = ['S_{R,θ} = (',num2str(radius(ri)),'m, (',num2str(theta(ti)),'°)'];
        results_path = [pwd,'\..\Results\',trial_folder,'\SFK\'];    
        % retrieve pedal clip forces that were processed in
        % 'write_forces.m'
        force_mot = [results_path, 'pedal_clip_forces.mot'];
        forces = importdata(force_mot,'\t');
        % retrieve crank angles for this SFK trial
        kinematics_sto = [results_path, 'sfk_cyclingleg_Kinematics_q.sto'];
        kinematics = importdata(kinematics_sto,'\t');
        
        Fx = forces.data(:,2);
        Fy = forces.data(:,3);
        F = (Fx.^2 + Fy.^2).^(1/2);
        crank_angles = kinematics.data(:,2);
        
        plot(-crank_angles, F, 'DisplayName', saddle_pos);
        xlabel('Crank Angle [deg]')
        ylabel('Pedal Force Magnitude [N]');
        legend('Location','northeast');
        set(gca,'FontSize',18);
    end
end