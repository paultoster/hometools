function okay = e_data_plot_signals(e,c_liste,bottom_text)
%
% okay = e_data_plot_signals(e,c_liste)
% okay = e_data_plot_signals(e,c_liste,bottom_text)
% 
% plotten aller zeitlcihen Signale
%
% e          e-data-structure
% c_liste    cellaray mit zu suchenden  Namen (auch mit *)
%                       z.B. {'name1','name2','par*','*_01'}
%            default: {} also alle
% 
% 
  okay = 1;
  if( ~exist('c_liste','var') )
    c_liste = {};
  end
  
  if( ~exist('bottom_text','var' ) )
    bottom_text = '';
  end
  
  c_names = fieldnames(e);
  if( isempty(c_liste) )
    cliste = c_names;
  else
    cliste = cell_find_liste(c_names,c_liste);
  end
  n = length(cliste);
  
  
  ncol = 2;
  nrow = 3;
  ncount = 0;
  icount = 0;
  inum   = 0;
  while(ncount < n )
    
    ncount = ncount + 1;
    
    if( e_data_is_timevec(e,cliste{ncount}) )
    
      icount = icount + 1;
      iact = mod(icount,ncol*nrow);
      if( iact == 0 )
        iact = ncol*nrow;
      end

      if( (iact == 1) )
        inum = inum + 1;
        fignum = get_max_figure_num+1;
        p_figure(fignum,1,num2str(inum))
      end

      e_data_plot_signals_plot(e.(cliste{ncount}),cliste{ncount},iact,nrow,ncol);
      
      if( ~isempty(bottom_text) && (iact == ncol*nrow) )
        
        plot_bottom_date(bottom_text,fignum);
      end
    end
  end
end
function e_data_plot_signals_plot(s,name,iact,nrow,ncol)

  subplot(nrow,ncol,iact)
  plot(s.time,s.vec,'b-')
  grid on
  xlabel('s [s]')
  ylabel(sprintf('%s [%s]',str_change_once_f(name,'_','\_'),s.unit))
end
