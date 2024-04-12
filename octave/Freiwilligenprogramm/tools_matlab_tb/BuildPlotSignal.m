function BuildPlotSignal(e,signame,type)
%
% BuildPlotSignal(e,name_start)
% BuildPlotSignal(e,name_start,type)
%
% e             e-Signal-Structure
% signame       Signalname start of z.B. 'VehDsrdTraj1_world_coord'
%                                        'VehDsrdTraj1_*'
%                                        {'VehDsrdTraj1_world_coord', ...}
%
% type          1: (default) schreibe an Screen für Screen eine Beschreibungszeile
%
  if( ischar(signame) )
    signame = {signame};
  end
  
  cnames = fieldnames(e);
  
  fid = 1;
  
  for i=1:length(signame)
  
    cnames_select = cell_find_names(cnames,signame{i});
  
    set_plot_standards
  
  
  
    for j=1:length(cnames_select)
    
    
      fprintf(fid,'{''%s'',''%s'',1,''%s''}\n' ...
             ,cnames_select{j} ...
             ,e.(cnames_select{j}).unit ...
             ,PlotStandards.color_names{j});
      
    end
  end
end
  
