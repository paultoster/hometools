% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function s_duh = duh_csv_daten_wandeln_f(s_duh)
%
% Daten einlesen
%
%
c_dir      = {};
value      = s_duh.s_einstell.peak_filt_std_fac;
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
             (1      ,'measure_dir'      ,c_dir    ,'Verzeichnisse mit Daten zum wandeln auswählen' ...
             ,1      ,'input_format'     ,'mat'    ,'Input-Format mat csv' ...
             ,0      ,'peak_filt_on'     ,1        ,'Peakfilter ein(1) oder aus(0)' ...
             ,0      ,'peak_filt_fact'   ,value    ,'Peakfilterfaktor einstellen' ...
             ,0      ,'my_func_on'       ,my_f_on  ,'eigene(s) m-File(s) nutzen' ...
             ,0      ,'my_func'          ,c_my_func,'m-File (my_name.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,h]=my_func(d,u,h)' ...
             ,0      ,'output_format'    ,'dspa'   ,'Ausgabeformat (dspa (für wave), duh, dia)' ...
             ,0      ,'insert_file_name' ,'dspa_'  ,'Zusatzname vor Messdateiname (zB mess01.dat > wave_mess01.dat)' ...
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
                s_frage.c_liste{1} = 'mat';       % enthält text für die Auswahlliste
                s_frage.c_liste{2} = 'csv';       % enthält text für die Auswahlliste
                % s_frage.c_liste{3} = 'dia';       % enthält text für die Auswahlliste
                s_frage.frage      = 'In welchem Format sollen die Daten eingelesen werden?';
                s_frage.single     = 1;
               
                [okay,selection] = o_abfragen_listbox_f(s_frage);
                if( okay )
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = s_frage.c_liste{selection};
                    %else
                    %return;
                end
                
            case 3
                s_frage.comment  = 'Peakfilter verwenden?';
                s_frage.default  = 1;
                s_frage.def_value  = ~s_liste(option).c_value{1};

                if( o_abfragen_jn_f(s_frage) )
                    s_liste(option).c_value{1} = 1;
                else
                    s_liste(option).c_value{1} = 0;
                end
                s_liste(option).tbd     = 0;
            case 4 % peakfilter faktor
				s_frage.c_comment{1} = 'Peakfilter: aus diff(data) wird die Standardabweichung (std) bestimmt';
				s_frage.c_comment{2} = '            Peak wird erkannt, wenn die differenz > faktor*std ist';
                s_frage.c_comment{3} = sprintf(' alter Peakfilterfaktor: %g',s_duh.s_einstell.peak_filt_std_fac);
				s_frage.frage     = 'Faktor für Peakfilter';
				s_frage.prot      = 1;
				s_frage.command   = 'peak_filt_std_fac';
				s_frage.type      = 'double';
				s_frage.min       = 0;
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_duh.s_einstell.peak_filt_std_fac = value;
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
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
                    %else
                    %return;
                end

            case 7
                s_frage.c_liste{1} = 'dspa';       % enthält text für die Auswahlliste
                s_frage.c_liste{2} = 'duh';       % enthält text für die Auswahlliste
                % s_frage.c_liste{3} = 'dia';       % enthält text für die Auswahlliste
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

c_dir             = s_liste(1).c_value;
input_format      = s_liste(2).c_value{1};
peak_filt_flag    = s_liste(3).c_value{1};
peak_filt_std_fac = s_liste(4).c_value{1};
c_my_func_file    = s_liste(6).c_value;
output_format     = s_liste(7).c_value{1};
insert_name       = s_liste(7).c_value{1};

n_data = duh_csv_daten_wandeln_do_f(c_dir,input_format,peak_filt_flag, ...
                                peak_filt_std_fac,c_my_func_file, ...
                                output_format,insert_name);
end_time = cputime;
a=sprintf('\nstart: %g end: %g delta: %g\ndata_sets: %g time/data_set: %g\n', ...
          start_time,end_time,end_time-start_time,n_data,(end_time-start_time)/max(n_data,1));
o_ausgabe_f(a,s_duh.s_prot.debug_fid);
                   
function   n_data = duh_csv_daten_wandeln_do_f(c_dir, input_format,peak_filt_flag, ...
                                           peak_filt_std_fac, c_my_func_file, ...
                                           output_format,insert_name)

n_data = 0;                              
if( nargin < 6 )
    insert_name = '';
end
if( nargin < 5 )
    output_format = 'dspa';
end
if( nargin < 4 )
    c_my_calc_dir = {};
end
if( nargin < 3 )
    peak_filt_flag = 0;
end
if( nargin < 2 )
    error('duh_daten_wandeln_f:duh_daten_wandeln_do_f Zu wenige Argumante')
end

% Unterpfade abfragen
c_sub = s_subpathes_f(c_dir);

% Datenfiles suchen
if( strcmp(input_format,'mat') )
    s_files = suche_files_ext_f(c_sub,'mat');
else
    s_files = suche_files_ext_f(c_sub,'csv');
end
% Files einlesen, bearbeiten und ausgeben
for i=1:length(s_files)
        
    % CSVdaten einlesen
    n_data = n_data+1;
    if( strcmp(input_format,'mat') )
        [okay,s_data] = duh_mat_daten_einlesen_f(s_files(i).fullname);
    else
        [okay,s_data] = duh_csv_daten_einlesen_f(s_files(i).fullname);
    end
    
    if( ~okay )
        return
    else
        
        % Peakfiltern
        if( peak_filt_flag )
            
            o_ausgabe_f('\nPeakfilter an den Stellen-------------------------------------------------',0);
            [s_data.d,c_comment] = duh_peak_filter_f(s_data.d,peak_filt_std_fac,0);
            
            for k=1:length(c_comment)
                a = sprintf('\n%s',c_comment{k});
                o_ausgabe_f(a,0);
            end
            o_ausgabe_f('\n--------------------------------------------------------------------------',0);
        end
        
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



                   
                   
