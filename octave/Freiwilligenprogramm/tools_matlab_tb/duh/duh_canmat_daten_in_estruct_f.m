function s_duh = duh_canmat_daten_in_estruct_f(s_duh)
%
% Daten einlesen
%
%
  c_dir      = {};
  ssig_func  = '';

  s_frage    = 0;
  s_liste = o_abfragen_werte_liste_erstellen_f ...
               (1         ,'measure_dir'      ,c_dir    ,'Verzeichnisse mit can-mat-Daten zum wandeln auswählen' ...
               ,0         ,'Ssig_func'        ,ssig_func,'m-File (my_Ssig.m), das die Signalbeschreibung beinhaltet' ...
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
          end                
        case 2
          s_frage.comment     = 'm-File (my_Ssig.m), das die Signalbeschreibung beinhaltet';
          s_frage.file_spec   = '*.m';
          s_frage.start_dir   = s_duh.start_dir;
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

  %       case 3 % eigene(s) m-File(s) nutzen
  %           s_frage.comment  = 'd-struct rausschreiben?';
  %           s_frage.default  = 1;
  %           s_frage.def_value  = ~s_liste(option).c_value{1};
  % 
  %           if( o_abfragen_jn_f(s_frage) )
  %               s_liste(option).c_value{1} = 1;
  %           else
  %               s_liste(option).c_value{1} = 0;
  %               s_liste(option+1).c_value  = {};
  %           end
  %           s_liste(option).tbd     = 0;
  %      case 4
  %           s_frage.frage   = 'Welche Schrittweite soll verwendet werden';
  %           s_frage.command = 'delta_t';
  %           s_frage.type    = 'double';
  %           s_frage.min     = 0.00000000001;
  %           s_frage.default = 0.01;
  % 
  %           [okay,value] = o_abfragen_wert_f(s_frage);
  % 
  %           if( okay ) % 
  %               s_liste(option).tbd        = 0;
  %               s_liste(option).c_value{1} = value;
  %           else
  %               s_liste(option).tbd     = 1;
  %               s_liste(option).c_value = {};
  %               %return;
  %           end
  %      case 5 %timeour
  %           s_frage.frage   = 'Welche timeout-Zeit soll verwendet werden';
  %           s_frage.command = 'timeout';
  %           s_frage.type    = 'double';
  %           s_frage.min     = 0.00000000001;
  %           s_frage.default = 0.1;
  % 
  %           [okay,value] = o_abfragen_wert_f(s_frage);
  % 
  %           if( okay ) % 
  %               s_liste(option).tbd        = 0;
  %               s_liste(option).c_value{1} = value;
  %           else
  %               s_liste(option).tbd     = 1;
  %               s_liste(option).c_value = {};
  %               %return;
  %           end

          end
    end
  end

  % Auswerten
  start_time = cputime;

  n_data = duh_canmat_daten_in_estrut_do_f(s_liste(1).c_value ...
                                          ,s_liste(2).c_value ...
                                          );
  end_time = cputime;
  a=sprintf('\nstart: %g end: %g delta: %g\ndata_sets: %g time/data_set: %g\n', ...
            start_time,end_time,end_time-start_time,n_data,(end_time-start_time)/max(n_data,1));
  o_ausgabe_f(a,s_duh.s_prot.debug_fid);
end                 
function   n_data = duh_canmat_daten_in_estrut_do_f(c_dirs ...
                                                   ,c_my_Ssig_files ...
                                                   )

  n_data = 0;                              

  % Unterpfade abfragen
  c_sub = s_subpathes_f(c_dirs);

  % matlab-Files suchen
  s_files = suche_files_ext(c_sub,'mat');


  % Files einlesen, bearbeiten und ausgeben
  for i=1:length(s_files)

      % Datalayserdaten einlesen
      n_data = n_data+1;
      [e,okay,errtext] = e_data_mat_canalyser_read(s_files(i).fullname,c_my_Ssig_files);
      if( ~okay )
          return
      end
      % e-Struktur speichern
      %---------------------
      filename = fullfile(s_files(i).dir,[s_files(i).name,'_e.mat']);
      eval(['save ''',filename,''' e']);
      fprintf('e-struct-Datei: <%s>\n',filename);

  end
end


                   
                   
