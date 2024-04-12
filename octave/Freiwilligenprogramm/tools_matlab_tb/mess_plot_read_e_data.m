function [e,q,meas_dir] = mess_plot_read_e_data(q)
%
% [e,q,meas_dir] = mess_plot_read_e_data(q)
%
% e-Struktur-Matlabdaten einlesen
%
% q.load_one_file            0/1     nur ein File einlesen
% q.use_start_dir            0/1     Start-Dir soll benutzt werden
%                            2       benutze q.start_dir = qlast_get(1);
%                                    und     qlast_set(1,measdir);
% q.start_dir                string  Start-Dir zum suchen
%
% q.file_list                cellarray Liste der eingelesenen Filename
% q.load_file_list           0/1       Lade die file_liste ein, wenn
%                                      vorhanden
% e                          structs   Daten-, Unit- Struktur
%
%
  meas_dir         = '';
  e                = struct([]);
  
  if( ~isfield(q,'load_one_file') )
    q.load_one_file = 0;
  end
  if( ~isfield(q,'use_start_dir') )
    q.use_start_dir = 0;
  end
  if( ~isfield(q,'start_dir') )
    q.start_dir = '';
  end
  if( q.use_start_dir == 2 )
    if( ~isempty(qlast_get(1)) )
      q.start_dir = qlast_get(1);
    end
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
    s_frage.comment     = 'Mat-Messdateien als e-Struktur auswählen (xxx_e.mat)';
    s_frage.file_spec   = '*_e.mat';
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
    [e] = mess_plot_read_e_data_read(q.file_list);
    assignin('base','e_data_read_time',datestr(now,'dd-mmm-yyyy HH:MM:SS'))

    s_file = str_get_pfe_f(q.file_list{length(q.file_list)});
    meas_dir = s_file.dir;
    
    if( q.use_start_dir == 2 )
      qlast_set(1,meas_dir);
    end

  end

end
function [e] = mess_plot_read_e_data_read(mess_files)

  if( ischar(mess_files) )
    mess_files = {mess_files};
  end
  for i=1:length(mess_files)

      file_name = mess_files{i};

      if( ~exist(file_name,'file') )

          error('mess_plot_read_data_read_error: Datei <%s> nicht vorhanden\n',file_name);
      end
      
      fprintf('read file <%s>\n',file_name);
      [okay,ee,ff] = e_data_read_mat(file_name);
      %[okay,s_data,n_data] = duh_mat_daten_einlesen_f(file_name);
      if( okay )
          fprintf('%s\n',file_name);
          if( i == 1 )
           e         = ee;
          else
            e        = struct_array_add(e,ee,i);
          end
      end
  end

end

