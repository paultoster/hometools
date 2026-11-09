function [d,u,hc,f] = d_data_file_choice_a_read(dir_path,ncount)
%
% Sucht in dir_path beliebige mat-Files liest sie ein,
% wenn  lesbar Struktur mit Vektoren 
%
% dir_path        char     Pfad zum Suchen
% ncount          num      < 0 Es werden automatisch alle mat-Dateien eingeladen 
%                          = 0 Beliebige Auswahl
%                          > 0 festgelegte Auswahl
%
% d               struct   Datenstruktur d(i) mit numerischen Vektoren
% u               struct   Unitstruktur u(i)  mit char zu jedem Signal in d(i)
% hc              cell     Headercellarray hc{i} = h mit cellarrays gefüllt
%                          mit Kommentar zu der Messung
% f               cell     Liste mit den eingelesenen Filenamen vollständig

  d  = [];
  u  = [];
  hc = {};
  f  = {};
  
  if( ncount < 0 )
    file_list = suche_files_f(dir_path,'*.mat',1,0);
    c_filenames = cell(1,length(file_list));
    for i = 1:length(file_list)
      c_filenames{i} = file_list(i).full_name;
    end  
  else
  
    s_frage             = [];
    s_frage.comment     = 'Mat-Dateien in duh oder ähnlichem Format';
    s_frage.file_spec   = '*.mat';
    s_frage.start_dir   = dir_path;

    if( ncount < 1 )
      s_frage.file_number = 0;
    else
      s_frage.file_number = ncount;
    end

    [okay,c_filenames]  = o_abfragen_files_f(s_frage);
  end
  
  n     = length(c_filenames);
  index = 0;
  for i=1:n
    
    [okay,d0,u0,h0] = d_data_read_mat(c_filenames{i});
    
    if( okay ) 
      index = index+1;
      [d,u] = das_merge_struct_f(d,u,d0,u0,index);
      hc{index} = h0;
      f{index}  = c_filenames{i};
    end
  end

end