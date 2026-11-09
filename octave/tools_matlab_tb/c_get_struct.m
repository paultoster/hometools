function S = c_get_struct(c,struct_def_name)
  
  % struct mit Namen suchen
  [ifound,ipos] = cell_find_f(c,'struct','n');
  found = 0;
  for i=1:length(ifound)
    nc = length(c{i});
    i0 = min(nc,ipos(i)+6); % + length('struct')
    j0 = str_find_f(c{i}(i0:nc),q.sim_def_name);
    if( j0 > 0 )
      icell = i;
      ipos  = i0 + j0 - 1 + length(q.sim_def_name);
      found = 1;
      break;
    end
  end
  if( ~found )
    errror('%s_error: strcut %s konnten nicht in h-Datei <%s> gefunden werden',mfilename,q.sim_def_name,q.sim_def_h_file);
  end
  % Die eingebetteten Strukturen auslesen
  [icell1,ipos1] = cell_find_from_ipos(c,icell,ipos,'{');
  if( icell1 == 0 )
    errror('%s_error: %s konnten nicht in h-Datei <%s> gefunden werden',mfilename,'{',q.sim_def_h_file);
  end
  [icell2,ipos2] = cell_find_from_ipos(c,icell1,ipos1,'}');
  if( icell2 == 0 )
    errror('%s_error: %s konnten nicht in h-Datei <%s> gefunden werden',mfilename,'}',q.sim_def_h_file);
  end  
  
  tt = cell_get_with_ipos(c,icell1,ipos1,icell2,ipos2-1);
  end