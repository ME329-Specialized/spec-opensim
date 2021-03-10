%% ------------------------------------------------------------------------
% Fetch the muscle states (length and velocity) for SFK trials for all
% selected saddle positions

% if David Gonzalez is running this code on his machine, this block
% automatically moves into the correct folder
if startsWith(pwd, 'C:\Users\david')
    cd('C:\Users\david\GitHub\spec-opensim\full_workflow_02272021\full_workflow');
end

% Current 8 CMC trials as of 10:00 pm 2/28/2021
Sx = [-0.11 -0.1 -0.09];
Sy = [-0.06 -0.05 -0.04];

time = cell({});
biceps_fem_lh = cell({});
biceps_fem_sh = cell({});
glut_max2 = cell({});
vas_int = cell({});
k = 1; % trial number - helps with figure windows if plotting = 1
plotting = 1;
printing = 1;
for j = 1%:length(Sy)
    for i = 1%:length(Sx)
        % NO DATA FOR THIS SADDLE POSITION
        % x = -0.11, y = -0.04
        if Sx(i)==-0.11 && (Sy(j)== -0.04)
            disp('SKIPPING THIS TRIAL')
        else
%             [t, ham_lh, ham_sh, glut, vast, P] = get_sum_total_metabolic_rate(Sx(i), Sy(j), k, plotting);
            get_muscle_states(Sx(i), Sy(j), k, plotting);
%             time{k} = t;
%             biceps_fem_lh{k} = ham_lh;
%             biceps_fem_sh{k} = ham_sh;
%             glut_max2{k} = glut;
%             vas_int{k} = vast;
%             if printing
%                 fprintf('Trial %i\nSxy = (%.2f, %.2f) m = %.4g\n\n',k,Sx(i),Sy(j))
%             end
            k = k + 1;
        end
    end
end