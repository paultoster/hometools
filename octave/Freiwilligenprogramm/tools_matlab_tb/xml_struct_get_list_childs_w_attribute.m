function [list,ivec] = xml_struct_get_list_childs_w_attribute(Children,Name)
%
% [list,ivec] = xml_get_children_w_attribute(root,Name)
%
%  Suche im root alle Children mit dem Attributtes-Namen
%  ivec enthalt die indices der gefundenen childs
  list = {};
  ivec = [];
  n = length(Children);
  for i=1:n
    child = Children(i);
    
    m = length(child.Attributes);
    for j=1:m
      if( strcmpi(child.Attributes(j).Name,Name) )
        list = cell_add(list,child.Attributes(j).Value);
        ivec = [ivec;i];
        break;
      end
    end
  end
end