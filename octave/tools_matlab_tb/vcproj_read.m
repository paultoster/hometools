function root = vcproj_read(vcproj_file)
%
% root = vcproj_read(vcproj_file)
%
  if( ~exist(vcproj_file,'file') )
    error('vcproj-Datei: %s nicht vorhanden',vcproj_file);
  end

  node = xmlread(vcproj_file);

  root = xml_build_struct_parseChildNodes(node);
end
