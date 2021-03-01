function [t, bf_lh, bf_sh, glut, vas_int] = get_muscle_states(Sx,Sy,k,plotting)
    % for the saddle position defined with an Sx and an Sy, fetch the data
    % outputted by CMC trial and return the total_metabolic_rate
    % throughout the entire simulation
    
    % also returns the raw data for the 4 muscles included in the CMC model
    % as of 2/28/2021
    trial_name = ['Saddle_x_',num2str(Sx),'_y_',num2str(Sy)];
    trial_folder = [pwd,'\Results\', trial_name, '\SFK\'];
%     metabolics_reporter = [trial_folder, 'CMC_leg_MetabolicsReporter_probes.sto'];
%     metabolics_report = importdata(metabolics_reporter, '\t');
% 
%     data = metabolics_report.data;
%     textdata = metabolics_report.textdata;
%     colheaders = metabolics_report.colheaders;
    prefix = 'sfk_cyclingleg';
    trial = ['_x_',num2str(Sx),'_y_',num2str(Sy),'_'];
    ma_fiber_force = [trial_folder,prefix,trial,'MuscleAnalysis_FiberForce.sto'];
    ma_fiber_length = [trial_folder,prefix,trial,'MuscleAnalysis_FiberLength.sto'];
    ma_norm_fiber_length = [trial_folder,prefix,trial,'MuscleAnalysis_NormalizedFiberLength.sto'];
    ma_norm_fiber_velocity = [trial_folder,prefix,trial,'MuscleAnalysis_NormFiberVelocity.sto'];
    
    fiber_forces = importdata(ma_fiber_force,'\t');
    fiber_lengths = importdata(ma_fiber_length,'\t');
    norm_fiber_lengths = importdata(ma_norm_fiber_length,'\t');
    norm_fiber_vels = importdata(ma_norm_fiber_velocity,'\t');
    
    ff = fiber_forces.data;
    fl = fiber_lengths.data;
    nfl = norm_fiber_lengths.data;
    nfv = norm_fiber_vels.data;
    
    % taken from CMC Leg GUI
    % max isometric force for [bf_lh, bf_sh, glut, vas_int]
    f_max_iso = [2594.0, 960.0, 1944.0, 4530.0]; % [N]
    
    smooth_method = 'movmean';
    ws = 10; % window size
    
    ff_time = ff(:,1);
    ff_bf_lh = ff(:,2);
    ff_bf_sh = ff(:,3);
    ff_glut = ff(:,4);
    ff_vas_int = ff(:,5);
    
    nfl_time = nfl(:,1);
    nfl_bf_lh = nfl(:,2);
    nfl_bf_sh = nfl(:,3);
    nfl_glut = nfl(:,4);
    nfl_vas_int = nfl(:,5);
    
    nfv_time = nfv(:,1);
    nfv_bf_lh = nfv(:,2);
    nfv_bf_sh = nfv(:,3);
    nfv_glut = nfv(:,4);
    nfv_vas_int = nfv(:,5);
    
    if plotting
        figure(k); clf; hold on; box on; grid on;
        set(gcf,'Name',[trial_name, ' Normalized F-L Curves'])
        set(gca,'FontSize',12)
        colororder([0.8 0 0; 0 0.7 1; 0.6 0 0.8; 1 0.5 0]);
        set(groot,'DefaultLineLineWidth', 1.5);
        plot(nfl_bf_lh, ff_bf_lh/f_max_iso(1), 'DisplayName', 'Bifemlh')
        plot(nfl_bf_sh, ff_bf_sh/f_max_iso(2), 'DisplayName', 'Bifemsh')
        plot(nfl_glut, ff_glut/f_max_iso(3), 'DisplayName', 'Glut Max2')
        plot(nfl_vas_int, ff_vas_int/f_max_iso(4), 'DisplayName', 'Vas Int')
        legend('Location','north','FontSize',10)
        xlabel('Normalized Muscle Length [m/m]')
        ylabel('Normalized Muscle Force [N/N]')
        title(['Trial ',num2str(k),' with S_{x,y} = (',num2str(Sx),',',num2str(Sy),') m'])
        hold off;
        
    end
end

