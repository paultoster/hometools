function data = xml_parseData(theNode)

  data = '';
  if theNode.hasChildNodes
     childNodes = theNode.getChildNodes;
     numChildNodes = childNodes.getLength;
     for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        if( str_find_f(char(theChild.getNodeName),'#text') )
          
          if any(strcmp(methods(theChild), 'getData'))
             data = char(theChild.getData);
             data = str_cut_ae_f(data,' ');
             data = str_cut_ae_f(data,char(10));
             return
          end
          
        end
     end
  end
%   if any(strcmp(methods(theNode), 'getData'))
%      data = char(theNode.getData); 
%   end
end