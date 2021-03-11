% Fetch the muscle states (length and velocity) for SFK trials for all
% selected saddle positions

% if David Gonzalez is running this code on his machine, this block
% automatically moves into the correct folder
if startsWith(pwd, 'C:\Users\david')
    cd('C:\Users\david\GitHub\spec-opensim\full_workflow_03112021\full_workflow');
end

% Current 6 CMC trials as of 3/11/2021
theta = [102 105 108];
radius = [0.8196 0.8396];
% optimal fiber lengths as define in the .osim for all muscles
opt_fib_len = [0.12823851; 0.20083733; 0.16291391; 0.12617328; 0.09; 0.098];
% maximum contraction velocities as defined in the .osim for muscles
fib_max_vel = [10; 10; 10; 10; 10; 10]; 
set(groot,'DefaultLineLineWidth', 1.4);
fs = 16; % fontsize
%% ------------------------------------------------------------------------
k = 1;
fig1 = figure(1); clf;
fig1.Name = 'Active force w.r.t. Crank Angle';
tile_1 = tiledlayout(2,3,'Padding','Compact');
colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
            
fig2 = figure(2); clf;
fig2.Name = 'Active force for Vastus Intermedius w.r.t. Crank Angle';
colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
            
% plotting figures 1 and 2 using cartesian coordinates for saddle position
for ri = 1:length(radius)
    for ti = 1:length(theta)
        % NO DATA FOR THIS SADDLE POSITION
        % x = -0.11, y = -0.04
        saddle_pos = ['S_{θ,r} = (',num2str(theta(ti)),'°, ',num2str(radius(ri)),'m)'];
        
        % capture normalized muscle fiber lengths and muscle
        % fiber velocities from the Muscle Analysis reporter for the
        % specified trial denoted by Sx(i) and Sy(j)
        [MA_norm_fib_lens, MA_fib_vels, crank_angles] = get_muscle_states(theta(ti),radius(ri));
        norm_fib_lens = MA_norm_fib_lens.data;
        fib_vels = MA_fib_vels.data;
        colheaders = MA_norm_fib_lens.colheaders;
        time = norm_fib_lens(:,1); 
        % smooth the data with movmean
        window_size = 500;
        fib_vels = smoothdata(fib_vels,'movmean',window_size);

        musc_index = [2,3,4,5];
        % figure 1 plotting -------------------------------------------
        figure(fig1);
        nexttile(k);
        hold on; box on; grid on;
        gax1 = gca;
        gax1.FontSize = fs;
        for n = musc_index
            FL = Thelen2003_Active_Force_Length(norm_fib_lens(:,n));
            v_max = 10*opt_fib_len(n-1);
            FV = Thelen2003_Force_Velocity(fib_vels(:,n) / v_max);
            plot(crank_angles, FL.*FV,'DisplayName', colheaders{n});
        end  
        if k == 5
            xlabel('Crank Angle [deg]')
        end
        if k == 4
            ylabel('Normalized Active Force: F^L(L/L_{opt}) \times F^V(v/v_{max})')
            gax1.YLabel.Position(2) = 1.75;
        end
        title(saddle_pos,'FontWeight','normal')
        xlim([0 360] + crank_angles(1))
        ylim([0.4 1.6])
%             xticks([0:45:360] + crank_angles(1))
        % show the downstroke of the leg between 45 and 135 deg
        fill([45 45 135 135],[gax1.YLim flip(gax1.YLim)],'c','DisplayName','Downstroke', ...
            'FaceAlpha',0.1,'EdgeAlpha',0);
        % show the upstroke of the leg between 225 and 315 deg
        fill([225 225 315 315],[gax1.YLim flip(gax1.YLim)],'g','DisplayName','Upstroke', ...
            'FaceAlpha',0.1,'EdgeAlpha',0);
        k = k + 1; % increase trial index
        
        % figure 2 plotting -------------------------------------------
        figure(fig2);
        hold on; box on; grid on;
        gax2 = gca;
        gax2.FontSize = fs;
        trial_name = ['S_{θ,r}=(',num2str(theta(ti)),'°, ',num2str(radius(ri)),'m)'];
        FL_vast = Thelen2003_Active_Force_Length(norm_fib_lens(:,5));
        v_max_vast = 10*opt_fib_len(4);
        FV_vast = Thelen2003_Force_Velocity(fib_vels(:,5) / v_max_vast);
        plot(crank_angles,FL_vast.*FV_vast,'DisplayName',trial_name);
        xlim(crank_angles(1) + [0, 360]);
        ylim([0.4 1.6])
        legend('Location','best');
        xlabel('Crank Angle [deg]');
        ylabel('Normalized Active Force: F^L(L/L_{opt}) \times F^V(v/v_{max})')
        title('Active Force for Vastus Intermedius','FontWeight','normal')
    end
    

