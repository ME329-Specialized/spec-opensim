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
fs = 18; % fontsize
%% ------------------------------------------------------------------------
k = 1;
fig1 = figure(1); clf;
fig1.Units = 'normalized';
fig1.OuterPosition(1) = 0.05;
fig1.Name = 'Active force w.r.t. Crank Angle';
tile_1 = tiledlayout(2,3,'Padding','Compact');
colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
            
fig2 = figure(2); clf;
fig2.Units = 'normalized';
fig2.OuterPosition(1) = 0.05;
% fig2.Name = 'Active force for Vastus Intermedius w.r.t. Crank Angle';
fig2.Name = 'Active force for Biceps Femoris LH w.r.t. Crank Angle';
colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
            
% plotting figures 1 and 2 using cartesian coordinates for saddle position
for ri = 1:length(radius)
    for ti = 1:length(theta)
        saddle_pos = ['S_{R,θ} = (',num2str(radius(ri)),'m, ',num2str(theta(ti)),'°)'];
        
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
            ylabel('Normalized Active Force Capacity')
            gax1.YLabel.Position(2) = 2;
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
        
        if ri == 1
            % figure 2 plotting -------------------------------------------
            figure(fig2);
            hold on; box on; grid on;
            gax2 = gca;
            gax2.FontSize = fs;
            trial_name = ['S_{R,θ}=(',num2str(radius(ri)),'m, ',num2str(theta(ti)),'°)'];
            FL_vast = Thelen2003_Active_Force_Length(norm_fib_lens(:,5)); % vastus
            FL_bifemlh = Thelen2003_Active_Force_Length(norm_fib_lens(:,2)); % bifemlh
            
            v_max_vast = 10*opt_fib_len(4);
            v_max_bifemlh = 10*opt_fib_len(1);
            
            FV_vast = Thelen2003_Force_Velocity(fib_vels(:,5) / v_max_vast);
%             FV_bifemlh = Thelen2003_Force_Velocity(fib_vels(:,2) / v_max_bifemlh);
            plot(crank_angles,FL_vast.*FV_vast,'DisplayName',trial_name);
%             plot(crank_angles,FL_bifemlh.*FV_bifemlh,'DisplayName',trial_name);
            
            xlim(crank_angles(1) + [0, 360]);
            ylim([0.4 1.6])
            legend('Location','northwest');
            xlabel('Crank Angle [deg]');
            ylabel('Normalized Active Force Capacity')
            title('Active Force Capacity for Vastus Intermedius','FontWeight','normal')
%             title('Active Force Capacity for Biceps Femoris LH','FontWeight','normal')
        end
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
fig1.OuterPosition(3) = 0.8;
fig1.OuterPosition(4) = 0.75;
tile_1.InnerPosition = [0.07    0.12    0.725    0.8];
lgd_1 = legend(gax1,'Interpreter','none','FontSize',fs);
lgd_1.Position = [1.01 0.325 0.23 0.30];

% figure(fig2);
fig2.Units = 'normalized';
% fig2.OuterPosition = [0.000    0.1    0.90    0.85];
fig2.OuterPosition(2) = 0.1;
fig2.OuterPosition(3) = 0.6;
fig2.OuterPosition(4) = 0.7;
%% ------------------------------------------------------------------------
% plotting figure 3 for polar coordinate saddle position
fig3 = figure(3); clf;
fig3.Name = 'Active force for θ = 108°, R = 0.8196 m';

colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
            
[MA_norm_fib_lens, MA_fib_vels, crank_angles] = get_muscle_states(theta(3),radius(1));
norm_fib_lens = MA_norm_fib_lens.data;
fib_vels = MA_fib_vels.data;
colheaders = MA_norm_fib_lens.colheaders;
time = norm_fib_lens(:,1); 
% smooth the data with movmean
window_size = 500;
fib_vels = smoothdata(fib_vels,'movmean',window_size);

musc_index = [2,3,4,5];
% figure 3 plotting -------------------------------------------
% figure(fig3);
% nexttile(k);
hold on; box on; grid on;
gax3 = gca;
gax3.FontSize = fs;
for n = musc_index
    FL = Thelen2003_Active_Force_Length(norm_fib_lens(:,n));
    v_max = 10*opt_fib_len(n-1);
    FV = Thelen2003_Force_Velocity(fib_vels(:,n) / v_max);
    plot(crank_angles, FL.*FV,'DisplayName', colheaders{n});
end  

xlabel('Crank Angle [deg]')
ylabel('Normalized Active Force Capacity')

trial_name = ['S_{R,θ}=(',num2str(radius(1)),'m, ',num2str(theta(3)),'°)'];
title(trial_name,'FontWeight','normal')
xlim([0 360] + crank_angles(1))
ylim([0.4 1.6])
% show the downstroke of the leg between 45 and 135 deg
fill([45 45 135 135],[gax3.YLim flip(gax3.YLim)],'c','DisplayName','Downstroke', ...
    'FaceAlpha',0.1,'EdgeAlpha',0);
