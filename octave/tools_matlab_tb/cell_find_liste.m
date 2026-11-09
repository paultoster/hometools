function cliste = cell_find_liste(c_name,csig_liste)
%
% cliste = cell_find_liste(c_name,csig_liste)
%
% c_name                cell-array-Liste Liste mit den Namen die gesucht werden
% cig_liste             cellaray mit zu suchenden  Namen (auch mit *)
%                       z.B. {'name1','name2','par*','*_01'}
%
% cliste                cellarray mit allen relevanten Namen aus c_name

  n      = length(c_name);
  
  cliste = {};
  % csig_liste bearbeiten
  for i=1:length(csig_liste)    
    tt = str_cut_ae_f(csig_liste{i},' ');
    i0 = str_find_f(tt,'*','vs');
    if( i0 == 0 ) % kein *
      cliste = cell_add(cliste,csig_liste{i});
    elseif( i0 == 1 ) % am Anfang
      such_text = tt(2:end);
      
      for j=1:n
        i1 = str_find_f(c_name{j},such_text,'rs');
        if( i1 )
          cliste = cell_add(cliste,c_name{j});
        end
      end
    elseif( '*' == tt(end) )
      
      such_text = tt(1:end-1);
      
      for j=1:n
        i1 = str_find_f(c_name{j},such_text,'vs');
        if( i1 )
          cliste = cell_add(cliste,c_name{j});
        end
      end
    elseif( length(tt) == 1 ) % alle
      for j=1:n
          cliste = cell_add(cliste,c_name{j});
      end
    elseif( (iend > 1) && (iend < length(tt)) && (length(tt) > 2 ) )
      such_text0 = tt(1:iend-1);
      such_text1 = tt(iend+1:end);
      for j=1:n
        i0 = str_find_f(c_name{j},such_text0,'vs');
        if( (i0 > 0) && i0 < length(c_name{j}) )
          i1 = str_find_f(c_name{j}(i0+1:end),such_text1,'rs');
          if( i1 > 0 )
            cliste = cell_add(cliste,c_name{j});
          end
        end
      end
    end
  end
  cliste = cell_reduce_double_elements(cliste);
end