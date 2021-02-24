function write_mot4forces(results_path, filename,version_num,nRows,nColumns,inDegrees,colheaders,data)
% using the output data of Force Reporter, writes a .mot file (tab
% delimited) for the constraint forces acting the midfoot
% filename = ['external_pedal_forces', '.csv'];
heading = {[filename,'.mot'];
    ['version=',num2str(version_num)];
    ['nRows=',num2str(nRows)];
    ['nColumns=',num2str(nColumns)];
    ['inDegrees=',inDegrees];
    'endheader'};

writecell(heading, [results_path, filename, '.txt'],'Delimiter', '\t', 'WriteMode', 'overwrite');
writecell(colheaders, [results_path, filename, '.txt'],'Delimiter', '\t', 'WriteMode', 'append');
writecell(num2cell(data), [results_path, filename, '.txt'],'Delimiter', '\t', 'WriteMode', 'append');
movefile([results_path, filename, '.txt'], [results_path, filename,'.mot'])

fprintf('.mot file has been written to Results\n')
end

