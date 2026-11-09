% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function s_duh = duh_daten_speichern_f(s_duh)
%
% Daten einlesen
%

s_duh_liste = o_abfragen_verzweigung_liste_erstellen_f ...
             (1,'dspa'               ,'mat-File im dSpace-Format speichern(für Wave verwendbar)' ...
             ,1,'duh'                ,'mat-File im duh-Format speichern' ...
             ,1,'vec'                ,'mat-File in Vektor-Format speichern' ...
             ,1,'csv'                ,'Daten im csv-Fileformat speichern' ... 
             ,1,'dia_asc'            ,'Dia-Datenfileformat ascii-Format(sehr langsam)' ...
             ,1,'dia'                ,'Dia-Datenfileformat r32-Format' ...
             ,1,'m'                  ,'m-Filedatenformat (nur für kleine Datenmengen sinnvoll)' ...
             );

[end_flag,option,s_duh.s_prot,s_duh.s_remote] = o_abfragen_verzweigung_f(s_duh_liste,s_duh.s_prot,s_duh.s_remote);

if( end_flag )
   return;
end

if( s_duh.n_data == 0 )
    if( ~s_duh.s_remote.run_flag )
        input('Keine Daten vorhanden (Weiter mit <return>)','s')
    end
else
    
    for i= 1:s_duh.n_data
        s_frage.c_liste{i} = sprintf('%i. %s',i,s_duh.s_data(i).file);
    end
    
    s_frage.frage          = 'Datensatz auswählen ?';
    s_frage.command        = 'data_set';
    s_frage.single         = 1;
    s_frage.prot           = 1;

    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    value = selection(1);
    
    if( ~okay )
        return;
    end

    switch option
        case 1 % Dspace-Datenformat
			s_frage.comment        = 'mat-File für dSpace-Datenformat (z.B. dspa_xyz.mat)';
			s_frage.command        = 'mat_data_file';
			s_frage.prot           = 1;
			s_frage.file_spec      = '*.mat';
			s_frage.start_dir      = s_duh.s_einstell.measure_dir;
			s_frage.file_number    = 1;
            s_frage.put_file       = 1;
			
			[okay,c_filename,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
			
			if( okay )
                
                % Filename übergeben
                filename = char(c_filename{1});
                duh_daten_speichern_format(s_duh.s_data(value),filename,'dspa');
            end
        case 2 % duh-Datenformat
			s_frage.comment        = 'mat-File für duh-Datenformat  (z.B. duh_xyz.mat)';
			s_frage.command        = 'mat_data_file';
			s_frage.prot           = 1;
			s_frage.file_spec      = '*.mat';
			s_frage.start_dir      = s_duh.s_einstell.measure_dir;
			s_frage.file_number    = 1;
            s_frage.put_file       = 1;
			
			[okay,c_filename,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
			
			if( okay )
                
                % Filename übergeben
                filename = char(c_filename{1});
                duh_daten_speichern_format(s_duh.s_data(value),filename,'duh');
                
            end
         case 3 % vektor-Datenformat
			s_frage.comment        = 'mat-File, alle Signale als Vektor schreiben';
			s_frage.command        = 'mat_data_file';
			s_frage.prot           = 1;
			s_frage.file_spec      = '*.mat';
			s_frage.start_dir      = s_duh.s_einstell.measure_dir;
			s_frage.file_number    = 1;
            s_frage.put_file       = 1;
			
			[okay,c_filename,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
			
			if( okay )
                
                % Filename übergeben
                filename = char(c_filename{1});
                duh_daten_speichern_format(s_duh.s_data(value),filename,'vec');
                
            end
       case 4 % csv-Datenformat
			s_frage.comment        = 'csv-File für Datenspeichern  (z.B. xyz.csv)';
			s_frage.command        = 'csv_data_file';
			s_frage.prot           = 1;
			s_frage.file_spec      = '*.csv';
			s_frage.start_dir      = s_duh.s_einstell.measure_dir;
			s_frage.file_number    = 1;
            s_frage.put_file       = 1;
			
			[okay,c_filename,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
			
			if( okay )
                
                % Filename übergeben
                filename = char(c_filename{1});
                duh_daten_speichern_format(s_duh.s_data(value),filename,'csv');
                
            end
        case {5,6} % dia-Datenformat
			s_frage.comment        = 'dia-File für Datenspeichern  (z.B. xyz.dat)';
			s_frage.command        = 'dia_data_file';
			s_frage.prot           = 1;
			s_frage.file_spec      = '*.dat';
			s_frage.start_dir      = s_duh.s_einstell.measure_dir;
			s_frage.file_number    = 1;
            s_frage.put_file       = 1;
			
			[okay,c_filename,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
			
			if( okay )
                
                % Filename übergeben
                filename = char(c_filename{1});
                if( option == 4 )
                    duh_daten_speichern_format(s_duh.s_data(value),filename,'dia_asc');
                else
                    duh_daten_speichern_format(s_duh.s_data(value),filename,'dia');
                end
                
            end
        case 7 % m-Datenformat
			s_frage.comment        = 'm-File für Datenspeichern  (z.B. xyz.m)';
			s_frage.command        = 'm_data_file';
			s_frage.prot           = 1;
			s_frage.file_spec      = '*.m';
			s_frage.start_dir      = s_duh.s_einstell.measure_dir;
			s_frage.file_number    = 1;
            s_frage.put_file       = 1;
			
			[okay,c_filename,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
			
			if( okay )
                
                % Filename übergeben
                filename = char(c_filename{1});
                duh_daten_speichern_format(s_duh.s_data(value),filename,'m');
                
            end
    end
        
end

