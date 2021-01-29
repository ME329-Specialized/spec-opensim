pref = 'cyclingleg_PointKinematics_';
mark_names = {'RASI', 'LASI', 'RPSI', 'LPSI', 'RTHI', 'RKNE', ...
    'RTIB', 'RANK', 'RPED', 'RTOE'};
% pelvis[1,2,3,4], femur_r[5,6], tibia_r[6,7,8], foot[9,11]
suff = '_pos.sto';
x_pos = zeros(500, length(mark_names));
y_pos = zeros(500, length(mark_names));
z_pos = zeros(500, length(mark_names));
for m = 1:length(mark_names)
    name = mark_names{m};
    sto_file = [pref, name, suff];
    mark_m = importdata(sto_file, '\t');
    % a struct with fields data, textdata, and colheaders
    x_pos(:, m) = mark_m.data(1:500,2);
    z_pos(:, m) = mark_m.data(1:500,3);
    y_pos(:, m) = mark_m.data(1:500,4);
end
%%
figure(1); clf; hold on; box on; grid on;
view([30 30])
markers = scatter3(x_pos(1,:), y_pos(1,:), z_pos(1,:), ...
    'MarkerEdgeColor', [1 0 0.3], 'MarkerFaceColor', [1 0 0.3]);

plot3([0 1], [0 0], [0 0], 'r', 'DisplayName', 'x-axis')
plot3([0 0], [0 1], [0 0], 'g', 'DisplayName', 'y-axis')
plot3([0 0], [0 0], [0 1], 'b', 'DisplayName', 'z-axis')
hold off;
axis([-1 0.5 -0.2 0.2 -1 1])
for k = 1:500
    pause(0.001)
    x_k = x_pos(k,:);
    y_k = y_pos(k,:);
    z_k = z_pos(k,:);
    markers.XData = x_k;
    markers.YData = y_k;
    markers.ZData = z_k;
    drawnow
end