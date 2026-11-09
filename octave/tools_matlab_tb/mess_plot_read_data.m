function [d,u,h,q,meas_dir] = mess_plot_read_data(q)
%
% [d,u,h,q] = mess_plot_read_data(q)
%
% duh-Matlabdaten zum Plotten einlesen
%
% q.load_one_file            0/1     nur ein File einlesen
% q.use_start_dir            0/1     Start-Dir soll benutzt werden
% q.start_dir                string  Start-Dir zum suchen
%
% d,u                        structs   Daten-, Unit- Struktur
% h                          cellarray Header-cellarray h{1} ist meist die
%                                      Herkunft oder Kommentar
%                                      h{2} ist meist c-Struktur mit
%                                      Kommentaren zu den Signalen
% q.file_list                cellarray Liste der eingelesenen Filename
% q.load_file_list           0/1       Lade die file_liste ein, wenn
%                                      vorhanden
%
%
  d = struct;
  u = struct;
  h = {};
  meas_dir         = '';
  
  if( ~isfield(q,'load_one_file') )
    q.load_one_file = 0;
  end
  if( ~isfield(q,'use_start_dir') )
    q.use_start_dir = 0;
  end
  if( ~isfield(q,'start_dir') )
    q.start_dir = '';
  end
  
  if( check_val_in_struct(q,'load_file_list','num',1) && (q.load_file_list == 1) )
    if( check_val_in_struct(q,'file_list','cell',1) )
      load_file_list = 1;
    else
      load_file_list = 0;
      q.file_list    = {};
    end
  else
    load_file_list = 0;
    q.file_list    = {};
  end


  if( ~load_file_list )
    s_frage             = [];
    s_frage.comment     = 'Mat-Messdateien (oder erg-File auswählen (Aufklappen)) auswählen';
    s_frage.file_spec   = '*.mat';
    if( q.load_one_file )    
      s_frage.file_number = 1;
    else
      s_frage.file_number = 0;
    end
    if( q.use_start_dir && exist(q.start_dir,'file'))
        s_frage.start_dir = q.start_dir;
    else
        s_frage.start_dir = 'd:\';
    end
    [okay,c_filenames] = o_abfragen_files_f(s_frage);
    if( okay )
      q.file_list = c_filenames;
    else
      q.file_list = {};
    end
  end


  % Daten einlesen
  if( ~isempty(q.file_list) )
    [d,u,h] = mess_plot_read_data_read(q.file_list);
    s_file = str_get_pfe_f(q.file_list{length(q.file_list)});
    meas_dir = s_file.dir;
  end

end
function [d,u,h] = mess_plot_read_data_read(mess_files)

  if( ischar(mess_files) )
    mess_files = {mess_files};
  end
  for i=1:length(mess_files)

      file_name = mess_files{i};

      if( ~exist(file_name,'file') )

          error('mess_plot_read_data_read_error: Datei <%s> nicht vorhanden\n',file_name);
      end
      
      fprintf('read file <%s>\n',file_name);
      [okay,dd,uu,hh,ff] = d_data_read_mat(file_name);
      %[okay,s_data,n_data] = duh_mat_daten_einlesen_f(file_name);
      if( okay )
          fprintf('%s\n',file_name);
          if( i == 1 )
              d         = dd;
              u         = uu;        
          else
            [d,u]       = das_merge_struct_f(d,u,dd,uu,i);
%               d(i)         = s_data(1).d;
%               u(i)         = s_data(1).u;
          end
          h{i} = hh{1};
      end
  end

end

