function [Children,okay,errtext] = xml_struct_find_all_children_with_Name_in_childs(S,name)
%
% [Children,okay,errtext] = xml_struct_find_all_children_with_Name_in_childs(S,name)
% S       xml-Struktur
% name    Name der Children-Struct
  Children = [];
  okay = 1;
  errtext = '';
  for i=1:length(S)
    if( strcmpi(S(i).Name,name) )
      if( isempty(Children) )
        Children = S(i);
      else
        Children(length(CHildren)+1) = S(i);
      end
    end
    for j=1:length(S(i).Children)
      [fchildren,okay,errtext] = xml_struct_find_all_children_with_Name_in_childs(S(i).Children(j),name);
      if( ~okay )
        return;
      else
        for k=1:length(fchildren)
          if( isempty(Children) )
            Children = fchildren(k);
          else
            Children(length(Children)+1) = fchildren(k);
          end
        end
      end
    end
  end   
end
