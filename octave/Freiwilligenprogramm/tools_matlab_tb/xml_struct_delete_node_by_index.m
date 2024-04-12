function [root,okay,errtext] = xml_struct_delete_node_by_index(root,indexvec)
%
% [root,okay,errtext] = xml_struct_delete_node_by_index(root,indexvec)
%
% root        root-Structure
% indexvec    vector with inices to find node to remove
%
  
  n = length(indexvec);
  
  [root,okay,errtext] = xml_struct_delete_node_by_index_parse(root,indexvec,0,n);
end
function [S,okay,errtext] = xml_struct_delete_node_by_index_parse(S,indexvec,ebene,n)
  okay    = 1;
  errtext = '';
  ebene   = ebene + 1;
  
  index   = indexvec(ebene);
  if( length(S) < index )
    okay = 0;
    errtext = sprintf('In Ebene %i ist index = %i zu groß n = %i',ebene,index,length(S));
    return
  else
    if( ebene == n )
      n = length(S);
      allocCell = cell(1, n-1);
      node = struct('Name', allocCell, 'Attributes', allocCell    ...
                   ,'Data', allocCell, 'Children', allocCell);
      inode = 0;
      for i=1:n
        if( i ~= index )
          inode = inode + 1;
          node(inode) = S(i);
        end
      end
      S = node;
    else
     [childs,okay,errtext] = xml_struct_delete_node_by_index_parse(S(index).Children,indexvec,ebene,n);
     if( ~okay )
       return;
     end
     S(index).Children = childs;
    end
    
  end
end