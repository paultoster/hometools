function Childrens = xml_struct_set_attribute_to_children(Childrens,indexvec,attribute_name,attribute_value)
%
% Childrens = xml_struct_set_attribute_to_children(Childrens,indexvec,attribute_name,attribute_value)
%
% Setzt oder ersetzt in den Childrens mit index aus indexvec die Attribute
% mit Namen attribute_name die Werte attribute_value
%
  n = length(Childrens);
  for i=1:length(indexvec)    
    ii = indexvec(i);
    if( ii > n )
      error('length(Childrens)=%i < indexvec(%i)=%i',n,i,ii);
    end
    m = length(Childrens(ii).Attributes);
    jj = 0;
    for j=1:m
      if( strcmpi(Childrens(ii).Attributes(j).Name,attribute_name) )
        jj = j;
        break;
      end
    end

    if( jj )
      Childrens(ii).Attributes(jj).Value = attribute_value;
    else
      Childrens(ii).Attributes(m+1).Name  = attribute_name;
      Childrens(ii).Attributes(m+1).Value = attribute_value;
    end      
  end
end