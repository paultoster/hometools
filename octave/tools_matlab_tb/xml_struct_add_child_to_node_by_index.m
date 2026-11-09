function [root,okay,errtext] = xml_struct_add_child_to_node_by_index(root,indexvec,child)
%
% [root,okay,errtext] = xml_struct_add_child_to_node_by_index(root,indexvec,child)
%
% root        root-Structure
% indexvec    vector with inices to find node to add child
% child       child-structure (node) (e.g. build with xml_struct_build_node()
%
  
  n = length(indexvec);
  
  [root,okay,errtext] = xml_struct_add_child_to_node_by_index_parse(root,indexvec,0,n,child);
end
function [S,okay,errtext] = xml_struct_add_child_to_node_by_index_parse(S,indexvec,ebene,n,child)
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
      childs = S(index).Children;
      if( isempty(childs) )
        childs = child;
      else
        childs(length(childs)+1) = child;
      end
     
    else
     [childs,okay,errtext] = xml_struct_add_child_to_node_by_index_parse(S(index).Children,indexvec,ebene,n,child);
     if( ~okay )
       return;
     end
    end
    S(index).Children = childs;
  end
end