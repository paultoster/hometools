function children = xml_build_struct_parseChildNodes(theNode)
% Recurse over node children.
children = [];
if theNode.hasChildNodes
   childNodes = theNode.getChildNodes;
   numChildNodes = childNodes.getLength;
   n = 0;
   for count = 1:numChildNodes
      theChild = childNodes.item(count-1);
      if( str_find_f(char(theChild.getNodeName),'#text') == 0 )
        % fprintf('<%s>\n',char(theChild.getNodeName))
        n = n + 1;
      end
   end
   allocCell = cell(1, n);

   children = struct(             ...
      'Name', allocCell, 'Attributes', allocCell,    ...
      'Data', allocCell, 'Children', allocCell);

    n = 0;
    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        if( str_find_f(char(theChild.getNodeName),'#text') == 0 )
          n = n+1;
          children(n) = xml_build_struct_makeStructFromNode(theChild);
        end
    end
end
