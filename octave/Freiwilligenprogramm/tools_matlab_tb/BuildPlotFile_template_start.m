function c = BuildPlotFile_template_start(filename,use_e_struct)

  if( use_e_struct )
    funzeile     = ['function q = ',filename,'(fig_title,e,q)'];
    comzeile     = ['% q = ',filename,'(fig_title,e,q);'];
    ergaenzzeile = '  q = mess_plot_ergaenze_q(q,e);';
  else
    funzeile     = ['function q = ',filename,'(fig_title,d,u,q)'];
    comzeile     = ['% q = ',filename,'(fig_title,d,u,q);'];
    ergaenzzeile = '  q = mess_plot_ergaenze_q(q,d);';
  end

  c = ...
  {funzeile ...
  ,'% ' ...
  ,comzeile ...
  ,'% fig_title         Titel des Plots' ...
  ,'% d                 DAtenstruktur mit Vektoren,erster Vektor d.time' ...
  ,'% u                 Einheiten zur Datenstruktur mit gleichen Namen' ...
  ,'% q                 Parameterstruktur:' ...
  ,'% q.plot_in_one = 0     Soll in ein bild geplottet werden' ...
  ,'% q.n_data          AAnzahl Datensätze' ...
  ,'% q.file_list       Cellarray mit Filename' ...
  ,'% q.fig_num         letzte Plotfigurnummer' ...
  ,'% q.dina4           Ausrichtung' ...
  ,'% q.set_zaf         Zoomen ermöglichen' ...    
  ,'% q.line_size       Linienstärke' ...
  ,'% q.line_size_1       Linienstärke' ...
  ,'% q.line_size_2       Linienstärke' ...
  ,'' ...
  ,'  set_plot_standards' ...
  ,ergaenzzeile ...
  ,'  % Alles in ein Fenster plotten' ...
  ,'  if( q.plot_in_one )' ...
  ,'    nfig    = 1;' ...
  ,'  else' ...
  ,'    nfig    = q.n_data;' ...
  ,'  end' ...
  ,'' ...
  ,'  for ifig = 1:nfig' ...
  ,'' ...
  ,'    % Alles in ein Fenster plotten' ...
  ,'    if( q.plot_in_one )' ...
  ,'      dataset = [1:1:q.n_data]'';' ...
  ,'    else' ...
  ,'      dataset = ifig;' ...
  ,'    end' ...
  ,'    ndataset = length(dataset);' ...
  ,'' ...
  ,'    q.fig_num            = q.fig_num+1;' ...
  ,'' ...
  ,'    if( find_val_in_vec(get_fig_numbers,q.fig_num,0.1) > 0.5 )' ...
  ,'      close(q.fig_num)' ...
  ,'    end' ...
  ,'    s_fig = struct;' ...
  ,'    % #########################################################################' ...
  ,'    % #########################################################################' ...
  ,'    s_fig = plot_set_fig_f(s_fig  ...' ...
  ,'    ,''fig_num'',         q.fig_num ...' ...
  ,'    ,''short_name'',      sprintf(''%s%i'',fig_title,ifig) ...' ...
  ,'    ,''dina4'',           q.dina4 ...' ...
  ,'    ,''set_zaf'',         q.set_zaf ...' ...
  ,'    ,''rows'',            0 ...' ...
  ,'    );' ...
  };
