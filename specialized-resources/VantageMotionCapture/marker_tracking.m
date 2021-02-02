% read in opensim's example for trc file for marker tracking
ex_trc = 'opensim_example_subject01_walk1.trc';

fid = fopen(ex_trc);
tline = fgetl(fid);
opensim_rows = {};
i = 1;
while ischar(tline)
    % observe current line
%     disp(tline)
    % process the current line
    opensim_rows{i, 1} = tline;
    i = i+1;
    % move onto next line of the file
    tline = fgetl(fid);
end
fclose(fid);