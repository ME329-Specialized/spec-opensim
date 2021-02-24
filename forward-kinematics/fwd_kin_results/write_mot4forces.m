function write_mot4forces(filename, model,version_num,nRows,nColumns,inDegrees,colheaders,data)
% using the output data of Force Reporter, writes a .mot file (tab
% delimited) for the constraint forces acting the midfoot
% filename = ['external_pedal_forces', '.csv'];
heading = {[filename,'.mot'];
    ['version=',num2str(version_num)];
    ['nRows=',num2str(nRows)];
    ['nColumns=',num2str(nColumns)];
    ['inDegrees=',inDegrees];
    'endheader'};

writecell(heading, [filename, '.txt'],'Delimiter', '\t', 'WriteMode', 'overwrite');
writecell(colheaders, [filename, '.txt'],'Delimiter', '\t', 'WriteMode', 'append');
writecell(num2cell(data), [filename, '.txt'],'Delimiter', '\t', 'WriteMode', 'append');

movefile([filename, '.txt'], [filename,'.mot'])
end

