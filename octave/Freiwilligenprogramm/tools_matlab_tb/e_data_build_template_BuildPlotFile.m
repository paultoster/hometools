function okay = e_data_build_template_BuildPlotFile(e,c_liste)
%
% okay = e_data_plot_signals(e)
% okay = e_data_plot_signals(e,name)
% okay = e_data_plot_signals(e,c_liste)
% 
% dumpt auf Bildschirm template Beschreibung der Signale für BuildPlotFile
% z.B.
%                               ,'cplot',  {{'Signalname1','unit1',1,'Mschwarz'} ...
%                                          ,{'Signalname2','unit2',1,'Mrot'} ...
%                                          } ...
%
% e          e-data-structure
% name       einzelner NAme z.B. 'name1' oder 'par*'
% c_liste    cellaray mit zu suchenden  Namen (auch mit *)
%                       z.B. {'name1','name2','par*','*_01'}
%            default: {} also alle
% 
% 
  okay = 1;
  if( ~exist('c_liste','var') )
    c_liste = {};
  end
  
  if( ischar(c_liste) )
    c_liste = {c_liste};
  end
  
  
  c_names = fieldnames(e);
  if( isempty(c_liste) )
    cliste = c_names;
  else
    cliste = cell_find_liste(c_names,c_liste);
  end
  n = length(cliste);
  
  set_plot_standards
  m = length(PlotStandards.color_names);
  startflag = 1;
  for i=1:n
    if( e_data_is_timevec(e,cliste{i}) && ~e_data_is_vecinvec(e,cliste{i}) )
      unit = e.(cliste{i}).unit;
      j = i;
      while(j>m),j = j-m;end
      farbe = PlotStandards.color_names{j};

      if( startflag )
        startflag = 0;
        fprintf('                               ,''cplot'',  {{''%s'',''%s'',1,''%s''} ...\n',cliste{i},unit,farbe);
      else
        fprintf('                                          ,{''%s'',''%s'',1,''%s''} ...\n',cliste{i},unit,farbe);
      end
    end
  end
  if( ~startflag )
    fprintf('                                          } ...\n');
  else
    fprintf('\n              no signal found !!!\n');
  end
  end
