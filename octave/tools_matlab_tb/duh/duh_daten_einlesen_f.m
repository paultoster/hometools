% $JustDate:: 15.11.05  $, $Revision:: 3 $ $Author:: Tftbe1    $
% $JustDate:: 15 $, $Revision:: 3 $ $Author:: Tftbe1    $
function s_duh = duh_daten_einlesen_f(s_duh)
%
% Daten einlesen
%
n_old = s_duh.n_data;

s_duh_liste = o_abfragen_verzweigung_liste_erstellen_f ...
  (1,'mat'                ,'mat-File im dSpace-, duh- canalyser, struct und Vektor-Datenformat einlesen' ...
  ,1,'das_auto'           ,'Datalyser einlesen' ...
  ,1,'das_prc'            ,'Datalyser mit prc-Filevorgabe einlesen' ...
  ,1,'das_einstell'       ,'Datalyser mit den Standard prc-Files einlesen(über Einstellung festlegen)' ...
  ,1,'das2'               ,'Datalyser(dl2) einlesen' ...
  ,1,'das2_prc'           ,'Datalyser(dl2) mit prc-File einlesen' ...
  ,1,'das2_einstell'      ,'Datalyser(dl2) mit prc-File aus Standardeinstellung einlesen (über Einstellung festlegen)' ...
  ,1,'dia'                ,'Diademdatei einlesen' ...
  ,1,'dascsv'             ,'csv-Datei (datalyser-generiert) einlesen' ...
  ,1,'csv'                ,'csv-Datei (erste Zeile Vektornamen, Seperator => ";", weitere Zeilen Werte' ...
  ,1,'workspace_struct'   ,'Struktur aus dem Workspace aufnehmen' ...
  ,1,'workspace_vec'      ,'Vektoren aus dem Workspace aufnehmen' ...
  ,1,'ascii_canalyser'    ,'Canalyser-Daten im ascii-Format' ...
  ,1,'scan_curve'         ,'Kurve einscannen (anhand einer bitmap-Datei)' ...
  ,1,'carmaker'           ,'CarMaker Erg-Datei einlesen' ...
  );

[end_flag,option,s_duh.s_prot,s_duh.s_remote] = o_abfragen_verzweigung_f(s_duh_liste,s_duh.s_prot,s_duh.s_remote);

if( end_flag )
  return;