end

% show the downstroke of the leg between 45 and 135 deg
fill(gax2,[45 45 135 135],[gax2.YLim flip(gax2.YLim)],'c','DisplayName','Downstroke', ...
    'FaceAlpha',0.1,'EdgeAlpha',0);
% show the upstroke of the leg between 225 and 315 deg
fill(gax2,[225 225 315 315],[gax2.YLim flip(gax2.YLim)],'g','DisplayName','Upstroke', ...
    'FaceAlpha',0.1,'EdgeAlpha',0);
%% ------------------------------------------------------------------------
% adjust figures for clarity
% figure(fig1);
fig1.Units = 'normalized';
% fig1.OuterPosition = [0.000    0.1    0.90    0.85];
fig1.OuterPosition(2) = 0.1;
fig1.OuterPosition(3) = 0.90;
fig1.OuterPosition(4) = 0.85;
tile_1.InnerPosition = [0.07    0.10    0.725    0.8];
lgd_1 = legend(gax1,'Interpreter','none','FontSize',14);
lgd_1.Position = [1.01 0.325 0.175 0.30];

% figure(fig2);
fig2.Units = 'normalized';
% fig2.OuterPosition = [0.000    0.1    0.90    0.85];
fig2.OuterPosition(2) = 0.1;
fig2.OuterPosition(3) = 0.90;
fig2.OuterPosition(4) = 0.85;
%% ------------------------------------------------------------------------
% % plotting figure 3 for polar coordinate saddle position
% fig3 = figure(3); clf;
% fig3.Name = 'Active force w.r.t. Crank Angle with Polar Saddle Pos';
% tile_3 = tiledlayout(1,3,'Padding','compact');
% colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
%                 0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
% fig4 = figure(4); clf;
% fig4.Name = 'Active force for Vastus Intermedius w.r.t. Crank Angle with Polar Saddle Pos';
% colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
%                 0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])  
%             
% for k = 1:length(theta)
%     u = theta(k);
%     [MA_norm_fib_lens, MA_fib_vels, crank_angles] = get_muscle_states_polar(u);
%     norm_fib_lens = MA_norm_fib_lens.data;
%     fib_vels = MA_fib_vels.data;
%     colheaders = MA_norm_fib_lens.colheaders;
%     time = norm_fib_lens(:,1); 
%     % smooth the data with movmean
%     window_size = 500;
%     fib_vels = smoothdata(fib_vels,'movmean',window_size);
%             
%     musc_index = [2,3,4,5];
%     % figure 3 plotting -------------------------------------------
%     figure(fig3);
%     nexttile(k);
%     hold on; box on; grid on;
%     gax3 = gca;
%     gax3.FontSize = fs;
%     for n = musc_index
%         FL = Thelen2003_Active_Force_Length(norm_fib_lens(:,n));
%         v_max = 10*opt_fib_len(n-1);
%         FV = Thelen2003_Force_Velocity(fib_vels(:,n) / v_max);
%         plot(crank_angles, FL.*FV,'DisplayName', colheaders{n});
%     end  
%     if k == 2
%         xlabel('Crank Angle [deg]')
%     end
%     if k == 1
%         ylabel('Normalized Active Force: F^L(L/L_{opt}) \times F^V(v/v_{max})')
%     end
%     trial_name = ['\theta = ',num2str(u),'°'];
%     title(trial_name,'FontWeight','normal')
%     xlim([0 360] + crank_angles(1))
%     ylim([0.4 1.6])
%     % show the downstroke of the leg between 45 and 135 deg
%     fill([45 45 135 135],[gax3.YLim flip(gax3.YLim)],'c','DisplayName','Downstroke', ...
%         'FaceAlpha',0.1,'EdgeAlpha',0);
%     % show the upstroke of the leg between 225 and 315 deg
%     fill([225 225 315 315],[gax3.YLim flip(gax3.YLim)],'g','DisplayName','Upstroke', ...
%         'FaceAlpha',0.1,'EdgeAlpha',0);
%     
%     % figure 4 plotting -------------------------------------------
%     figure(fig4);
%     hold on; box on; grid on;
%     gax4 = gca;
%     gax4.FontSize = fs;
%     FL_vast = Thelen2003_Active_Force_Length(norm_fib_lens(:,5));
%     v_max_vast = 10*opt_fib_len(4);
%     FV_vast = Thelen2003_Force_Velocity(fib_vels(:,5) / v_max_vast);
%     plot(crank_angles,FL_vast.*FV_vast,'DisplayName',trial_name);
%     xlim(crank_angles(1) + [0, 360]);
%     ylim([0.4 1.6])
%     legend('Location','best');
%     xlabel('Crank Angle [deg]');
%     ylabel('Normalized Active Force: F^L(L/L_{opt}) \times F^V(v/v_{max})')
%     title('Active Force for Vastus Intermedius','FontWeight','normal')
% end
% % show the downstroke of the leg between 45 and 135 deg
% fill([45 45 135 135],[gax4.YLim flip(gax3.YLim)],'c','DisplayName','Downstroke', ...
%     'FaceAlpha',0.1,'EdgeAlpha',0);
% % show the upstroke of the leg between 225 and 315 deg
% fill([225 225 315 315],[gax4.YLim flip(gax3.YLim)],'g','DisplayName','Upstroke', ...
%     'FaceAlpha',0.1,'EdgeAlpha',0);
% %% ------------------------------------------------------------------------
% % adjust figures for clarity
% % figure(fig3);
% fig3.Units = 'normalized';
% % fig1.OuterPosition = [0.000    0.1    0.90    0.85];
% fig3.OuterPosition(2) = 0.20;
% fig3.OuterPosition(3) = 0.90;
% fig3.OuterPosition(4) = 0.70;
% tile_3.InnerPosition = [0.07    0.15    0.750    0.75];
% lgd_3 = legend(gax3,'Interpreter','none','FontSize',14);
% lgd_3.Position = [1 0.325 0.15 0.4];
% 
% % figure(fig4);
% fig4.Units = 'normalized';
% % fig2.OuterPosition = [0.000    0.1    0.90    0.85];
% fig4.OuterPosition(2) = 0.1;
% fig4.OuterPosition(3) = 0.70;
% fig4.OuterPosition(4) = 0.75;
%% ------------------------------------------------------------------------
disp('If CMC metabolics have been stored in the appropriate folders, continue onwards!')
% fig5 = figure(5); clf;
% fig5.Name = 'Mean Total Metabolics for CMC Trials';
% tile_5 = tiledlayout(1,1,'Padding','compact');
% colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
%                 0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
mean_metabolics = zeros([length(theta), length(radius)]);

