function write_xml4forces(results_path, filename)
    % using the output data of Force Reporter, writes a .xml file
    % for the constraint forces acting the midfoot
    % filename = 'external_pedal_forces';
    % begin <OpenSimDocument>
    docNode = com.mathworks.xml.XMLUtils.createDocument('OpenSimDocument');
    opensim = docNode.getDocumentElement;
    opensim.setAttribute('Version', '40000');
    % begin <ExternalLoads>
    externalLoads = docNode.createElement('ExternalLoads');
    externalLoads.setAttribute('name', 'Pedaling_GRF');
    opensim.appendChild(externalLoads);
    % begin <objects>
    objects = docNode.createElement('objects');
    externalLoads.appendChild(objects);
    % begin <ExternalForce>
    externalForce = docNode.createElement('ExternalForce');
    externalForce.setAttribute('name', 'right');
    objects.appendChild(externalForce);
    externalForce.appendChild(docNode.createComment("Flag indicating whether the force is applied or not. If true the forceis applied to the MultibodySystem otherwise the force is not applied.NOTE: Prior to OpenSim 4.0, this behavior was controlled by the 'isDisabled' property, where 'true' meant that force was not being applied. Thus, if 'isDisabled' is true, then 'appliesForce` is false."));

    appliesForce = docNode.createElement('appliesForce');
    appliesForce.appendChild(docNode.createTextNode('true'));
    externalForce.appendChild(appliesForce);

    externalForce.appendChild(docNode.createComment("Name of the body the force is applied to."));
    apply2body = docNode.createElement('applied_to_body');
    apply2body.appendChild(docNode.createTextNode('calcn_r'));
    externalForce.appendChild(apply2body);

    externalForce.appendChild(docNode.createComment("Name of the body the force is expressed in (default is ground)."));
    forceInBody = docNode.createElement('force_expressed_in_body');
    forceInBody.appendChild(docNode.createTextNode('ground'));
    externalForce.appendChild(forceInBody);  

    externalForce.appendChild(docNode.createComment("Name of the body the point is expressed in (default is ground)."));
    pointInBody = docNode.createElement('point_expressed_in_body');
    pointInBody.appendChild(docNode.createTextNode('ground'));
    externalForce.appendChild(pointInBody); 

    externalForce.appendChild(docNode.createComment("Identifier (string) to locate the force to be applied in the data source."));
    forceID = docNode.createElement('force_identifier');
    forceID.appendChild(docNode.createTextNode('PedalClip_calcn_r_F'));
    externalForce.appendChild(forceID);

%     externalForce.appendChild(docNode.createComment("Identifier (string) to locate the point to be applied in the data source."));
%     pointID = docNode.createElement('point_identifier');
%     pointID.appendChild(docNode.createTextNode('PedalClip_calcn_r_P'));
%     externalForce.appendChild(pointID);

%     externalForce.appendChild(docNode.createComment("Identifier (string) to locate the torque to be applied in the data source."));
%     torqueID = docNode.createElement('torque_identifier');
%     torqueID.appendChild(docNode.createTextNode('ground_torque_'));
%     externalForce.appendChild(torqueID);

    externalForce.appendChild(docNode.createComment("Name of the data source (Storage) that will supply the force data."));
    data_src = docNode.createElement('data_source_name');
    data_src.appendChild(docNode.createTextNode([filename,'.mot']));
    externalForce.appendChild(data_src);
    % end </ExternalForce>
    % end </objects>
    % begin <groups>
    externalLoads.appendChild(docNode.createElement('groups'));
    % end <groups />
    externalLoads.appendChild(docNode.createComment("Storage file (.sto) containing (3) components of force and/or torque and point of application.Note: this file overrides the data source specified by the individual external forces if specified."));
    datafile = docNode.createElement('datafile');
    datafile.appendChild(docNode.createTextNode([filename, '.mot']));
    externalLoads.appendChild(datafile);
    % end </ExternalLoads>
    % end </OpenSimDocument>
    xmlwrite([results_path, filename, '.xml'],docNode);
    % clc;
    % type([filename, '.xml']);
    
    fprintf('.xml file has been written to Results\n')
end