% show the upstroke of the leg between 225 and 315 deg
fill([225 225 315 315],[gax3.YLim flip(gax3.YLim)],'g','DisplayName','Upstroke', ...
    'FaceAlpha',0.1,'EdgeAlpha',0);
% ------------------------------------------------------------------------
% adjust figures for clarity
% figure(fig3);
fig3.Units = 'normalized';
% fig1.OuterPosition = [0.000    0.1    0.90    0.85];
fig3.OuterPosition(2) = 0.20;
fig3.OuterPosition(3) = 0.60;
fig3.OuterPosition(4) = 0.70;
tile_3.InnerPosition = [0.07    0.15    0.750    0.75];
lgd_3 = legend(gax3,'Location','northwest','Interpreter','none','FontSize',fs);
%% ------------------------------------------------------------------------
fig4 = figure(4); clf;
fig4.Name = 'MEER for θ = 108°, R = 0.8196 m';
colororder([0 0 0; 0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1])
% figure 4 plotting -------------------------------------------
hold on; box on; grid on;
gax4 = gca;
gax4.FontSize = fs;   

saddle_pos = ['S_{R,θ} = (',num2str(radius(1)),'m, ',num2str(theta(3)),'°)'];        
% metabolics from the metabolics reporter and crank angle
[metabolics_report, crank_angles] = get_metabolics(theta(3),radius(1));
metabolics = metabolics_report.data;
colheaders = metabolics_report.colheaders;

% indices for muscles of the leg (columns in [metabolics])
meta_index = [2, 4, 5, 6, 7];
        
for mi = meta_index
    smooth_metabolics = smoothdata(metabolics(:,mi),'movmean',50);
    plot(crank_angles,smooth_metabolics,'DisplayName',colheaders{mi});
end

smooth_total = smoothdata(metabolics(:,2),'movmean',30);
ylim([0 max(smooth_total)])
% show the downstroke of the leg between 45 and 135 deg
fill([45 45 135 135],[gax4.YLim flip(gax4.YLim)],'c','DisplayName','Downstroke', ...
    'FaceAlpha',0.1,'EdgeAlpha',0);
% show the upstroke of the leg between 225 and 315 deg
fill([225 225 315 315],[gax4.YLim flip(gax4.YLim)],'g','DisplayName','Upstroke', ...
    'FaceAlpha',0.1,'EdgeAlpha',0);

xlabel('Crank Angle [deg]')
ylabel('Metabolic Energy Expenditure Rate [W]')
title(saddle_pos,'FontWeight','normal');
% adjust figures for clarity
fig4.Units = 'normalized';
fig4.OuterPosition(2) = 0.20;
fig4.OuterPosition(3) = 0.60;
fig4.OuterPosition(4) = 0.70;
lgd_4 = legend(gax4,'Location','northeast','Interpreter','none','FontSize',14);
%% ------------------------------------------------------------------------
fig6 = figure(6); clf;
fig6.Units = 'normalized';
fig6.OuterPosition(1) = 0.02;
fig6.Name = 'Metabolics w.r.t. Crank Angle';
tile_6 = tiledlayout(2,3,'Padding','compact');
colororder([0 0 0; 0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1])
            
fig7 = figure(7); clf;
fig7.Units = 'normalized';
fig7.OuterPosition(1) = 0.02;
% fig7.Name = 'Metabolics for Vastus w.r.t. Crank Angle';
fig7.Name = 'Metabolics for Biceps Femoris LH w.r.t. Crank Angle';
colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])
k = 1;
mean_MEER = zeros([length(theta), length(radius)]);
trapz_MEER = zeros([length(theta), length(radius)]);
peak_MEER = zeros([length(theta), length(radius)]);

for ri = 1:length(radius)
    for ti = 1:length(theta)
        saddle_pos = ['S_{R,θ} = (',num2str(radius(ri)),'m, ',num2str(theta(ti)),'°)'];
        % metabolics from the metabolics reporter and crank angle
        [metabolics_report, crank_angles] = get_metabolics(theta(ti),radius(ri));
        metabolics = metabolics_report.data;
        colheaders = metabolics_report.colheaders;
        % store for "parachute" plot
        P_mean = mean(metabolics(:,2));
        E = trapz(metabolics(:,1), metabolics(:,2));
        mean_MEER(ti,ri) = P_mean;