fig6 = figure(6); clf;
fig6.Name = 'Metabolics w.r.t. Crank Angle';
tile_6 = tiledlayout(1,1,'Padding','compact');
colororder([0 0 0; 0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1])
            
fig7 = figure(7); clf;
fig7.Name = 'Metabolics for Vastus w.r.t. Crank Angle';
colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
k = 1;

for ri = 1%:length(radius)
    for ti = 1%:length(theta)

        saddle_pos = ['S_{θ,r} = (',num2str(theta(ti)),'° ,',num2str(radius(ri)),'m)'];
        
        % metabolics from the metabolics reporter and crank angle
        [metabolics_report, crank_angles] = get_metabolics(theta(ti),radius(ri));
        metabolics = metabolics_report.data;
        colheaders = metabolics_report.colheaders;
        % store for "parachute" plot
        P_mean = mean(metabolics(:,2));            
        mean_metabolics(ti,ri) = P_mean;
        % indices for muscles of the leg (columns in [metabolics])
        meta_index = [2, 4, 5, 6, 7];

        % figure 6 plotting -------------------------------------------
        figure(fig6);
        nexttile(k);
        hold on; box on; grid on;
        gax6 = gca;
        gax6.FontSize = fs;   
        for mi = meta_index
            smooth_metabolics = smoothdata(metabolics(:,mi),'movmean',50);
            plot(crank_angles,smooth_metabolics,'DisplayName',colheaders{mi});
        end
