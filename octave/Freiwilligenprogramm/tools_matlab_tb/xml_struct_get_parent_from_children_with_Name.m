function [ChildStruct,indexvec,okay,errtext] = xml_struct_get_parent_from_children_with_Name(S,fullname)
%
% [Children,okay,errtext] = xml_struct_get_parent_from_children_with_Name(S,fullname)
% S           xml-Strukturullname
% fullname    Full-Name of Children-Struct e.g. 'Project.ItemGroup.Filter'
  okay        = 1;
  errtext     = '';
  ChildStruct = [];
  indexvec    = [];
  
  cnames = str_split(fullname,'.');
  n      = length(cnames);
  [indexvec,found] = xml_struct_get_parent_from_children_with_Name_parse(S,0,cnames,n,[]);
  n      = length(indexvec);
  if( found && n > 1 ) % Child gefunden, dazu muss es ein Parent geben n > 1
    n = n - 1;
    ChildStruct = S(indexvec(1));
    for i=2:n
      ChildStruct = ChildStruct.Children(indexvec(i));
    end
    indexvec = indexvec(1:n);
  else
    indexvec = [];
  end
    
end
function [indexvec,found] = xml_struct_get_parent_from_children_with_Name_parse(S,ebene,cnames,n,indexvec)
  found = 0;
  ebene = ebene + 1;
  for i=1:length(S)
    if( strcmpi(S(i).Name,cnames{ebene}) )
      % indexvec füllen
      indexvec = [indexvec;i];
      if( ebene == n )         
        found = 1;
        return
      else
        [indexvec,found] = xml_struct_get_parent_from_children_with_Name_parse(S(i).Children,ebene,cnames,n,indexvec);
        if( found )
          return
        else
          % indexvec wieder reduzieren, da nich gefunden
          if( ebene == 1 )
            indexvec = [];
          else
            indexvec = indexvec(1:ebene-1);
          end
        end
      end
    end
  end
end
