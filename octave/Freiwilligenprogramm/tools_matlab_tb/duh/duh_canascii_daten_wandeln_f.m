function s_duh = duh_canascii_daten_wandeln_f(s_duh)
%
% Daten einlesen
%
%
c_dir      = {};
c_my_func  = s_duh.s_einstell.c_my_func_file;

if( exist(char(c_my_func),'file') ==  0 )
    c_my_func = {};
end
if( length(c_my_func) > 0 )
    my_f_on = 1;
else
    my_f_on = 0;
end
s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1         ,'measure_dir'      ,c_dir    ,'Verzeichnisse mit datalyser-Daten zum wandeln auswählen' ...
             ,1         ,'dbc_file'         ,0        ,'dbc-Datei(en) für CANalyser-Auswertung auswählen (aus Einstellung möglich)' ...
             ,1         ,'delta_t'          ,0        ,'Abtastrate in s' ...
             ,1         ,'chanvec'          ,0        ,'Kanalnummer beginnend mit 0' ...
             ,0         ,'my_func_on'       ,my_f_on  ,'eigene(s) m-File(s) nutzen' ...
             ,0         ,'my_func'          ,c_my_func,'m-File (my_name.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,h]=my_func(d,u,h)' ...
             ,0         ,'output_format'    ,'dspa'   ,'Ausgabeformat (dspa (für wave), duh, dia)' ...
             ,0         ,'insert_file_name' ,'dspa_'  ,'Zusatzname vor Messdateiname (zB mess01.dat > wave_mess01.dat)' ...
             );
option_flag = 1;

while( option_flag )
	
	[end_flag,option_flag,option,s_liste,s_duh.s_prot,s_duh.s_remote] = ...
                                      o_abfragen_werte_liste_f(s_liste,s_duh.s_prot,s_duh.s_remote);
	
	if( end_flag )
       return;
	end
	if( option_flag )
        
        if( exist('s_frage') == 1 )
            clear s_frage
        end
        switch option
            
            case 1            
				s_frage.comment   = 'Verzeichnisse auswählen';         % Kommentar
				s_frage.command   = '';                                % Kommando fürs Protokoll
				s_frage.start_dir = s_duh.s_einstell.measure_dir;    % Start-Verzeichnis zum suchen
				s_frage.multi_dir = 1;                                  % 0 ein Verzeichnis auchen 1: beliebige
                                                                       % Unterverzeichnisse finden
				[okay,c_dir] = o_abfragen_dir_f(s_frage); % ohne Protokoll und remote
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = c_dir;
%                else
%                    return;
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

            case 5 % eigene(s) m-File(s) nutzen
                s_frage.comment  = 'eigene(s) m-File(s) nutzen?';
                s_frage.default  = 1;
                s_frage.def_value  = ~s_liste(option).c_value{1};

                if( o_abfragen_jn_f(s_frage) )
                    s_liste(option).c_value{1} = 1;
                    if( exist(char(c_my_func),'file') ==  0 )
                        c_my_func = {};
                        s_liste(option+1).tbd = 1
                    else
                        s_liste(option+1).c_value  = s_duh.s_einstell.c_my_func_file;
                    end
                else
                    s_liste(option).c_value{1} = 0;
                    s_liste(option+1).c_value  = {};
                end
                s_liste(option).tbd     = 0;
                
                
            case 6
                s_frage.comment   = 'm-File (my_func.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,h]=my_func(d,u,h)';
                s_frage.file_spec ='*.m';
                s_frage.start_dir = s_duh.start_dir;
                s_frage.file_number    = 0;

                [okay,c_filenames] = o_abfragen_files_f(s_frage);

                if( okay )
                    s_duh.s_einstell.c_my_func_file = c_filenames;
                end
                if( okay ) % 
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = c_filenames;
                end

            case 7
                s_frage.c_liste{1} = 'dspa';          % enthält text für die Auswahlliste
                s_frage.c_liste{2} = 'duh';           % enthält text für die Auswahlliste
                s_frage.c_liste{3} = 'dia';           % enthält text für die Auswahlliste
                s_frage.c_liste{4} = 'dia_asc';       % enthält text für die Auswahlliste
                s_frage.frage      = 'In welchem Format sollen die Daten gespeichert';
                s_frage.single     = 1;
               
                [okay,selection] = o_abfragen_listbox_f(s_frage);
                if( okay )
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = s_frage.c_liste{selection};
                    %else
                    %return;
                end
                
            case 8
                s_frage.c_comment = {}; %     enthält Kommentar ohne Zeilenumbruch (Auswahlliste, etc.)
                s_frage.frage     = 'Welchen Zusatznamen vor die Messdateien einfügen'; %    Frage nach dem Wert
                s_frage.type      = 'char'; % Type angeben (default)
                [okay,value]      = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = value;
                    %else
                    %return;
                end
                
        end
	end