%             xlim(crank_angles(1) + [0, 360]);
        smooth_total = smoothdata(metabolics(:,2),'movmean',30);
        ylim([0 max(smooth_total)])
        % show the downstroke of the leg between 45 and 135 deg
        fill([45 45 135 135],[gax6.YLim flip(gax6.YLim)],'c','DisplayName','Downstroke', ...
            'FaceAlpha',0.1,'EdgeAlpha',0);
        % show the upstroke of the leg between 225 and 315 deg
        fill([225 225 315 315],[gax6.YLim flip(gax6.YLim)],'g','DisplayName','Upstroke', ...
            'FaceAlpha',0.1,'EdgeAlpha',0);
        if k == 4
            ylabel('Metabolic Energy Expenditure Rate [W]')
            gax6.YLabel.Position(2) = 1.75;
        end
        if k == 5
            xlabel('Crank Angle [deg]')
        end

        title(saddle_pos,'FontWeight','normal');
        % figure 7 plotting -------------------------------------------
        figure(fig7);
        hold on; box on; grid on;
        gax7 = gca;
        gax7.FontSize = fs;
        trial_name = ['S_{θ,r}=(',num2str(theta(ti)),'° ,',num2str(radius(ri)),'m)'];
        smooth_vast = smoothdata(metabolics(:,7),'movmean',50);
        plot(crank_angles,smooth_vast,'DisplayName',trial_name);
        xlim(crank_angles(1) + [0, 360]);
        legend('Location','best');
        xlabel('Crank Angle [deg]');
        ylabel('Metabolic Energy Expenditure Rate [W]')
        title('Metabolics for Vastus Intermedius','FontWeight','normal')
        k = k + 1; % increase trial index
    end
end
% show the downstroke of the leg between 45 and 135 deg
fill(gax7,[45 45 135 135],[gax7.YLim flip(gax7.YLim)],'c','DisplayName','Downstroke', ...
    'FaceAlpha',0.1,'EdgeAlpha',0);
% show the upstroke of the leg between 225 and 315 deg
fill(gax7,[225 225 315 315],[gax7.YLim flip(gax7.YLim)],'g','DisplayName','Upstroke', ...
    'FaceAlpha',0.1,'EdgeAlpha',0);
%% ------------------------------------------------------------------------
% figure(fig5); 
% mean_metabolics(mean_metabolics <= 0) = NaN;
% [Sx_mesh, Sy_mesh] = meshgrid(Sx, Sy);
% parachute = surf(Sx_mesh,Sy_mesh,mean_metabolics','Marker','s',...
%     'MarkerSize',18,'MarkerFaceColor','g');
% parachute.FaceColor = 'interp';
% cb = colorbar('Location','eastoutside');
% cb.Label.String = 'P_{mean metabolic} [W]';
% cb.Label.FontSize = fs;
% zticks([])
% view(-45, 40)
% box on; grid on;
% colormap jet
% gax5 = gca;
% gax5.FontSize = fs;
% xlabel('Saddle X-Position [m]');
% ylabel('Saddle Y-Position [m]');
% title('Mean Total Metabolics P_{mean metabolic} vs Saddle Position S_{x,y}')
% % adjust figures for clarity
% % figure(fig4);
% fig5.Units = 'normalized';
% fig5.OuterPosition(2) = 0.25;
% fig5.OuterPosition(3) = 0.5;
% fig5.OuterPosition(4) = 0.7;
% tile_5.InnerPosition = [0.05 0.15 0.7 0.85];
% % cb.Position(1) = 0.9;
%% ------------------------------------------------------------------------
% adjust figures for clarity
% figure(fig5);
fig6.Units = 'normalized';
% fig1.OuterPosition = [0.000    0.1    0.90    0.85];
fig6.OuterPosition(2) = 0.10;
fig6.OuterPosition(3) = 0.90;
fig6.OuterPosition(4) = 0.85;
tile_6.InnerPosition = [0.065    0.10    0.70    0.80];
lgd_6 = legend(gax6,'Interpreter','none','FontSize',14);
lgd_6.Position = [1.0 0.30 0.30 0.40];

% figure(fig7);
fig7.Units = 'normalized';
% fig2.OuterPosition = [0.000    0.1    0.90    0.85];
fig7.OuterPosition(2) = 0.1;
fig7.OuterPosition(3) = 0.70;
fig7.OuterPosition(4) = 0.75;