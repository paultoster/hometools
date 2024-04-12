function d_data_plot(d,u,h,flag)
%
% d_data_plot(d,u,h)
% d_data_plot(d,u,h,1)   bietet Auswahl an
%
% Plottet alle Daten aus d mit dem ersten Vektor als x-Vektor z.B. Zeit
% wenn Länge nicht übereinstimmt, wird Index verwendet

  if( ~exist('flag','var') )
    flag = 0;
  end

  if( exist('h','var') && iscell(h) && ~isempty(h) )
    ttext = h{1};
    if( (length(h) > 1) && isstruct(h{2}) )
      c = h{2};
    else
      c = [];
    end
  else
    ttext = '';
  end
  c_names = fieldnames(d);
  n       = length(c_names);
  
  if( flag )
 
    s_frage.c_liste   = c_names;
    s_frage.sort_list = 1;
    s_frage.frage     = 'Wich channels to plot';
    [okay,selection] = o_abfragen_listboxsort_f(s_frage);
    [c_names] = cell_get_icell_selection(c_names,selection);
    n         = length(c_names);
  end

  x  = d.(c_names{1});
  nx = length(x);
  if( struct_find_f(u,c_names{1}) )
    xunit = u.(c_names{1});
  else
    xunit = '';
  end
  xname = [c_names{1},' / ',xunit];

  ifig = max(get_fig_numbers);

  for i=2:n
    ifig = ifig + 1;
    y = d.(c_names{i});
    ny = length(y);

    p_figure(ifig,0)
    if( nx == ny )
      plot(x,y)
      xlabel(str_change_f(xname,'_',' '))
    else
      plot(y)
    end
    if( struct_find_f(u,c_names{i}) )
      yunit = u.(c_names{i});
    else
      yunit = '';
    end
    yname = [c_names{i},' / ',yunit];
    ylabel(str_change_f(yname,'_',' ')) 

    if( struct_find_f(c,c_names{i}) )
      title(str_change_f([ttext,'/',c.(c_names{i})],'_',' '))
    else
      title(str_change_f(ttext,'_',' '))
    end
    grid on
  end
  figmen
end
    
  



