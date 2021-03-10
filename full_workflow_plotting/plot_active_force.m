% Fetch the muscle states (length and velocity) for SFK trials for all
% selected saddle positions

% if David Gonzalez is running this code on his machine, this block
% automatically moves into the correct folder
if startsWith(pwd, 'C:\Users\david')
    cd('C:\Users\david\GitHub\spec-opensim\full_workflow_plotting');
end

% Current 8 CMC trials as of 10:00 pm 2/28/2021
Sx = [-0.11 -0.1 -0.09];
Sy = [-0.06 -0.05 -0.04];
theta = [95 98 101];
% optimal fiber lengths as define in the .osim for all muscles
opt_fib_len = [0.12823851; 0.20083733; 0.16291391; 0.12617328; 0.09; 0.098];
% maximum contraction velocities as defined in the .osim for muscles
fib_max_vel = [10; 10; 10; 10; 10; 10]; 

%% ------------------------------------------------------------------------
k = 1;
fig1 = figure(1); clf;
fig1.Name = 'Active force w.r.t. Crank Angle';
tile_1 = tiledlayout(3,3,'Padding','Compact');
set(groot,'DefaultLineLineWidth', 1.4);

fig2 = figure(2); clf;
fig2.Name = 'Active force w.r.t. Time';
tile_2 = tiledlayout(3,3,'Padding','Compact');
% plotting figures 1 and 2 using cartesian coordinates for saddle position
for j = 1:length(Sy)
    for i = 1:length(Sx)
        % NO DATA FOR THIS SADDLE POSITION
        % x = -0.11, y = -0.04
        saddle_pos = ['Sxy = (',num2str(Sx(i)),',',num2str(Sy(j)),')'];
        
        if Sx(i)==-0.11 && (Sy(j)== -0.04)
            disp(['SKIPPING THIS TRIAL ', saddle_pos])
        else
            % capture normalized muscle fiber lengths and muscle
            % fiber velocities from the Muscle Analysis reporter for the
            % specified trial denoted by Sx(i) and Sy(j)
            [MA_norm_fib_lens, MA_fib_vels, crank_angles] = get_muscle_states(Sx(i),Sy(j));
            norm_fib_lens = MA_norm_fib_lens.data;
            fib_vels = MA_fib_vels.data;
            colheaders = MA_norm_fib_lens.colheaders;
            time = norm_fib_lens(:,1); 
            % smooth the data with movmean
            window_size = 500;
            fib_vels = smoothdata(fib_vels,'movmean',window_size);
            
            musc_index = [2,3,4,5];%[2,3,5];
            % figure 1 plotting -------------------------------------------
            figure(fig1);
            colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1])
            nexttile(k);
            hold on; box on; grid on;
            for n = musc_index
                FL = Thelen2003_Active_Force_Length(norm_fib_lens(:,n));
                v_max = 10*opt_fib_len(n-1);
                FV = Thelen2003_Force_Velocity(fib_vels(:,n) / v_max);
                plot(crank_angles, FL.*FV,'DisplayName', colheaders{n});
            end  
            xlabel('Crank Angle [deg]')
            title(['Norm. Active Force (F^L\timesF^V): ',saddle_pos],'FontWeight','normal')
            xlim([0 360] + crank_angles(1))
            ylim([0.4 1.6])
            xticks([0:45:360] + round(crank_angles(1)))
            % show the downstroke of the leg between 45 and 135 deg
            fill([45 45 135 135],[0 2 2 0],'c','DisplayName','Downstroke', ...
                'FaceAlpha',0.1,'EdgeAlpha',0);
            % show the upstroke of the leg between 225 and 315 deg
            fill([225 225 315 315],[0 2 2 0],'g','DisplayName','Upstroke', ...
                'FaceAlpha',0.1,'EdgeAlpha',0);
            set(gca,'FontSize',12);
            gax1 = gca;
            
            % figure 2 plotting -------------------------------------------
            figure(fig2);
            colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1])
            nexttile(k); 
            hold on; box on; grid on;
            for n = musc_index
                FL = Thelen2003_Active_Force_Length(norm_fib_lens(:,n));
                v_max = 10*opt_fib_len(n-1);
                FV = Thelen2003_Force_Velocity(fib_vels(:,n) / v_max);
                plot(time, FL.*FV,'DisplayName', colheaders{n});
            end 
            xlabel('Time [s]')
            title(['Norm. Active Force (F^L\timesF^V): ',saddle_pos],'FontWeight','normal')
            xlim([0 0.75])
            ylim([0.4 1.6])
            xticks(0:0.15:0.75)
            set(gca,'FontSize',12);
            gax2 = gca;
        end
        k = k + 1; % increase trial index
    end
