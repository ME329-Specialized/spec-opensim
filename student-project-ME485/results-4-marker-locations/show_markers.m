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

xdata = bk_data(first_x:6:end);
ydata = bk_data(first_y:6:end);
zdata = bk_data(first_z:6:end);
Oxdata = bk_data(first_Ox:6:end);
Oydata = bk_data(first_Oy:6:end);
Ozdata = bk_data(first_Oz:6:end);

% pelvis = [xdata(1) ydata(1) zdata(1);
%     Oxdata(1) Oydata(1) Ozdata(1)];
% femur = [xdata(2) ydata(2) zdata(2);
%     Oxdata(2) Oydata(2) Ozdata(2)];
% tibia = [xdata(3) ydata(3) zdata(3);
%     Oxdata(3) Oydata(3) Ozdata(3)];
% calcn = [xdata(4) ydata(4) zdata(4);
%     Oxdata(4) Oydata(4) Ozdata(4)];
% pedal = [xdata(5) ydata(5) zdata(5);
%     Oxdata(5) Oydata(5) Ozdata(5)];
%% Plot to visualize
figure(1); clf; hold on; box on; grid on;
mcol = {'blue', 'green', 'red', 'magenta'};
f = 1;
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
    x = bf(1) + cosd(bf(4))*px;
    y = bf(2) + cosd(bf(5))*py;
    z = bf(3) + cosd(bf(6))*pz;
    fprintf('xyz coordinates for marker %i = (%.3g m, %.3g m, %.3g m)\n', k, x, y, z)
    scatter3(x, y, z, 'MarkerFaceColor', mcol{f});
end


hold off;