%% Parse markers.xml and extract the useful data (e.g. locations)
% displays the markers from "markers.xml" in 3D space to verify their
% global positions
markersXML = 'markers.xml';
markers_s = parseMarkers(markersXML);
% struct with fields Name, Attributes, Data, Children

% read in names, sockets, and locations of markers from the parsed XML
% struct
names = cell(11,1);
sockets = cell(11,1);
locations = cell(11,3);
for n = 1:11
    names{n} = markers_s.Children(2).Children(2).Children(2*n).Attributes.Value;
    sockets{n} = markers_s.Children(2).Children(2).Children(2*n).Children(4).Children.Data;
    locations(n,1:3) = split(markers_s.Children(2).Children(2).Children(2*n).Children(8).Children.Data);
end
% names cell array is usable as is
% truncate '/bodyset/' from all sockets
frames = cellfun(@(s) s(10:end), sockets, 'UniformOutput', 0);
% convert char arrays to usable numeric matrix
locs = cellfun(@str2num, locations);
% note that these are all given in the body frames that the markers are
% attached to. Need to correct by finding the global positions of the body
% frames
%% Find body frame positions
bodykin = importdata('cyclingleg_BodyKinematics_pos_global.sto', '\t');
% a struct with fields data, textdata, and colheaders
bk_data = bodykin.data;
bk_text = bodykin.textdata;
bk_headers = bodykin.colheaders';

first_x = find(strcmp(bk_headers, 'pelvis_X'));
first_y = find(strcmp(bk_headers, 'pelvis_Y'));
first_z = find(strcmp(bk_headers, 'pelvis_Z'));
first_Ox = find(strcmp(bk_headers, 'pelvis_Ox'));
first_Oy = find(strcmp(bk_headers, 'pelvis_Oy'));
first_Oz = find(strcmp(bk_headers, 'pelvis_Oz'));

% position data w/ respect to ground
xdata = bk_data(first_x:6:end);
ydata = bk_data(first_y:6:end);
zdata = bk_data(first_z:6:end);
% orientation data w/ respect to ground frame (I think...)
Oxdata = bk_data(first_Ox:6:end);
Oydata = bk_data(first_Oy:6:end);
Ozdata = bk_data(first_Oz:6:end);

%% Plot to visualize
figure(1); clf; hold on; box on; grid on;
mcol = {'blue', 'green', 'red', 'magenta'};
f = 1;
% Rotation matrix between OpenSim and Matlab
% just a 90 deg rotation about the x-axis
R_M_O = [1        0        0;
         0 cosd(90) -sind(90);
         0 sind(90) cosd(90)];
for k = 1:11
    px = locs(k,1);
    py = locs(k,2);
    pz = locs(k,3);
    switch frames{k}
        case 'pelvis'
            f = 1;
        case 'femur_r'
            f = 2;
        case 'tibia_r'
            f = 3;
        case 'calcn_r'
            f = 4;
        otherwise
            break;
    end
    bf = [xdata(f) ydata(f) zdata(f);
    Oxdata(f) Oydata(f) Ozdata(f)];
    % need to get the rotation matrix between the body frame and the ground
    % in OpenSim
    R_x = [1           0            0;
           0 cosd(bf(4)) -sind(bf(4));
           0 sind(bf(4)) cosd(bf(4))]; 
    R_y = [sind(bf(5)) 0  cosd(bf(5));
           0           1  0;
           cosd(bf(5)) 0 -sind(bf(5))];
    R_z = [cosd(bf(6)) -sind(bf(6)) 0;
           sind(bf(6))  cosd(bf(6)) 0;
           0            0           1];
    R_BF_O = R_x*R_y*R_z;
    % should be the full rotation matrix for the current body frame
    R_M_BF = R_M_O * (R_BF_O)^-1;
    fprintf(['Full Rotation Matrix of BF %s = \n',...
        '[%.3g, %.3g, %.3g]\n',...
        '[%.3g, %.3g, %.3g]\n',...
        '[%.3g, %.3g, %.3g]\n'], frames{k}, R_M_BF)

    r_OpenSim = bf(1:3)'; % position vector of the current body frame origin
    r_BF = [px; py; pz];
    
    fprintf('xyz coordinates for marker %i = (%.3g m, %.3g m, %.3g m)\n\n', k, x, y, z)
    scatter3(x, y, z,'MarkerEdgeColor', mcol{f},'MarkerFaceColor', mcol{f},...
        'DisplayName', frames{k});
end
legend('show','AutoUpdate','off');
plot3([0 5], [0 0], [0 0], 'r', 'DisplayName', 'x-axis')
plot3([0 0], [0 1], [0 0], 'g', 'DisplayName', 'y-axis')
plot3([0 0], [0 0], [0 1], 'b', 'DisplayName', 'z-axis')


hold off;