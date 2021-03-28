% move to the correct directory
while ~endsWith(pwd, 'specialized-resources')
    cd ..
    spec_dir = dir('**/Normative Ranges for Open SIM*.xlsx');
    cd(spec_dir.folder);
end
specialized = readcell('Normative Ranges for Open SIM.xlsx',...
    'Range','A1:BP5');
headers = specialized(1, :);
