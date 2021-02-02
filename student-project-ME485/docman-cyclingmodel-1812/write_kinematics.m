clear all;
clc;

% Writes the kinematics/joint angles .sto file
file = 'coordinates.xlsx';
[data, header] = xlsread(file);

[r,c] = size(data);
formatSpec = 'Coordinates\nnRows=%d\nnColumns=%d\ninDegrees=yes\nendheader';

fileID = fopen('tester.txt','w');
fprintf(fileID, formatSpec, r, c);
writecell(header, 'tester.txt', 'Delimiter', '\t', 'WriteMode', 'append');
writematrix(data, 'tester.txt', 'Delimiter', '\t', 'WriteMode', 'append');