%         fprintf(['For Trial ', saddle_pos, '\nMean MEER-kat = %.4g W\n'], P_mean);
        trapz_MEER(ti,ri) = E;
        peak_MEER(ti,ri) = max(metabolics(:,2));
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

        smooth_total = smoothdata(metabolics(:,2),'movmean',30);
        ylim([0 max(smooth_total)])
        % show the downstroke of the leg between 45 and 135 deg
        fill([45 45 135 135],[gax6.YLim flip(gax6.YLim)],'c','DisplayName','Downstroke', ...
            'FaceAlpha',0.1,'EdgeAlpha',0);
        % show the upstroke of the leg between 225 and 315 deg
        fill([225 225 315 315],[gax6.YLim flip(gax6.YLim)],'g','DisplayName','Upstroke', ...
            'FaceAlpha',0.1,'EdgeAlpha',0);
        if k == 5
            xlabel('Crank Angle [deg]')
        end
        if k == 4
            ylabel('Metabolic Energy Expenditure Rate [W]')
            gax6.YLabel.Position(1) = -50;
            gax6.YLabel.Position(2) = 60;
        end

        title(saddle_pos,'FontWeight','normal');
        if ri == 1
        % figure 7 plotting -------------------------------------------
            figure(fig7);
            hold on; box on; grid on;
            gax7 = gca;
            gax7.FontSize = fs;
            trial_name = ['S_{R,θ}=(',num2str(radius(ri)),'m, ',num2str(theta(ti)),'°)'];
            smooth_vast = smoothdata(metabolics(:,7),'movmean',2);
            smooth_bifemlh = smoothdata(metabolics(:,4),'movmean',2);
            
            plot(crank_angles,smooth_vast,'DisplayName',trial_name);
%             plot(crank_angles,smooth_bifemlh,'DisplayName',trial_name);
            
            xlim(crank_angles(1) + [0, 360]);
            legend('Location','best');
            xlabel('Crank Angle [deg]');
            ylabel('Metabolic Energy Expenditure Rate [W]')
            title('MEER for Vastus Intermedius','FontWeight','normal')
%             title('MEER for Biceps Femoris LH','FontWeight','normal')
            
            avg_meer_vas = mean(smooth_vast);
            fprintf([trial_name,': P_avg_vast = %.5g W\n'],avg_meer_vas)

            avg_meer_bifemlh = mean(smooth_bifemlh);
%             fprintf([trial_name,': P_avg_vast = %.5g W\n'],avg_meer_bifemlh)
        
        end
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
% adjust figures for clarity
fig6.Units = 'normalized';
% fig1.OuterPosition = [0.000    0.1    0.90    0.85];
fig6.OuterPosition(2) = 0.10;
fig6.OuterPosition(3) = 0.85;
fig6.OuterPosition(4) = 0.75;
tile_6.InnerPosition = [0.05    0.12    0.7    0.80];
lgd_6 = legend(gax6,'Interpreter','none','FontSize',fs);
lgd_6.Position = [0.975 0.30 0.36 0.40];

% figure(fig7);
fig7.Units = 'normalized';
% fig2.OuterPosition = [0.000    0.1    0.90    0.85];
fig7.OuterPosition(2) = 0.1;
fig7.OuterPosition(3) = 0.70;
fig7.OuterPosition(4) = 0.75;
%% ------------------------------------------------------------------------
fig5 = figure(5); clf;
fig5.Units = 'normalized';
fig5.OuterPosition(1) = 0.02;
fig5.Name = 'Mean Total Metabolics for CMC Trials';
% fig5.Name = 'Peak Metabolic Energy for CMC Trials';
% tile_5 = tiledlayout(1);
colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1; 0 0.5 0])

% plotting 3D bar graph
mars = bar3(mean_MEER);
% mars = bar3(peak_MEER);
for k = 1:length(mars(:))
    zdata = mars(k).ZData;
    mars(k).CData = zdata;
    mars(k).FaceColor = 'interp';
end
cb = colorbar('Location','eastoutside');
cb.Label.String = 'P_{avg} [W]';
% cb.Label.String = 'E_{total metabolic} [J]';
% cb.Label.String = 'P_{peak} [W]';
cb.Label.FontSize = fs;
% zticks([])
yticklabels(theta)
xticklabels(radius)
zlabel('P_{avg} [W]')
% zlabel('E_{total metabolic} [J]')
% zlabel('P_{peak} [W]')
view(-120, 10)
box on; grid on;
colormap jet
gax5 = gca;
gax5.FontSize = fs;
ylabel('Seat Post Angle θ [deg]');
xlabel('Seat Post Height R [m]');
title('Full-Cycle Average MEER P_{avg} vs Saddle Position S_{R,θ}')
% title('Total Metabolic Energy E_{total metabolic} vs Saddle Position S_{θ,r}')
% title('Peak MEER P_{peak} vs Saddle Position S_{θ,r}')

% -------------------------------------------------------------------------
% adjust figures for clarity
fig5.Units = 'normalized';
fig5.OuterPosition(2) = 0.25;
fig5.OuterPosition(3) = 0.55;
fig5.OuterPosition(4) = 0.77;

% tile_5.InnerPosition = [0.05 0.15 0.8 0.75];
% cb.Position(1) = 0.9;
