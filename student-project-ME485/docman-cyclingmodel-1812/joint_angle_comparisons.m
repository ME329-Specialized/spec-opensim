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

% first plot: ME485 vs 2010 Bini paper
if ishandle(2)
    close(figure(2))
end
%fig_2 = figure('Name', 'Joint Angles vs Crank Angle - ME 485 vs 2010');
fig_2 = figure('Name', 'Time vs Crank Angle Relationship');
clf; box on; grid on; hold on;
xlabel('Time [sec]')
ylabel('Crank Angle [deg]')
xlim([0 0.55])
ylim([0 360])

set(groot,'defaultLineLineWidth',1.5)
plot(time_1cycle, crank_angle, 'Color', [0.8 0 0], 'DisplayName', 'Relationship');
% plot(crank_angle, knee_r_angle(cycle_start_index:cycle_end_index), 'Color', [0 0.2 1], 'DisplayName', 'Knee');
% plot(crank_angle, ankle_r_angle(cycle_start_index:cycle_end_index), 'Color', [0 0.8 0], 'DisplayName', 'Ankle');
% 
% plot(crank_angle_b, hip_r_angle_b, 'Color', [1 0 1], 'DisplayName', 'Hip_b');
% plot(crank_angle_b, knee_r_angle_b, 'Color', [0 1 1], 'DisplayName', 'Knee_b');
% plot(crank_angle_b, ankle_r_angle_b, 'Color', [1 1 0], 'DisplayName', 'Ankle_b');
% 
% legend('Location', 'best', 'AutoUpdate', 'off');
% 
% hold off;

% second plot: 2014 Bini paper vs 2010 Bini paper
% fig_3 = figure('Name', 'Joint Angles vs Crank Angle - ME485 vs 2010 vs 2014');
% clf; box on; grid on; hold on;
% xlabel('Crank Angle [deg]')
% ylabel('Joint Angle [deg]')

%set(groot,'defaultLineLineWidth',1.5)
% plot(crank_angle_b, hip_r_angle_b, 'Color', [0.8 0 0], 'DisplayName', 'Hip_1_0');
% plot(crank_angle_b, knee_r_angle_b, 'Color', [0 0.2 1], 'DisplayName', 'Knee_1_0');
% plot(crank_angle_b, ankle_r_angle_b, 'Color', [0 0.8 0], 'DisplayName', 'Ankle_1_0');
% 
% plot(crank_angle_b2, hip_r_angle_b2, 'Color', [1 0 1], 'DisplayName', 'Hip_1_4');
% plot(crank_angle_b2, knee_r_angle_b2, 'Color', [0 1 1], 'DisplayName', 'Knee_1_4');
% plot(crank_angle_b2, ankle_r_angle_b2, 'Color', [1 1 0], 'DisplayName', 'Ankle_1_4');

%plot(crank_angle, hip_r_angle(cycle_start_index:cycle_end_index), 'DisplayName', 'Hip');
%plot(crank_angle, knee_r_angle(cycle_start_index:cycle_end_index), 'DisplayName', 'Knee');
%plot(crank_angle, ankle_r_angle(cycle_start_index:cycle_end_index), 'DisplayName', 'Ankle');

%plot(crank_angle_b, hip_r_angle_b, 'DisplayName', 'Hip_1_0');
%plot(crank_angle_b, knee_r_angle_b, 'DisplayName', 'Knee_1_0');
%plot(crank_angle_b, ankle_r_angle_b, 'DisplayName', 'Ankle_1_0');

%plot(crank_angle_b2, hip_r_angle_b2, 'DisplayName', 'Hip_1_4');
%plot(crank_angle_b2, knee_r_angle_b2, 'DisplayName', 'Knee_1_4');
%plot(crank_angle_b2, ankle_r_angle_b2, 'DisplayName', 'Ankle_1_4');

%legend('Hip', 'Knee', 'Ankle', 'Hip_1_0', 'Knee_1_0', 'Ankle_1_0', 'Hip_1_4', 'Knee_1_4', 'Ankle_1_4')
%legend('Ankle', 'Ankle_1_0', 'Ankle_1_4')
% legend('Location', 'best', 'AutoUpdate', 'off');

