% % move to the correct directory
% degrees_dir = dir('**/cyclingleg_states_degrees*.mot');
% cd(degrees_dir.folder);
% move to the correct directory
while ~endsWith(pwd, 'docman-cyclingmodel-1812')
    cd ..
    spec_dir = dir('**/cyclingleg_states_degrees*.mot');
    cd(spec_dir.folder);
end
degrees_mot = importdata('cyclingleg_states_degrees.mot', '\t');
% a struct with fields data, textdata, and colheaders
mot_data = degrees_mot.data;
mot_text = degrees_mot.textdata;
mot_headers = degrees_mot.colheaders';

% first columnn of mot_data is the time series
time = mot_data(:,1);
% searches for what column in mot_data these joint angles are written
hip_col = find(strcmp(mot_headers, 'hip_r/hip_angle_r/value'));
knee_col = find(strcmp(mot_headers, 'knee_r/knee_angle_r/value'));
ankle_col = find(strcmp(mot_headers, 'ankle_r/ankle_angle_r/value'));
% accesses joint angles from mot_data
hip_r_angle = mot_data(:,hip_col);
knee_r_angle = mot_data(:,knee_col);
ankle_r_angle = mot_data(:,ankle_col);
%%
% plotting
if ishandle(1)
    close(figure(1))
end
fig_1 = figure('Name', 'Joint Angles of Simple Model');
clf; box on; grid on; hold on;
xlabel('Time [s]')
xticks(0:0.25:3.5)
ylabel('Joint Angle [deg]')
set(groot,'defaultLineLineWidth',1.5)
plot(time, hip_r_angle, 'Color', [0.8 0 0], 'DisplayName', 'Hip');
plot(time, knee_r_angle, 'Color', [0 0.2 1], 'DisplayName', 'Knee');
plot(time, ankle_r_angle, 'Color', [0 0.8 0], 'DisplayName', 'Ankle');
legend('Location', 'best', 'AutoUpdate', 'off');
plot(time, 0*time, '--k')
hold off;
%%
% export joints angles to excel file for easy reading
curr_path = pwd;

excel = 'Hip, Knee, Ankle Joint Angles.xlsx';
header_1 = {'Time', 'Hip', 'Knee', 'Ankle'};
writecell(header_1, excel,'Sheet','Joint Angles',...
    'WriteMode','overwritesheet','AutoFitWidth', 1);
writecell(num2cell([time, hip_r_angle, knee_r_angle, ankle_r_angle])...
    ,excel,'Sheet','Joint Angles','WriteMode','append')

header_2 = {'Value', 'Hip', 'Knee', 'Ankle'};
writecell(header_2, excel,'Sheet','Min-Mean-Max Values',...
    'WriteMode','overwritesheet','AutoFitWidth', 1);
maxs = {'Max', max(hip_r_angle), max(knee_r_angle), max(ankle_r_angle)};
means = {'Mean', mean(hip_r_angle), mean(knee_r_angle), mean(ankle_r_angle)};
mins = {'Min', min(hip_r_angle), min(knee_r_angle), min(ankle_r_angle)};
writecell(maxs, excel,'Sheet','Min-Mean-Max Values','WriteMode','append');
writecell(means, excel,'Sheet','Min-Mean-Max Values','WriteMode','append');
writecell(mins, excel,'Sheet','Min-Mean-Max Values','WriteMode','append');