clear all;
clc;

% preprocessing joint data from ME 485 model
degrees_mot = importdata('cyclingleg_states_degrees.mot', '\t');

% a struct with fields data, textdata, and colheaders
mot_data = degrees_mot.data;
mot_text = degrees_mot.textdata;
mot_headers = degrees_mot.colheaders';

% first columnn of mot_data is the time series
time = mot_data(:,1);
% second column of mot_data is the crank angle
crank_col = find(strcmp(mot_headers, 'bb/crank_angle/value'));
% searches for what column in mot_data these joint angles are written
hip_col = find(strcmp(mot_headers, 'hip_r/hip_angle_r/value'));
knee_col = find(strcmp(mot_headers, 'knee_r/knee_angle_r/value'));
ankle_col = find(strcmp(mot_headers, 'ankle_r/ankle_angle_r/value'));
% accesses joint angles from mot_data
crank_angle_raw = mot_data(:,crank_col);

% modified crank angle data to match reference frame of literature - cc
crank_angle_mod = mod(crank_angle_raw*-1, 360);
cycle_start_index = 522;
cycle_end_index = 1176;
crank_angle = crank_angle_mod(cycle_start_index:cycle_end_index);
time_1cycle = time(cycle_start_index:cycle_end_index)-0.414; % this is the time at index 522

hip_r_angle_raw = mot_data(:,hip_col);
knee_r_angle_raw = mot_data(:,knee_col);
ankle_r_angle_raw = mot_data(:,ankle_col);

% modified joint angle data to match reference frame of literature - cc
hip_r_angle = 90-hip_r_angle_raw;
knee_r_angle = 180+knee_r_angle_raw;
ankle_r_angle =90+ankle_r_angle_raw;

% preprocessing the  2010 Bini paper data
bini_data = readtable('bini_joints.csv');

crank_angle_b = table2array(bini_data(:,1));
hip_r_angle_b = table2array(bini_data(:,2));
knee_r_angle_b = table2array(bini_data(:,3));
ankle_r_angle_b = table2array(bini_data(:,4));

% preprocessing the 2014 Bini paper data
bini_data_2 = readtable('bini_joints_2.csv');

crank_angle_b2 = table2array(bini_data_2(:,1));
hip_r_angle_b2 = table2array(bini_data_2(:,2));
knee_r_angle_b2 = 180 - table2array(bini_data_2(:,3));
ankle_r_angle_b2 = table2array(bini_data_2(:,4));

% Decision point: using these angles from these sources to formulate our
% kinematics file

% using Bini 2010 paper hip angles
hip_angle = hip_r_angle_b;

% using Bini 2014 paper knee angles
knee_angle = knee_r_angle_b2;

% using Bini 2014 paper ankle angles
ankle_angle = ankle_r_angle_b2;

% grabbing preprocessed time data (reduction from 655 points --> 481)
new_time = table2array(readtable('reduced_time.csv'));

% interpolates hip, knee, and ankle angles over the whole 360 degrees of a
% crank rotation
x = crank_angle_b2;
v = [hip_angle knee_angle ankle_angle];
xq = 0:0.1:360;
vq = interp1(x,v,xq,'pchip');

% plotting the joint angles vs crank angle
fig_4 = figure('Name', 'Crank vs Joint Angles');
clf; box on; grid on; hold on;
xlabel('Crank Angle [deg]')
ylabel('Joint Angle [deg]')
ylim([0 360])
xlim([0 360])
legend('Hip_C', 'Knee_C', 'Ankle_C')

set(groot,'defaultLineLineWidth',1.5)
plot(transpose(xq), vq(:,1), 'Color', [0.8 0 0], 'DisplayName', 'Hip_C');
plot(transpose(xq), vq(:,2), 'Color', [0.8 0.8 0], 'DisplayName', 'Knee_C');
plot(transpose(xq), vq(:,3), 'Color', [0.8 0.8 0.8], 'DisplayName', 'Ankle_C');
hold off;

% plotting the joint angles vs time, imposing cadence of 80 RPM.
% 360deg/80rpm = .75 sec per revolution of crank
fig_6 = figure('Name', 'Time vs Joint Angles');
clf; box on; grid on; hold on;
xlabel('Time [sec]')
ylabel('Joint Angle [deg]')
ylim([0 360])
xlim([0 .75])
legend('Hip_C', 'Knee_C', 'Ankle_C')
x = linspace(0,0.75, length(vq))

set(groot,'defaultLineLineWidth',1.5)
plot(x, vq(:,1), 'Color', [1 0 0], 'DisplayName', 'Hip_C');
plot(x, vq(:,2), 'Color', [1 1 0], 'DisplayName', 'Knee_C');
plot(x, vq(:,3), 'Color', [0.8 1 1], 'DisplayName', 'Ankle_C');
hold off;

% Plotting Time vs Joint Angles, trying to factor in angular acceleration
% of joints through time. Conclusion: not doing this, inacurrate joint
% angles
% x = new_time;
% v = [hip_angle knee_angle ankle_angle];
% xq = 0:0.001:0.5371;
% vq = interp1(x,v,xq,'pchip');
% 
% fig_5 = figure('Name', 'Time vs Joint Angles');
% clf; box on; grid on; hold on;
% xlabel('Time [sec]');
% ylabel('Joint Angle [deg]');
% ylim([0 360]);
% xlim([0 0.5371]);
% legend('Hip_T', 'Knee_T', 'Ankle_T');
% 
% plot(transpose(xq), vq(:,1), 'Color', [1 0 0], 'DisplayName', 'Hip_T');
% plot(transpose(xq), vq(:,2), 'Color', [1 1 0], 'DisplayName', 'Knee_T');
% plot(transpose(xq), vq(:,3), 'Color', [0 0 1], 'DisplayName', 'Ankle_T');
% hold off

%% Writing to excel file
curr_path = pwd;

excel = 'coordinates.xlsx';
header_1 = {'Time', 'Hip', 'Knee', 'Ankle'};
writecell(header_1, excel, ...
    'WriteMode','overwritesheet','AutoFitWidth', 1);
writecell(num2cell([transpose(x), vq(:,1), vq(:,2), vq(:,3)])...
    ,excel,'WriteMode','append');