% using Bini 2010 paper hip angles
hip_angle = hip_r_angle_b;

% using Bini 2014 paper knee angles
knee_angle = knee_r_angle_b2;

% using Bini 2014 paper ankle angles
ankle_angle = ankle_r_angle_b2;

% interpolates hip, knee, and ankle angles over the whole 360 degrees of a
% crank rotation
x = crank_angle_b2;
v = [hip_angle knee_angle ankle_angle];
xq = 0:0.1:360;
vq = interp1(x,v,xq,'pchip');

new_time = zeros(length(xq), 1);
for i = 1:length(xq)
    c = xq(i)
    if c <= 150
        new_time(i) = 0.0014*c; % formula from linear trendline of crank angle vs time graph
    else
        new_time(i) = (5*10^(-8))*c^3 - (3*10^(-5))*c^2 + 0.0074*c - 0.3756; % formula from polynomial trendline of crank angle vs time graph
        
    end
end 
hold off;

% plotting the final joint angles vs time
fig_3 = figure('Name', 'Time vs Joint Angles');
clf; box on; grid on; hold on;
xlabel('Time [sec]')
ylabel('Joint Angle [deg]')
ylim([0 360])

set(groot,'defaultLineLineWidth',1.5)
plot(new_time, vq(:,1), 'Color', [0.8 0 0], 'DisplayName', 'Hip');
plot(new_time, vq(:,2), 'Color', [0.8 0.8 0], 'DisplayName', 'Knee');
plot(new_time, vq(:,3), 'Color', [0.8 0.8 0.8], 'DisplayName', 'Ankle');
%% export joints angles to excel file for easy reading
curr_path = pwd;

excel = 'coordinates.xlsx';
% header_1 = {'Crank', 'Hip', 'Knee', 'Ankle'};
header_1 = {'Time', 'Hip', 'Knee', 'Ankle'};
writecell(header_1, excel, ...
    'WriteMode','overwritesheet','AutoFitWidth', 1);
% writecell(num2cell([transpose(xq), vq(:,1), vq(:,2), vq(:,3)])...
%     ,excel,'WriteMode','append');
writecell(num2cell([new_time, vq(:,1), vq(:,2), vq(:,3)])...
    ,excel,'WriteMode','append');

% excel = 'Hip, Knee, Ankle Joint Angles.xlsx';
% header_1 = {'Time', 'Hip', 'Knee', 'Ankle'};
% writecell(header_1, excel,'Sheet','Joint Angles in Time',...
%     'WriteMode','overwritesheet','AutoFitWidth', 1);
% writecell(num2cell([time, hip_r_angle, knee_r_angle, ankle_r_angle])...
%     ,excel,'Sheet','Joint Angles in Time','WriteMode','append')
% 
% header_2 = {'Crank Angle', 'Hip', 'Knee', 'Ankle'};
% writecell(header_2, excel,'Sheet','Joint Angles in Crank Angle',...
%     'WriteMode','overwritesheet','AutoFitWidth', 1);
% writecell(num2cell([crank_angle_mod, hip_r_angle, knee_r_angle, ankle_r_angle])...
%     ,excel,'Sheet','Joint Angles in Crank Angle','WriteMode','append')
% 
% header_3 = {'Value', 'Hip', 'Knee', 'Ankle'};
% writecell(header_3, excel,'Sheet','Min-Mean-Max Values',...
%     'WriteMode','overwritesheet','AutoFitWidth', 1);
% maxs = {'Max', max(hip_r_angle), max(knee_r_angle), max(ankle_r_angle)};
% means = {'Mean', mean(hip_r_angle), mean(knee_r_angle), mean(ankle_r_angle)};
% mins = {'Min', min(hip_r_angle), min(knee_r_angle), min(ankle_r_angle)};
% writecell(maxs, excel,'Sheet','Min-Mean-Max Values','WriteMode','append');
% writecell(means, excel,'Sheet','Min-Mean-Max Values','WriteMode','append');
% writecell(mins, excel,'Sheet','Min-Mean-Max Values','WriteMode','append');