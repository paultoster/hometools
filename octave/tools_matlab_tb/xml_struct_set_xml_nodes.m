function docNode = xml_struct_set_xml_nodes(root)
%
% node = xml_struct_set_xml_nodes(root)
%
% Struktur root mit
% root.Name
% root.Attributes
% root.Data
% root.Children
% wird in xml-Node umgesetzt
%
  docNode     = com.mathworks.xml.XMLUtils.createDocument(root.Name);
  docRootNode = docNode.getDocumentElement;
  docRootNode = xml_struct_set_xml_nodes_setAttributes(docRootNode,root.Attributes);
  if( ~isempty(root.Data) )
    docRootNode = xml_struct_set_xml_nodes_setData(docRootNode,root.Data);
  end
  docRootNode = xml_struct_set_xml_nodes_setChildren(docNode,docRootNode,root.Children);
end
function node = xml_struct_set_xml_nodes_setAttributes(node,att)

  n = length(att);
  for i = 1:n
    node.setAttribute(att(i).Name,att(i).Value);
  end
end
function node = xml_struct_set_xml_nodes_setData(node,data)
  node.setTextContent(data);
end
function node = xml_struct_set_xml_nodes_setChildren(docNode,node,childs)

  n = length(childs);
  for i = 1:n
    thisElement = docNode.createElement(childs(i).Name);
    thisElement = xml_struct_set_xml_nodes_setAttributes(thisElement,childs(i).Attributes);
    if( ~isempty(childs(i).Data) )
      thisElement = xml_struct_set_xml_nodes_setData(thisElement,childs(i).Data);
    end
    thisElement = xml_struct_set_xml_nodes_setChildren(docNode,thisElement,childs(i).Children);
    node.appendChild(thisElement);
  end
end