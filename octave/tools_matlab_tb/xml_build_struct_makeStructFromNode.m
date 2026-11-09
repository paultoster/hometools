function nodeStruct = xml_build_struct_makeStructFromNode(theNode)
% Create structure of node info.

name = char(theNode.getNodeName);

if( strcmp(name,'task') )
  a = 0;
end
% if( strcmp(name,'Filter') )
%   a = 0;
% end
attb = xml_build_struct_parseAttributes(theNode);
data = xml_build_struct_parseData(theNode);
childs = xml_build_struct_parseChildNodes(theNode);


nodeStruct = struct(                        ...
   'Name', name,       ...
   'Attributes', attb,  ...
   'Data', data,                              ...
   'Children', childs);


