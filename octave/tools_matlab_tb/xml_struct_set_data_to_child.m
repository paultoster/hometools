function Childrens = xml_struct_set_data_to_child(Childrens,indexvec,childname,value)
%
% Childrens = xml_struct_set_data_to_child(Childrens,indexvec,childname,value)
%
% Setzt oder ersetzt in den Childrens mit index aus indexvec die Werte
% für Children mit Namen childname den Wert value
%
  n = length(Childrens);
  for i=1:length(indexvec)    
    ii = indexvec(i);
    if( ii > n )
      error('length(Childrens)=%i < indexvec(%i)=%i',n,i,ii);
    end
    m = length(Childrens(ii).Children);
    jj = 0;
    for j=1:m
      if( strcmpi(Childrens(ii).Children(j).Name,childname) )
        jj = j;
        break;
      end
    end

    if( jj )
      Childrens(ii).Children(jj).Data = value;
    else
      Childrens(ii).Children(m+1).Name  = childname;
      Childrens(ii).Children(m+1).Data = value;
    end      
  end
end