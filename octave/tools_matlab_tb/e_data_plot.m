function e_data_plot(e,flag,nrow,ncol)
%
% e_data_plot(e)
% e_data_plot(e,1)   bietet Auswahl an
% e_data_plot(e,1,nrow,ncol)   bietet Auswahl an und subplot(nro,ncol,i)
%
% Plottet alle Daten aus e mit dem Zeit-Vektor
% wenn Länge nicht übereinstimmt, wird Index verwendet
  f = '';
  if( ~exist('e','var') || isempty(e) )
    [okay,e,f] = e_data_read_mat;
    if(  ~okay )
      error('e_data_plot_error: e_data_read_mat not okay ');
    end
  end
  if( ~exist('flag','var') )
    flag = 0;
  end
  if( ~exist('nrow','var') )
    nrow = 1;
  end
  if( ~exist('ncol','var') )
    ncol = 1;
  end
  
  if( nrow > 1 && ncol > 1 )
    if( nrow > ncol )
      dina4 = 1;
    else
      dina4 = 2;
    end
  else
    dina4 = 0;
  end

  c_names = fieldnames(e);
  n       = length(c_names);
  
  if( flag )
 
    s_frage.c_liste   = c_names;
    s_frage.sort_list = 1;
    s_frage.frage     = 'Wich channels to plot';
    [okay,selection] = o_abfragen_listboxsort_f(s_frage);
    [c_names] = cell_get_icell_selection(c_names,selection);
    n         = length(c_names);
  end

  

  ifig = max(get_fig_numbers);
  isubplot = 0;
  for i=1:n
    isubplot = isubplot + 1;
    if( isubplot > nrow*ncol )
      isubplot = 1;
    end
    
    if( e_data_is_timevec(e,c_names{i}) && ~e_data_is_vecinvec(e,c_names{i}) )
      
      x  = e.(c_names{i}).time;
      nx = length(x);
      xname = 'time';
      y = e.(c_names{i}).vec;
      ny = length(y);
      yunit = e.(c_names{i}).unit;

      if( isubplot == 1 )
        ifig = ifig + 1;
        p_figure(ifig,dina4)
      end
      subplot(nrow,ncol,isubplot);
      plot(x,y)
      xlabel(str_change_f(xname,'_',' '))
      yname = [c_names{i},' / ',yunit];
      ylabel(str_change_f(yname,'_',' ')) 

      if( ~isempty(e.(c_names{i}).comment) )
        title(str_change_f(e.(c_names{i}).comment,'_',' '))
      end
      grid on
      fprintf('ploat(e.(%s).time,e.(%s).vec)\n',c_names{i},c_names{i})
      if( ~isempty(f) )
        plot_bottom(f);
      end
    end
  end
  figmen
end
    
  



