clc;
import org.opensim.modeling.*;

% directory of David's laptop
path4geo='\Applications\OpenSim 4.1\Geometry';
ModelVisualizer.addDirToGeometrySearchPaths(path4geo);
model2392 = Model("gait2392_simbody.osim");
% methodsview(model2392)
%%
% Define the path to the file
path4grf = 'subject01_walk1_grf.mot';
% Use the standard TimeSeriesTable to read the data file.
opensimTable = TimeSeriesTable(path4grf);
% Use the OpenSim Utility function, osimTable2Struct to
% convert the OpenSim table into a Matlab Struct for ease of use.
matlabStruct_grfData = osimTableToStruct(opensimTable);
%%
references = osimList2MatlabCell(model2392,'Body');  % Get a cell array of references to all the bodies in a model
% print all references to see all bodies
for r = 1:length(references)
    ref = references{r};
    disp(ref)
end