end
%% ------------------------------------------------------------------------
% adjust figures for clarity
figure(fig1);
fig1.Units = 'normalized';
% fig1.OuterPosition = [0.000    0.1    0.90    0.85];
fig1.OuterPosition(2) = 0.1;
fig1.OuterPosition(3) = 0.90;
fig1.OuterPosition(4) = 0.85;
tile_1.InnerPosition = [0.035    0.08    0.7750    0.85];
lgd_1 = legend(gax1,'Interpreter','none','FontSize',14);
lgd_1.Position = [1.01 0.325 0.175 0.30];

figure(fig2);
fig2.Units = 'normalized';
% fig2.OuterPosition = [0.000    0.1    0.90    0.85];
fig2.OuterPosition(2) = 0.1;
fig2.OuterPosition(3) = 0.90;
fig2.OuterPosition(4) = 0.85;
tile_2.InnerPosition = [0.035    0.08    0.7750    0.85];
lgd_2 = legend(gax2,'Interpreter','none','FontSize',14);
lgd_2.Position = [1.01 0.325 0.175 0.30];
%% ------------------------------------------------------------------------
% plotting figure 3 for polar coordinate saddle position
fig3 = figure(3); clf;
fig3.Name = 'Active force w.r.t. Crank Angle with Polar Saddle Pos';
tile_3 = tiledlayout(1,3,'Padding','compact');
for p = 1:length(theta)
    u = theta(p);
    [MA_norm_fib_lens, MA_fib_vels, crank_angles] = get_muscle_states_polar(u);
    norm_fib_lens = MA_norm_fib_lens.data;
    fib_vels = MA_fib_vels.data;
    colheaders = MA_norm_fib_lens.colheaders;
    time = norm_fib_lens(:,1); 
    % smooth the data with movmean
    window_size = 500;
    fib_vels = smoothdata(fib_vels,'movmean',window_size);
            
    musc_index = [2,3,4,5];%[2,3,5];
    % figure 3 plotting -------------------------------------------
    figure(fig3);
    colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
        0 0.7 0.8; 1 0.5 0; 0.5 0 1])
    nexttile(p);
    hold on; box on; grid on;
    for n = musc_index
        FL = Thelen2003_Active_Force_Length(norm_fib_lens(:,n));
        v_max = 10*opt_fib_len(n-1);
        FV = Thelen2003_Force_Velocity(fib_vels(:,n) / v_max);
        plot(crank_angles, FL.*FV,'DisplayName', colheaders{n});
    end  
    xlabel('Crank Angle [deg]')
    title(['Norm. Active Force (F^L\timesF^V): \theta = ',num2str(u),'°'],...
        'FontWeight','normal')
    xlim([0 360] + crank_angles(1))
    ylim([0.4 1.6])
    xticks([0:45:360] + round(crank_angles(1)))
    % show the downstroke of the leg between 45 and 135 deg
    fill([45 45 135 135],[0 2 2 0],'c','DisplayName','Downstroke', ...
        'FaceAlpha',0.1,'EdgeAlpha',0);
    % show the upstroke of the leg between 225 and 315 deg
    fill([225 225 315 315],[0 2 2 0],'g','DisplayName','Upstroke', ...
        'FaceAlpha',0.1,'EdgeAlpha',0);
    set(gca,'FontSize',16);
    gax3 = gca;
end
%% ------------------------------------------------------------------------
% adjust figures for clarity
figure(fig3);
fig3.Units = 'normalized';
% fig1.OuterPosition = [0.000    0.1    0.90    0.85];
fig3.OuterPosition(2) = 0.20;
fig3.OuterPosition(3) = 0.90;
fig3.OuterPosition(4) = 0.60;
tile_3.InnerPosition = [0.035    0.15    0.7750    0.75];
lgd_3 = legend(gax3,'Interpreter','none','FontSize',14);
lgd_3.Position = [1 0.325 0.15 0.4];