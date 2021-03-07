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

% optimal fiber lengths as define in the .osim for all muscles
opt_fib_len = [0.12823851; 0.20083733; 0.16291391; 0.12617328; 0.09; 0.098];
% maximum contraction velocities as defined in the .osim for muscles
fib_max_vel = [10; 10; 10; 10; 10; 10]; 
%% ------------------------------------------------------------------------
k = 1; % trial number - helps with figure windows if plotting = 1
figure(1); clf; hold on; box on;
for j = 1:length(Sy)
    for i = 1:length(Sx)
        % NO DATA FOR THIS SADDLE POSITION
        % x = -0.11, y = -0.04
        if Sx(i)==-0.11 && (Sy(j)== -0.04)
            disp('SKIPPING THIS TRIAL')
        else
            % capture normalized muscle fiber lengths and muscle
            % fiber velocities from the Muscle Analysis reporter for the
            % specified trial denoted by Sx(i) and Sy(j)
            [MA_norm_fib_lens, MA_fib_vels, MA_penn_angles] = get_muscle_states(Sx(i), Sy(j));
            norm_fib_lens = MA_norm_fib_lens.data;
            fib_vels = MA_fib_vels.data;
            penn_angles = MA_penn_angles.data; % might be useful later
            colheaders = MA_norm_fib_lens.colheaders;
            % smooth the data with movmean
            window_size = 500;
            fib_vels = smoothdata(fib_vels,'movmean',window_size);
            
            % set color order to be similar to OpenSim's native colororder
            colororder([0.8 0 0; 0 0 0.8; 0 0.8 0; 1 0 0.8; 
                0 0.7 0.8; 1 0.5 0; 0.5 0 1])
            saddle_pos = ['Sxy = (',num2str(Sx(i)),',',num2str(Sy(j)),')'];
            subplot(3,3,k); hold on; box on; grid on;
            % time data for normalized fiber lengths
            t = norm_fib_lens(:,1);            
            for n = 2:size(norm_fib_lens,2)
                FL = Thelen2003_Active_Force_Length(norm_fib_lens(:,n));
                v_max = 10*opt_fib_len(n-1);
                FV = Thelen2003_Force_Velocity(fib_vels(:,n) / v_max);
                plot(t, FL.*FV, 'DisplayName', colheaders{n});
                lgd = legend('Location','bestoutside','Interpreter','none');
                xlim([0 0.75])
                title(['Normalized Active Force (F^L * F^V): ',saddle_pos],'FontWeight','normal')
            end
            k = k + 1; % increase trial index
        end
    end
end