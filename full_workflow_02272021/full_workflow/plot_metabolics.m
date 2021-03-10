%% ------------------------------------------------------------------------
% Fetch the metabolic output from the CMC simulation trials for all
% selected saddle positions

% if David Gonzalez is running this code on his machine, this block
% automatically moves into the correct folder
if startsWith(pwd, 'C:\Users\david')
    cd('C:\Users\david\GitHub\spec-opensim\full_workflow_02272021\full_workflow');
end

% Current 8 CMC trials as of 10:00 pm 2/28/2021
Sx = [-0.11 -0.1 -0.09];
Sy = [-0.04 -0.05 -0.06];

P_tot_mean = zeros([length(Sx), length(Sy)]);
time = cell({});
biceps_fem_lh = cell({});
biceps_fem_sh = cell({});
glut_max2 = cell({});
vas_int = cell({});
k = 1; % trial number - helps with figure windows if plotting = 1
plotting = 1;
printing = 1;

x_offset = -0.126;
y_offset = 0.84999999999999998;
for j = 1:length(Sy)
    for i = 1:length(Sx)
        % NO DATA FOR THIS SADDLE POSITION
        % x = -0.11, y = -0.04
        if Sx(i)==-0.11 && (Sy(j)== -0.04)
            disp('SKIPPING THIS TRIAL')
        else
            plotting = (Sx(i)==-0.09 && Sy(j)==-0.05);
            [t, ham_lh, ham_sh, glut, vast, P] = get_sum_total_metabolic_rate(Sx(i), Sy(j), k, plotting);
            time{k} = t;
            biceps_fem_lh{k} = ham_lh;
            biceps_fem_sh{k} = ham_sh;
            glut_max2{k} = glut;
            vas_int{k} = vast;
            P_tot_mean(i,j) = P;
            if printing
                fprintf('Trial %i\nP_tot_mean(Sx = %.3f, Sy = %.3f) = %.4g\n\n',...
                    k,Sx(i)+x_offset,Sy(j)+y_offset,P_tot_mean(i,j))
                % fprintf('Size of time vector %i\n\n', length(time))
            end
            k = k + 1;
        end
    end
end
%% ------------------------------------------------------------------------
% Plot the sum total metabolic rates from all of the trials in a
% (hopefully) parachute shape
x_offset = -0.126;
y_offset = 0.84999999999999998;
[Sx_mesh, Sy_mesh] = meshgrid(Sx+x_offset, Sy+y_offset);
P_tot_mean(P_tot_mean <= 0) = NaN;
fs = 16;

figure(k+1); clf; box on; grid on; hold on;
set(gcf,'Name','Sum Total Metabolics')
set(gca,'FontSize',fs)

s = surf(Sx_mesh,Sy_mesh,P_tot_mean','Marker','s','MarkerSize',18,'MarkerFaceColor','g');
s.FaceColor = 'interp';
cb = colorbar('Location','eastoutside');
cb.Label.String = 'P_{mean metabolic} [W]';
cb.Label.FontSize = fs;
xticks(-0.236:0.01:-0.216)
yticks(0.79:0.01:0.81)
zticks([])
axis([-0.237 -0.215 0.789 0.811 0 inf])
view(-115, 25)
colormap autumn

xlabel('Saddle X-Position [m]');
ylabel('Saddle Y-Position [m]');
% zlabel('Metabolic Energy Expenditure Rate [W]');

title('Total Mean Metabolics P_{mean metabolic} vs Saddle Position S_{x,y}')

figure(k+2); clf; box on; grid on; hold on;
set(gcf,'Name','Vastus Intermedius Metabolics')
set(gca,'FontSize',fs)
set(groot,'DefaultLineLineWidth', 1.5);
plot(time{1}, vas_int{1}, 'DisplayName', 'S_{x,y} = (-0.226,0.81) m')
plot(time{2}, vas_int{2}, 'DisplayName', 'S_{x,y} = (-0.216,0.81) m')
plot(time{3}, vas_int{3}, 'DisplayName', 'S_{x,y} = (-0.236,0.80) m')
plot(time{4}, vas_int{4}, 'DisplayName', 'S_{x,y} = (-0.226,0.80) m')
plot(time{5}, vas_int{5}, 'DisplayName', 'S_{x,y} = (-0.216,0.80) m')
plot(time{6}, vas_int{6}, 'DisplayName', 'S_{x,y} = (-0.236,0.79) m')
plot(time{7}, vas_int{7}, 'DisplayName', 'S_{x,y} = (-0.226,0.79) m')
plot(time{8}, vas_int{8}, 'DisplayName', 'S_{x,y} = (-0.216,0.79) m')
title('Vastus Intermedius Metabolic Expenditure Rate for all trials')
ylabel('Metabolic Energy Expenditure Rate [W]')
xlabel('Time [s]')
xticks(0:0.1:1)
legend('Location','best','FontSize',fs,'AutoUpdate','off')
axis([0 0.75 0 inf])
hold off;