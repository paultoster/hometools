function s_duh = duh_das2_daten_wandeln_f(s_duh)
%
% Daten einlesen
%
%
c_dir      = {};
c_prc      = s_duh.s_einstell.c_datalyser_prc_file;
prc_tbd    = length(c_prc) == 0;
value      = s_duh.s_einstell.peak_filt_std_fac;
c_analyse_func  = s_duh.s_einstell.c_analyse_func_file;
c_res_file = s_duh.s_einstell.res_file;

if( exist(char(c_analyse_func),'file') ==  0 )
    c_analyse_func = {};
end
anf_tbd    = length(c_analyse_func) == 0;

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1         ,'measure_dir'      ,c_dir    ,'Verzeichnisse mit datalyser-Daten zum wandeln auswählen' ...
             ,prc_tbd   ,'prc_file'         ,c_prc    ,'Protokolldatei(en) für Datalyser-Auswertung (aus Einstellung)' ...
             ,anf_tbd   ,'analyse_func'          ,c_analyse_func,'analyse-File (my_name.m) für eigene Auswertung bestimmen (Interface zwingend [comment]=my_func(d,u,h,file)' ...
             ,0         ,'res_file'         ,c_res_file,'Ergebnisfile' ...
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
                s_frage.comment   = 'Datalyser standard prc-Files auswählen';
                s_frage.command   = 'datalyser_prc_files';
                s_frage.file_spec ='*.prc';
                s_frage.start_dir = s_duh.start_dir;
                s_frage.file_number    = 0;

                [okay,c_filenames] = o_abfragen_files_f(s_frage);

                if( okay )
                    for i=1:length(c_filenames)
                        s_duh.s_einstell.c_datalyser_prc_file{i} = c_filenames{i};
                    end
                end
                if( okay ) % 
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = c_filenames;
                    %               else
                    %return;
                end
            case 3
                s_frage.comment   = 'm-File (my_func.m) für eigene Auswertung bestimmen (Interface zwingend [comment]=my_func(d,u,h,file)';
                s_frage.file_spec ='*.m';
                s_frage.start_dir = s_duh.start_dir;
                s_frage.file_number    = 0;

                [okay,c_filenames] = o_abfragen_files_f(s_frage);

                if( okay )
                    s_duh.s_einstell.c_analyse_func_file = c_filenames;
                end
                if( okay ) % 
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = c_filenames;
                end

            case 4
                s_frage.comment   = 'Name Ergebnisdatei';
                s_frage.file_spec ='*.*';
                s_frage.start_dir = s_duh.start_dir;
                s_frage.file_number    = 1;
                s_frage.put_file       = 1;
                
                [okay,c_filenames] = o_abfragen_files_f(s_frage);

                if( okay )
                    s_duh.s_einstell.res_file = c_filenames{1};
                end
                if( okay ) % 
                    s_liste(option).tbd     = 0;
                    s_liste(option).c_value = c_filenames;
                end
                
        end
	end
end

% Auswerten
start_time = cputime;

n_data = duh_das2_daten_analyse_do_f(s_liste(1).c_value,s_liste(2).c_value,s_liste(3).c_value,s_liste(4).c_value{1});
end_time = cputime;
a=sprintf('\nstart: %g end: %g delta: %g\ndata_sets: %g time/data_set: %g \nErgebnisdatei:%s\n', ...
          start_time,end_time,end_time-start_time,n_data,(end_time-start_time)/max(n_data,1),s_liste(4).c_value{1});
o_ausgabe_f(a,s_duh.s_prot.debug_fid);
                   
function   n_data = duh_das2_daten_analyse_do_f(c_dir, c_prc_files,c_analyse_func_file,res_file)

n_data = 0;                              

% Unterpfade abfragen
c_sub = s_subpathes_f(c_dir);

% DAtalyserfiles suchen
s_files = suche_files_ext_f(c_sub,'dl2');

% Files einlesen, bearbeiten und ausgeben
file_comment = {};
for i=1:length(s_files)
        
    % Datalayserdaten einlesen
    n_data = n_data+1;
    [okay,s_data] = duh_das2_daten_einlesen_f(s_files(i).fullname,c_prc_files);
    
    
    if( ~okay )
        return
    else
                
        % eigene Funktion ausführen
        n = length( c_analyse_func_file );
        if(  n > 0 )
            
            for j=1:n

                if( length(c_analyse_func_file{j}) > 0 )
                    s_file = str_get_pfe_f( c_analyse_func_file{j} );
                    
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
                    
                    command = ['comment = ',s_file.name,'(s_data.d,s_data.u,s_data.h,s_files(i).fullname);'];
                    o_ausgabe_f(command,0);
                    o_ausgabe_f('\n',0);
                    eval(command);
	
                    command = ['cd ',act_dir];
                    eval(command);
                    o_ausgabe_f('\n--------------------------------------------------------------------------',0);
                    
                    if( ischar(comment) )
                        comment = {comment};
                    end
                    for k=1:length(comment)
                        file_comment{length(file_comment)+1} = comment{k};
                    end
                    
                end
            end
        end
        
               
    end
end
% Ausgabe von file_comment in result_file
n = length(file_comment);
if( n > 0 )
   
    % Open
    [fid,message] = fopen(res_file,'w');
    if( fid == -1 )
        error(message)
    end
    
    for i = 1:n
        
        if( ischar(file_comment{i}) )
            fprintf(fid,'%s\n',file_comment{i});
        end
    end
    fclose(fid);
    
    eval(['edit ',res_file])
        
end


                   
                   