end

% Auswerten
start_time = cputime;

n_data = duh_das2_daten_wandeln_do_f(s_liste(1).c_value,s_liste(2).c_value,s_liste(3).c_value{1},s_liste(4).c_value, ...
                                s_liste(6).c_value,s_liste(7).c_value{1},s_liste(8).c_value{1});
end_time = cputime;
a=sprintf('\nstart: %g end: %g delta: %g\ndata_sets: %g time/data_set: %g\n', ...
          start_time,end_time,end_time-start_time,n_data,(end_time-start_time)/max(n_data,1));
o_ausgabe_f(a,s_duh.s_prot.debug_fid);
                   
function   n_data = duh_das2_daten_wandeln_do_f(c_dir, c_dbc_files, delta_t,c_chanvec, ...
                                            c_my_func_file,output_format,insert_name)

n_data = 0;                              
if( nargin < 3 )
    error('duh_daten_wandeln_f:duh_daten_wandeln_do_f Zu wenige Argumante')
end
if( nargin < 7 )
    insert_name = '';
end
if( nargin < 6 )
    output_format = 'dspa';
end
if( nargin < 5 )
    c_my_func_file = {};
end
if( nargin < 4 )
    for i=  1:length(c_dbc_files)
        c_chanvec{i} = i-1;
    end
end

% Unterpfade abfragen
c_sub = s_subpathes_f(c_dir);

% DAtalyserfiles suchen
s_files = suche_files_ext(c_sub,'asc');

chanvec = [];
for ichan=1:length(c_chanvec)
    chanvec(ichan) = c_chanvec{ichan};
end


% Files einlesen, bearbeiten und ausgeben
for i=1:length(s_files)
        
    % Datalayserdaten einlesen
    n_data = n_data+1;
    [okay,s_data] = duh_ascii_canalyser_daten_einlesen_f(s_files(i).fullname,c_dbc_files,chanvec,delta_t);
    
    
    if( ~okay )
        return
    else
        
        
        % eigene Funktion ausführen
        n = length( c_my_func_file );
        if(  n > 0 )
            
            for j=1:n

                if( length(c_my_func_file{j}) > 0 )
                    s_file = str_get_pfe_f( c_my_func_file{j} );
                    
                    o_ausgabe_f('\n--------------------------------------------------------------------------\n',0);
                    if( length(s_file.dir) > 0 )
                        act_dir = pwd;
                        command = ['cd ',s_file.dir];
                        o_ausgabe_f(command,0);
                        o_ausgabe_f('\n',0);
                        eval(command);
                    else
                        act_dir = '.'
                    end
                    
                    command = ['[s_data.d,s_data.u,s_data.h] = ',s_file.name,'(s_data.d,s_data.u,s_data.h);'];
                    o_ausgabe_f(command,0);
                    o_ausgabe_f('\n',0);
                    eval(command);
	
                    command = ['cd ',act_dir];
                    eval(command);
                    o_ausgabe_f('\n--------------------------------------------------------------------------',0);
                    s_data.u = duh_check_du_f(s_data.d,s_data.u);
                end
            end
        end
        
        % Namen für abspeichern festlegen
        filename = [s_files(i).dir,'\',insert_name,s_files(i).name];
        

        % Daten speichern        
        duh_daten_speichern_format(s_data,filename,output_format);
               
    end
end



                   
                   
