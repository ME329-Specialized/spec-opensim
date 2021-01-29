pref = 'cyclingleg_PointKinematics_';
marker_names = {'RASI', 'LASI', 'RPSI', 'LPSI', 'RTHI', 'RKNE', ...
    'RTIB', 'RANK', 'RPED', 'RTOE'};
% pelvis[1,2,3,4], femur_r[5,6], tibia_r[6,7,8], foot[9,11]
suff = '_pos.sto';
x_pos = zeros(500, length(marker_names));
y_pos = zeros(500, length(marker_names));
z_pos = zeros(500, length(marker_names));
for m = 1:length(marker_names)
    name = marker_names{m};
    sto_file = [pref, name, suff];
    mark_m = importdata(sto_file, '\t');
    % a struct with fields data, textdata, and colheaders
    x_pos(:, m) = mark_m.data(1:500,2);
    y_pos(:, m) = mark_m.data(1:500,3);
    z_pos(:, m) = mark_m.data(1:500,4);
end
time = mark_m.data(1:500,1);
%%
figure(1); clf; hold on; box on; grid on;
view([30 30])
markers = scatter3(x_pos(1,:), y_pos(1,:), z_pos(1,:), ...
    'MarkerEdgeColor', [1 0 0.3], 'MarkerFaceColor', [1 0 0.3]);
pelvis = fill3(x_pos(1,[1 2 4 3]), y_pos(1,[1 2 4 3]), z_pos(1,[1 2 4 3]), ...
    [1 0.2 0.8], 'FaceAlpha', 0.5);
femur = plot3(x_pos(1,[1,6]), y_pos(1,[1,6]), z_pos(1,[1,6]), ...
    'Color', [0.9 0.2 0.2],'LineWidth', 10);
tibia = plot3(x_pos(1,[6,8]), y_pos(1,[6,8]), z_pos(1,[6,8]), ...
    'Color', [0.5 0.2 1],'LineWidth', 10);
foot = plot3(x_pos(1,[8,10]), y_pos(1,[8,10]), z_pos(1,[8,10]), ...
    'Color', [0 0.8 1],'LineWidth', 10);

plot3([0 1], [0 0], [0 0], 'r', 'DisplayName', 'x-axis')
plot3([0 0], [0 1], [0 0], 'g', 'DisplayName', 'y-axis')
plot3([0 0], [0 0], [0 1], 'b', 'DisplayName', 'z-axis')

ax = gca;
set(ax, 'ZDir', 'reverse')
view([-45 45])
camup([0 1 0])
xlabel('x [m]');
ylabel('y [m]          ','Rotation',0);
zlabel('z [m]');
hold off;
axis([-0.5 0.25 -0.25 1 -0.4 0.25])
for k = 1:500
    pause(0.001)
    x_k = x_pos(k,:);
    y_k = y_pos(k,:);
    z_k = z_pos(k,:);
    markers.XData = x_k;
    markers.YData = y_k;
    markers.ZData = z_k;
    pelvis.XData = x_k([1 2 4 3]);
    femur.XData = x_k([1,6]);
    tibia.XData = x_k([6,8]);
    foot.XData = x_k([8,10]);
    
    pelvis.YData = y_k([1 2 4 3]);
    femur.YData = y_k([1,6]);
    tibia.YData = y_k([6,8]);
    foot.YData = y_k([8,10]);
    
    pelvis.ZData = z_k([1 2 4 3]);
    femur.ZData = z_k([1,6]);
    tibia.ZData = z_k([6,8]);
    foot.ZData = z_k([8,10]);
    
    drawnow
end
%%
% export marker positions to excel file for easy reading
curr_path = pwd;

excel = 'Marker-Positions.xlsx';
header_pelvis = {'Time', 'RASI-X', 'RASI-Y', 'RASI-Z', ...
    'LASI-X', 'LASI-Y', 'LASI-Z', 'RPSI-X', 'RPSI-Y', 'RPSI-Z', ...
    'LPSI-X', 'LPSI-Y', 'LPSI-Z'};
writecell(header_pelvis, excel,'Sheet','Pelvis',...
    'WriteMode','overwritesheet','AutoFitWidth', 1);
writecell(num2cell([time, x_pos(:,1), y_pos(:,1), z_pos(:,1), ...
    x_pos(:,2), y_pos(:,2), z_pos(:,2), ...
    x_pos(:,3), y_pos(:,3), z_pos(:,3), ...
    x_pos(:,4), y_pos(:,4), z_pos(:,4)]), ...
    excel,'Sheet','Pelvis','WriteMode','append')

header_femur = {'Time', 'RTHI-X', 'RTHI-Y', 'RTHI-Z', ...
    'RKNE-X', 'RKNE-Y', 'RKNE-Z'};
writecell(header_femur, excel,'Sheet','Femur',...
    'WriteMode','overwritesheet','AutoFitWidth', 1);
writecell(num2cell([time, x_pos(:,5), y_pos(:,5), z_pos(:,5), ...
    x_pos(:,5), y_pos(:,5), z_pos(:,5)]), ...
    excel,'Sheet','Femur','WriteMode','append')

header_tibia = {'Time', 'RTIB-X', 'RTIB-Y', 'RTIB-Z', ...
    'RANK-X', 'RANK-Y', 'RANK-Z'};
writecell(header_tibia, excel,'Sheet','Tibia',...
    'WriteMode','overwritesheet','AutoFitWidth', 1);
writecell(num2cell([time, x_pos(:,7), y_pos(:,7), z_pos(:,7), ...
    x_pos(:,8), y_pos(:,8), z_pos(:,8)]), ...
    excel,'Sheet','Tibia','WriteMode','append')

header_foot = {'Time', 'RPED-X', 'RPED-Y', 'RPED-Z', ...
    'RTOE-X', 'RTOE-Y', 'RTOE-Z'};
writecell(header_foot, excel,'Sheet','Pedal-Foot',...
    'WriteMode','overwritesheet','AutoFitWidth', 1);
writecell(num2cell([time, x_pos(:,9), y_pos(:,9), z_pos(:,9), ...
    x_pos(:,10), y_pos(:,10), z_pos(:,10)]), ...
    excel,'Sheet','Pedal-Foot','WriteMode','append')