function [okay,s_duh] = duh_daten_einlesen_acii_canalyser(s_duh)
%
% Daten einlesen
%
%
okay = 1;
c_file      = {};
c_dbc      = s_duh.s_einstell.c_dbc_file;
dbc_tbd    = length(c_dbc) == 0;

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'can_ascii_data_file'      ,c_file   ,'Ascii-Canalyser-Messdatei(en) auswählen' ...
             ,dbc_tbd,'dbc_file'                 ,c_dbc    ,'dbc-Datei(en) für CANalyser-Auswertung auswählen (aus Einstellung möglich)' ...
             ,1      ,'delta_t'                  ,0        ,'Abtastrate in s' ...
             ,1      ,'chanvec'                  ,0        ,'Kanalnummer beginnend mit 0' ...
             );
option_flag = 1;

while( option_flag )
	
	[end_flag,option_flag,option,s_liste,s_duh.s_prot,s_duh.s_remote] = ...
                                      o_abfragen_werte_liste_f(s_liste,s_duh.s_prot,s_duh.s_remote);
	
	if( end_flag )
       okay = 0;
       return;
    end
    if( option == 'f' ) % Prüfen ob alles richtig
        
        if( length(s_liste(1).c_value) == 0 ) % ascii-File leer
            
            fprintf('Kein Canalyser Messdatei ausgewählt\n')
            option = 1;
            option_flag = 1;
        elseif( length(s_liste(2).c_value) == 0 ) % kein dbc-File

            fprintf('Kein CAN-Beschreibungsdatei dbc-File ausgewählt\n')
            option = 2;
            option_flag = 1;
        end
    end
	if( option_flag )
        
        if( exist('s_frage') == 1 )
            clear s_frage
        end
        switch option
            
            case 1            
				s_frage.comment     = 'Canalyser Messdaten auswählen';    % Kommentar
				s_frage.command     = 'can_ascii_data_file';              % Kommando fürs Protokoll
                s_frage.file_spec   = '*.asc';
				s_frage.start_dir   = s_duh.s_einstell.measure_dir;       % Start-Verzeichnis zum suchen
                s_frage.file_number = 0;
                                                                       
                [okay,c_filenames] = o_abfragen_files_f(s_frage);
                
                if( okay ) % 
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = c_filenames;
                else
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = {};
                    %return;
                end
                
            case 2
                s_frage.comment   = 'CAN-Beschreibungsdatei dbc-Files auswählen';
                s_frage.command   = 'dbc_files';
                s_frage.file_spec ='*.dbc';
                s_frage.start_dir = s_duh.s_einstell.measure_dir;
                s_frage.file_number    = 0;

                [okay,c_filenames] = o_abfragen_files_f(s_frage);

                if( okay ) % 
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = c_filenames;
                else
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = {};
                    %return;
                end
           case 3
                s_frage.frage   = 'Welche Schrittweite soll verwendet werden';
                s_frage.command = 'delta_t';
                s_frage.type    = 'double';
                s_frage.min     = 0.00000000001;
                s_frage.default = 0.01;

                [okay,value] = o_abfragen_wert_f(s_frage);

                if( okay ) % 
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = value;
                else
                    s_liste(option).tbd     = 1;
                    s_liste(option).c_value = {};
                    %return;
                end
            case 4
                
                % dbc-Files sind bestimmt worden
                if( s_liste(2).tbd == 0 )
                    s_frage.c_comment{1}   = 'Welche(r) Messkana(e)l(e) soll(en) eingelesen werden, ';
                    s_frage.c_comment{2}   = sprintf('bezogen auf die Reihenfolge der DBC-Files(%i-Stück),',length(s_liste(2).c_value));
                    s_frage.c_comment{3}   = 'beginnend mit null';
                    s_frage.command = 'chanvec';
                    s_frage.type    = 'double';             
                    s_frage.default = [];
                    for(idbc=1:length(s_liste(2).c_value))                    
                        s_frage.default(idbc) = idbc-1;
                    end
                    s_frage.default = s_frage.default';
                    
                    [okay,value] = o_abfragen_vektor_f(s_frage);

                    if( okay ) % 
                        s_liste(option).tbd        = 0;
                        for ichan=1:length(value)
                            s_liste(option).c_value{ichan} = value(ichan);
                        end
                    else
                        s_liste(option).tbd     = 1;
                        s_liste(option).c_value = {};
                        %return;
                    end
                else
                    fprintf('Esrt muß DBC-File angegeben sein\n')
                end
               
        end
	end
end

% Can-Messung einlesen:
%=====================
ctl.dbc_file  = s_liste(2).c_value;

ctl.dspace_format_flag = 1;
ctl.sort_flag          = 1;

delta_t = s_liste(3).c_value{1};
chanvec = [];
for ichan=1:length(s_liste(4).c_value)
    chanvec(ichan) = s_liste(4).c_value{ichan};
end

for i=1:length(s_liste(1).c_value)

    ctl.mess_file = s_liste(1).c_value{i};

    % alt:
    %dspa = can_wand_mess(ctl);
    %[okay,d,u,c_h] = data_transform_dspa_to_duh_f(dspa);
    % neu 9.2.09

    [okay,s_data] = duh_ascii_canalyser_daten_einlesen_f(ctl.mess_file,ctl.dbc_file,chanvec,delta_t);
    s_duh.n_data               = s_duh.n_data + 1;
    s_duh.s_data(s_duh.n_data) = s_data;
    
%     % Daten einlesen in Struktur
%     d = 0;
%     u = 0;
% 	for j=1:min(length(ctl.dbc_file),length(chanvec))
%         [d0,u0] = canread(ctl.mess_file,ctl.dbc_file{j},delta_t,chanvec(j));
% 	%       clear mex
%     
%         if( j == 1 )
%             d = d0;
%             u = u0;
%         else
%             if( ~isstruct(d0) )
%                 okay = 0;
%             else
%                [d,u] = das_merge_struct_f(d,u,d0,u0);
%                d     = struct_reduce_vecs_to_min_length(d);
%             end
%         end
% 	end
%     if( okay )
%         s_duh.n_data = s_duh.n_data + 1;
%         s_duh.s_data(s_duh.n_data).d           = d;
%         s_duh.s_data(s_duh.n_data).u           = u;
%         s_duh.s_data(s_duh.n_data).h           = {'Canalyser-Daten'};
%         s_duh.s_data(s_duh.n_data).file        = ctl.mess_file;
%         s_file                                 = str_get_pfe_f(ctl.mess_file);
%         s_duh.s_data(s_duh.n_data).name        = s_file.name;
%         s_duh.s_data(s_duh.n_data).c_prc_files = ctl.dbc_file;
%     end
end

