%% ------------------------------------------------------------------------
% Fetch the metabolic output from the CMC simulation trials for all
% selected saddle positions

% if David Gonzalez is running this code on his machine, this block
% automatically moves into the correct folder
if startsWith(pwd, 'C:\Users\david')
    cd('C:\Users\david\GitHub\spec-opensim\full_workflow_02272021\full_workflow');
end

% Current 6 CMC trials as of 4:52 pm 2/28/2021
Sx = [-0.1 -0.09 ];
Sy = [-0.04 -0.05 -0.06];

P_sum_total = zeros([length(Sx), length(Sy)]);
k = 1; % trial number - helps with figure windows if plotting = 1
plotting = 1;
printing = 1;
for j = 1:length(Sy)
    for i = 1:length(Sx)
        P_sum_total(i,j) = get_sum_total_metabolic_rate(Sx(i), Sy(j), k, plotting);
        if printing
            fprintf('Trial %i\nP_sum_total(Sx = %.2f, Sy = %.2f) = %.4g\n\n',k,Sx(i),Sy(j),P_sum_total(i,j))
        end
        k = k + 1;
    end
end
%% ------------------------------------------------------------------------
% Plot the sum total metabolic rates from all of the trials in a
% (hopefully) parachute shape

[Sx_mesh, Sy_mesh] = meshgrid(Sx, Sy);
figure(k+1); clf; box on; grid on;
surf(Sx_mesh,Sy_mesh,P_sum_total')
% bar3(P_sum_total)
colormap autumn
set(gca, 'FontSize', 14)

xlabel('Saddle X-Position [m]');
ylabel('Saddle Y-Position [m]');
zlabel('Metabolic Energy Expenditure Rate [W]');

title('Sum Total Metabolics P_{metabolic} vs Saddle Position S_{x,y}')
