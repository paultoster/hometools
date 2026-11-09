function [list,ivec] = xml_struct_get_data_list_from_child(S,ChildName,type)
%
% [data,index]             = xml_struct_get_data_list_from_child(S,ChildName)
% [data,index]             = xml_struct_get_data_list_from_child(S,ChildName,0)
% [data_cliste,index_liste] = xml_struct_get_data_list_from_child(S,ChildName,1)
%
%  Suche S nach Children mit ChildNamen und gibt data zurück
%  type        0: Sucht nur das erste Child Rückgabe (char)
%              1: Sucht alle Childs Rückgabe (cell)
%
%  index_liste enthalt die indices der gefundenen childs bzw. index den
%  entsprecheneden index des ersten gefundenen

  if( ~exist('type','var') )
    type = 0;
  end
  
  list = {};
  ivec = [];
  n = length(S);
  for i=1:n
    childs = S(i).Children;
    for j=1:length(childs)
      child = childs(j);
      if( strcmpi(child.Name,ChildName) )
        list = cell_add(list,child.Data);
        ivec = [ivec;i];
        if( type == 0 )
          list = list{1};
          ivec = ivec(1);
          return;
        end
      end
    end
  end
end