end
switch option
  case 1 % mat-File im dSpace-Datenformat einlesen
    s_frage.comment        = 'mat-File im dSpace-, duh- oder canaylser- Datenformat festlegen';
    s_frage.command        = 'mat_data_file';
    s_frage.prot           = 1;
    s_frage.file_spec      = '*.mat';
    s_frage.start_dir      = s_duh.s_einstell.measure_dir;
    s_frage.file_number    = 0;
    
    [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( okay )
      for i=1:length(c_filenames)
        
        % Filename übergeben
        filename = char(c_filenames{i});
        
        [okay,s_data,n_data] = duh_mat_daten_einlesen_f(filename);
        
        if( ~okay )
          fprintf('duh_daten_einlesen_f: Die Daten aus File <%s> haben kein Daten im dSpace-Format',filename);
        else
          for j=1:n_data
            
            s_duh.n_data = s_duh.n_data + 1;
            s_duh.s_data(s_duh.n_data).d           = s_data(j).d;
            s_duh.s_data(s_duh.n_data).u           = s_data(j).u;
            s_duh.s_data(s_duh.n_data).h           = s_data(j).h;
            s_duh.s_data(s_duh.n_data).file        = s_data(j).file;
            s_duh.s_data(s_duh.n_data).name        = s_data(j).name;
            s_duh.s_data(s_duh.n_data).c_prc_files = s_data(j).c_prc_files;
          end
        end
      end
    end
  case {2,3,4} %Datalyser prc-File automatisch finden, vorgeben oder standard verwenden
    
    s_frage.comment        = 'dat-File im Datalyser-Datenformat festlegen';
    s_frage.command        = 'das_data_file';
    s_frage.prot           = 1;
    s_frage.file_spec      = '*.dat';
    s_frage.start_dir      = s_duh.s_einstell.measure_dir;
    s_frage.file_number    = 0;
    
    [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( okay )
      if( option == 2 ) %prc-Files automatisch bestimmen
        
        c_prc_files = {};
      elseif( option == 3 ) %prc-Files bestimmen
        
        s_frage.comment        = 'prc-File für Datalyser festlegen';
        s_frage.command        = 'prc_data_file';
        s_frage.prot           = 1;
        s_frage.file_spec      = '*.prc';
        s_frage.start_dir      = s_duh.s_einstell.measure_dir;
        s_frage.file_number    = 0;
        
        [okay,c_prc_files,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
      else %prc-Files aus Standardeisntellung
        
        n = length(s_duh.s_einstell.c_datalyser_prc_file);
        if( n ~= 0 )
          for i=1:n
            c_prc_files{i} = s_duh.s_einstell.c_datalyser_prc_file{i};
          end
        else
          fprintf('\nduh_daten_einlesen_f: Es sind keine Standard prc-Files festgelegt (gehe zu einstellung ändern)\n');
          okay = 0;
        end
      end
    end
    
    if( okay )
      
      for i=1:length(c_filenames)
        
        % Filename übergeben
        filename = char(c_filenames{i});
        
        [okay,s_data] = duh_das_daten_einlesen_f(filename,c_prc_files);
        
        if( ~okay )
          fprintf('duh_daten_einlesen_f: Die Daten aus File <%s> haben kein Daten im das-Format oder prc-File konnte nicht gefunden werden',filename);
        else
          s_duh.n_data = s_duh.n_data + 1;
          s_duh.s_data(s_duh.n_data).d           = s_data.d;
          s_duh.s_data(s_duh.n_data).u           = s_data.u;
          s_duh.s_data(s_duh.n_data).h           = s_data.h;
          s_duh.s_data(s_duh.n_data).file        = s_data.file;
          s_duh.s_data(s_duh.n_data).name        = s_data.name;
          s_duh.s_data(s_duh.n_data).c_prc_files = s_data.c_prc_files;
        end
      end
    end
  case {5,6,7} %Datalyser(dl2) mit prc- und a2l-File einlesen
    
    s_frage.comment        = 'dl2-File im Datalyser2-Datenformat festlegen';
    s_frage.command        = 'das2_data_file';
    s_frage.prot           = 1;
    s_frage.file_spec      = '*.dl2';
    s_frage.start_dir      = s_duh.s_einstell.measure_dir;
    s_frage.file_number    = 0;
    
    [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( okay )
      
      if( option == 6 )
        s_frage.comment        = 'prc-File für Datalyser2 festlegen';
        s_frage.command        = 'prc_data_file';
        s_frage.prot           = 1;
        s_frage.file_spec      = '*.prc';
        s_frage.start_dir      = s_duh.start_dir;
        s_frage.file_number    = 0;
        
        [okay,c_prc_files,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
      elseif( option == 7 )
        
        n = length(s_duh.s_einstell.c_datalyser_prc_file);
        if( n ~= 0 )
          for i=1:n
            c_prc_files{i} = s_duh.s_einstell.c_datalyser_prc_file{i};
          end
        else
          fprintf('\nduh_daten_einlesen_f: Es sind keine Standard prc-Files festgelegt (gehe zu einstellung ändern)\n');
          okay = 0;
        end
        
      else
        c_prc_files = {};
      end
      if( okay )
        
        for i=1:length(c_filenames)
          
          % Filename übergeben
          filename = char(c_filenames{i});
          
          [okay,s_data] = duh_das2_daten_einlesen_f(filename,c_prc_files);
          
          if( ~okay )
            fprintf('duh_daten_einlesen_f: Die Daten aus File <%s> haben kein Daten im das2-Format oder prc-File bzw. a2l-File  konnte nicht gefunden werden',filename);
          else
            s_duh.n_data = s_duh.n_data + 1;
            s_duh.s_data(s_duh.n_data).d           = s_data.d;
            s_duh.s_data(s_duh.n_data).u           = s_data.u;
            s_duh.s_data(s_duh.n_data).h           = s_data.h;
            s_duh.s_data(s_duh.n_data).file        = s_data.file;
            s_duh.s_data(s_duh.n_data).name        = s_data.name;
            s_duh.s_data(s_duh.n_data).c_prc_files = s_data.c_prc_files;
            
            if( length(s_duh.s_data(s_duh.n_data).d) == 0 )
              
              warning('Keine Daten konnten eingelsen werden\nmöglicherweise war asap-File nicht vorhanden')
            end
          end
          
          
        end
      end
      
    end
  case 8 %Diademdatei
    
    s_frage.comment        = 'dia-File im Diadem-Datenformat festlegen';
    s_frage.command        = 'dia_data_file';
    s_frage.prot           = 1;
    s_frage.file_spec      = '*.dat';
    s_frage.start_dir      = s_duh.s_einstell.measure_dir;
    s_frage.file_number    = 0;
    
    [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( okay )
      for i=1:length(c_filenames)
        
        % Filename übergeben
        filename = char(c_filenames{i});
        
        [okay,s_data] = duh_dia_daten_einlesen_f(filename);
        
        if( ~okay )
          fprintf('duh_daten_einlesen_f: Die Daten aus File <%s> haben kein Daten im dia-Format ',filename);
        else
          s_duh.n_data = s_duh.n_data + 1;
          s_duh.s_data(s_duh.n_data).d           = s_data.d;
          s_duh.s_data(s_duh.n_data).u           = s_data.u;
          s_duh.s_data(s_duh.n_data).h           = s_data.h;
          s_duh.s_data(s_duh.n_data).file        = s_data.file;
          s_duh.s_data(s_duh.n_data).name        = s_data.name;
          s_duh.s_data(s_duh.n_data).c_prc_files = s_data.c_prc_files;
        end
      end
    end
  case 9 %dascsv-datei
    
    s_frage.comment        = 'csv-File von Datalyser2 festlegen';
    s_frage.command        = 'dascsv_data_file';
    s_frage.prot           = 1;
    s_frage.file_spec      = '*.csv';
    s_frage.start_dir      = s_duh.s_einstell.measure_dir;
    s_frage.file_number    = 0;
    
    [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( okay )
      
      for i=1:length(c_filenames)
        
        % Filename übergeben
        filename = char(c_filenames{i});
        
        [okay,s_data] = duh_dascsv_daten_einlesen_f(filename);
        
        if( ~okay )
          fprintf('duh_daten_einlesen_f: Die Daten aus File <%s> haben kein Daten im dia-Format ',filename);
        else
          
          s_frage.c_liste        = fieldnames(s_data.d);
          s_frage.c_name         = fieldnames(s_data.d);
          s_frage.frage          = 'Zeitbasis auswählen (unabhängige Variable)';
          s_frage.command        = 'x_vec_name';
          s_frage.single         = 1;
          s_frage.sort_list      = 1;
          
          [okay,iv,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
          
          if( okay )
            
            if( iv ~= 1 )
              
              if( isfield(s_data.d,s_frage.c_liste{iv}) )
                d.(s_frage.c_liste{iv}) = getfield(s_data.d,s_frage.c_liste{iv});
              end
              if( isfield(s_data.u,s_frage.c_liste{iv}) )
                u.(s_frage.c_liste{iv}) = getfield(s_data.u,s_frage.c_liste{iv});
              end
              
              for j=1:length(s_frage.c_liste)
                if( j ~= iv )
                  if( isfield(s_data.d,s_frage.c_liste{j}) )
                    d.(s_frage.c_liste{j}) = getfield(s_data.d,s_frage.c_liste{j});
                  end
                  if( isfield(s_data.u,s_frage.c_liste{j}) )
                    u.(s_frage.c_liste{j}) = getfield(s_data.u,s_frage.c_liste{j});
                  end
                end
              end
              
              s_data.d = d;
              s_data.u = u;
            end
            
            s_duh.n_data = s_duh.n_data + 1;
            s_duh.s_data(s_duh.n_data).d           = s_data.d;
            s_duh.s_data(s_duh.n_data).u           = s_data.u;
            s_duh.s_data(s_duh.n_data).h           = s_data.h;
            s_duh.s_data(s_duh.n_data).file        = s_data.file;
            s_duh.s_data(s_duh.n_data).name        = s_data.name;
            s_duh.s_data(s_duh.n_data).c_prc_files = s_data.c_prc_files;
          end
        end
      end
    end
  case 10 %csv-datei
    
    s_frage.comment        = 'csv-File festlegen';
    s_frage.command        = 'csv_data_file';
    s_frage.prot           = 1;
    s_frage.file_spec      = '*.csv';
    s_frage.start_dir      = s_duh.s_einstell.measure_dir;
    s_frage.file_number    = 0;
    
    [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( okay )
      
      s_frage.c_liste = {'keinen Header in csv-Datei vorhanden','1. Zeile Headerlinie mit Namen','1. Zeile Headerlinie mit Namen, 2.Zeile mit units'};
      s_frage.c_name  = {'no','name','name+unit'};
      s_frage.frage   = 'Waehle eine Option aus';
      s_frage.command = 'csv_type';
      s_frage.single  = 1;
      
      [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
      
      if( okay )
        typ = selection-1;
        
        for i=1:length(c_filenames)
          
          % Filename übergeben
          filename = char(c_filenames{i});
          
          [okay,s_data] = duh_csv_daten_einlesen_f(filename,';',typ);
          
          if( ~okay )
            fprintf('duh_daten_einlesen_f: Die Daten aus File <%s> haben kein Daten im dia-Format ',filename);
          else
            
            s_frage.c_liste        = fieldnames(s_data.d);
            s_frage.c_name         = fieldnames(s_data.d);
            s_frage.frage          = 'Zeitbasis auswählen (unabhängige Variable)';
            s_frage.command        = 'x_vec_name';
            s_frage.single         = 1;
            s_frage.sort_list      = 1;
            
            [okay,iv,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
              
              if( iv ~= 1 )
                
                if( isfield(s_data.d,s_frage.c_liste{iv}) )
                  d.(s_frage.c_liste{iv}) = getfield(s_data.d,s_frage.c_liste{iv});
                end
                if( isfield(s_data.u,s_frage.c_liste{iv}) )
                  u.(s_frage.c_liste{iv}) = getfield(s_data.u,s_frage.c_liste{iv});
                end
                
                for j=1:length(s_frage.c_liste)
                  if( j ~= iv )
                    if( isfield(s_data.d,s_frage.c_liste{j}) )
                      d.(s_frage.c_liste{j}) = getfield(s_data.d,s_frage.c_liste{j});
                    end
                    if( isfield(s_data.u,s_frage.c_liste{j}) )
                      u.(s_frage.c_liste{j}) = getfield(s_data.u,s_frage.c_liste{j});
                    end
                  end
                end
                
                s_data.d = d;
                s_data.u = u;
              end
              
              s_duh.n_data = s_duh.n_data + 1;
              s_duh.s_data(s_duh.n_data).d           = s_data.d;
              s_duh.s_data(s_duh.n_data).u           = s_data.u;
              s_duh.s_data(s_duh.n_data).h           = s_data.h;
              s_duh.s_data(s_duh.n_data).file        = s_data.file;
              s_duh.s_data(s_duh.n_data).name        = s_data.name;
              s_duh.s_data(s_duh.n_data).c_prc_files = s_data.c_prc_files;
            end
          end
        end
      end
    end
  case 11 %workspace_struct-variablen
    
    if( ~isempty(s_duh.workspace_structs) )
      
      clear s_frage
      
      s_frage.c_liste = s_duh.workspace_structs;
      s_frage.c_name  = s_duh.workspace_structs;
      
      s_frage.frage          = 'Eine Struktur aus dem Workspace auswählen ?';
      s_frage.command        = 'workspace_struct';
      s_frage.prot_name      = 1;
      s_frage.single         = 1;
      s_frage.sort_list      = 1;
      
      [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
      
      if( okay )
        
        i = 0;
        
        i=i+1;s_duh.c_post_command{i} = sprintf('s_duh.n_data = s_duh.n_data + 1;');
        i=i+1;s_duh.c_post_command{i} = sprintf('s_duh.s_data(s_duh.n_data).d = %s;',s_duh.workspace_structs{selection});
        i=i+1;s_duh.c_post_command{i} = sprintf('cnames152 = fieldnames(%s);',s_duh.workspace_structs{selection});
        i=i+1;s_duh.c_post_command{i} = sprintf('for i152=1:length(cnames152),s_duh.s_data(s_duh.n_data).u.(cnames152{i152}) = '''';end');
        i=i+1;s_duh.c_post_command{i} = sprintf('clear cnames152 i152');
        i=i+1;s_duh.c_post_command{i} = sprintf(sprintf('s_duh.s_data(s_duh.n_data).h = {''%s'','' read-workspace_struct-data''};',[s_duh.workspace_structs{selection},'_from_workspace']));
        i=i+1;s_duh.c_post_command{i} = sprintf(sprintf('s_duh.s_data(s_duh.n_data).file = ''%s'';',[s_duh.workspace_structs{selection},'_from_workspace']));
        i=i+1;s_duh.c_post_command{i} = sprintf(sprintf('s_duh.s_data(s_duh.n_data).name = ''%s'';',s_duh.workspace_structs{selection}));
        i=i+1;s_duh.c_post_command{i} = sprintf(sprintf('s_duh.s_data(s_duh.n_data).c_prc_files = '''';'));
        
        % Post command run anschalten und füllen
        s_duh.post_command_run = 1;
      end
    end
  case 12 %workspace_vec-variablen
    
    if( ~isempty(s_duh.workspace_vec) )
      
      clear s_frage
      
      s_frage.c_liste = s_duh.workspace_vec;
      s_frage.c_name  = s_duh.workspace_vec;
      
      s_frage.frage          = 'Welche Vektoren aus dem Workspace aufnehmen ?';
      s_frage.command        = 'workspace_struct';
      s_frage.prot_name      = 1;
      s_frage.single         = 0;
      s_frage.sort_list      = 1;
      
      [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
      
      if( okay )
        
        i = 0;
        
        i=i+1;s_duh.c_post_command{i} = sprintf('s_duh.n_data = s_duh.n_data + 1;');
        for isel=1:length(selection)
          i=i+1;s_duh.c_post_command{i} = sprintf('s_duh.s_data(s_duh.n_data).d.%s = %s;',s_duh.workspace_vec{selection(isel)},s_duh.workspace_vec{selection(isel)});
          i=i+1;s_duh.c_post_command{i} = sprintf('s_duh.s_data(s_duh.n_data).u.%s = '''';',s_duh.workspace_vec{selection(isel)});
        end
        i=i+1;s_duh.c_post_command{i} = sprintf('s_duh.s_data(s_duh.n_data).h = {''read-workspace_vec-data''};');
        i=i+1;s_duh.c_post_command{i} = sprintf(sprintf('s_duh.s_data(s_duh.n_data).file = '''';'));
        i=i+1;s_duh.c_post_command{i} = 'name152=sprintf(''vec%i'',s_duh.n_data);';
        i=i+1;s_duh.c_post_command{i} = sprintf('s_duh.s_data(s_duh.n_data).name = name152;');
        i=i+1;s_duh.c_post_command{i} = sprintf('clear names152');
        i=i+1;s_duh.c_post_command{i} = sprintf(sprintf('s_duh.s_data(s_duh.n_data).c_prc_files = '''';'));
        
        % Post command run anschalten und füllen
        s_duh.post_command_run = 1;
      end
    end
  case 13 % Ascii-Canalyser
    
    [okay,s_duh] = duh_daten_einlesen_acii_canalyser(s_duh);
    
  case 14 % Kurven scannen
    
    
    [okay,s_duh] = duh_scan_daten_einlesen_f(s_duh);
    
  case 15 % CarMaker Erg-Dateien
    s_frage.comment        = 'erg-File im CarMaker-Datenformat festlegen';
    s_frage.command        = 'carmaker_erg_file';
    s_frage.prot           = 1;
    s_frage.file_spec      = '*.erg';
    if( str_find_f(s_duh.s_einstell.carmaker_project_dir,'SimOutput') > 0 )
      s_frage.start_dir      = s_duh.s_einstell.carmaker_project_dir;
    else
      s_frage.start_dir      = fullfile(s_duh.s_einstell.carmaker_project_dir,'SimOutput');
    end
    if( ~exist(s_frage.start_dir,'dir') )
      s_frage.start_dir = '.';
    end
    s_frage.file_number    = 0;
    
    [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( okay )
      for i=1:length(c_filenames)
        
        % Filename übergeben
        filename = char(c_filenames{i});
        
        [okay,s_data] = duh_carmaker_daten_einlesen_f(filename);
        
        if( ~okay )
          fprintf('duh_daten_einlesen_f: Die Daten aus File <%s> haben kein Daten im carmaker-Format ',filename);
        else
          s_duh.n_data = s_duh.n_data + 1;
          s_duh.s_data(s_duh.n_data).d           = s_data.d;
          s_duh.s_data(s_duh.n_data).u           = s_data.u;
          s_duh.s_data(s_duh.n_data).h           = s_data.h;
          s_duh.s_data(s_duh.n_data).file        = s_data.file;
          s_duh.s_data(s_duh.n_data).name        = s_data.name;
          s_duh.s_data(s_duh.n_data).c_prc_files = s_data.c_prc_files;
        end
      end
    end
    
end

if( okay )
  for i=n_old+1:s_duh.n_data
    if( ~isempty(s_duh.s_data(i).d) )
      duh_daten_einlesen_proof(s_duh.s_data(i),s_duh.s_prot)
    else
      warning('Es wurden keine Daten eingelesen !!!')
    end
  end
end

function duh_daten_einlesen_proof(s_data,s_prot)

%Abtastung Prüfen

c_n = {};
icount = 0;
c_names = fieldnames(s_data.d);

for i=1:length(c_names)
  
  command = sprintf('n = length(s_data.d.%s);',char(c_names{i}));
  eval(command)
  
  if( length(c_n) == 0 )
    icount = 1;
    c_n{icount} = n;
  else
    
    flag = 0;
    for j=1:length(c_n)
      
      if( c_n{j} == n )
        flag = 1;
        break;
      end
    end
    if( ~flag )
      icount = icount + 1;
      c_n{icount} = n;
    end
  end
end

if( length(c_n) > 1 )
  
  text = sprintf('=========================================\n\n');
  o_ausgabe_f(text,s_prot.debug_fid);
  text = sprintf('warning: in Data_set %s found different sampling times\n',s_data.name);
  o_ausgabe_f(text,s_prot.debug_fid);
  for i=1:length(c_n)
    text = sprintf('n%i =  %i\n',i,c_n{i});
    o_ausgabe_f(text,s_prot.debug_fid);
  end
  text = sprintf('\n=========================================\n');
  o_ausgabe_f(text,s_prot.debug_fid);
end



