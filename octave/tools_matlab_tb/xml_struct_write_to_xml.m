function okay = xml_struct_write_to_xml(vcproj_file,root)
%
% okay = vcproj_read(vcproj_file,root)
%
  okay = 1;
  node = xml_struct_set_xml_nodes(root);
  xmlwrite(vcproj_file,node);
end
