function s_duh = duh_all_daten_wandeln_f(s_duh)
%
% Daten einlesen und wandeln
%
%
  measure_dir_count   = 0;
  input_format_count  = 0;
  output_format_count = 0;

  inp_format_name = {'mat','das','dl2','dia','csv','can_ascii','estruct'};
  inp_format_ext  = {'mat','dat','dl2','dat','csv','asc','mat'};
  out_format_name = {'dspa','duh','vec','csv','dia_asc','dia'};

  c_dir      = {};
  c_prc      = s_duh.s_einstell.c_datalyser_prc_file;
  prc_tbd    = isempty(c_prc);
  value      = s_duh.s_einstell.peak_filt_std_fac;
  c_my_func  = s_duh.s_einstell.c_my_func_file;

  if( exist(char(c_my_func),'file') ==  0 )
      c_my_func = 'none';
  end
  s_frage    = 0;
  s_liste = o_abfragen_werte_liste_erstellen_f ...
               (1      ,'measure_dir'      ,c_dir    ,'Verzeichnisse mit datalyser-Daten zum wandeln auswählen' ...
               ,0      ,'sub_dirs_on'      ,0        ,'Unterverzeichnisse auch wandeln' ...
               ,1      ,'input_format'     ,'mat'    ,'Eingabeformat (das/dl2/dia/mat/csv/can/estruct)' ...
               ,0      ,'prc_file_on'      ,0        ,'Prc-File nutzen (nur für das/dl2-Format zu nutzen)' ...
               ,0      ,'prc_file'         ,'none'   ,'Protokolldatei(en) für Datalyser-Auswertung' ...
               ,0      ,'dbc_file_on'      ,0        ,'Dbc-File nutzen (nur für can-Format zu nutzen)' ...
               ,0      ,'dbc_file'         ,'none'   ,'DBC-Datei(en) für CAN-Auswertung' ...
               ,0      ,'chanvec'          ,0        ,'Kanalnummer für CAN-Auswertung beginnend mit 0' ...
               ,0      ,'delta_t'          ,0.01     ,'Zeitschrittweite für CAN oder estruct' ...
               ,0      ,'timeout'          ,0.1      ,'timeout Zeitlänge für mergen auf eine Zeitbasis' ...
               ,0      ,'peak_filt_on'     ,0        ,'Peakfilter ein(1) oder aus(0)' ...
               ,0      ,'peak_filt_fact'   ,0        ,'Peakfilterfaktor einstellen' ...
               ,0      ,'my_func_on'       ,0        ,'eigene(s) m-File(s) nutzen' ...
               ,0      ,'my_func'          ,c_my_func,'m-File (my_name.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,h]=my_func(d,u,h)' ...
               ,1      ,'output_format'    ,'duh'    ,'Ausgabeformat (dspa (für wave), duh, dia)' ...
               ,0      ,'insert_front'     ,''       ,'Zusatzname vor Messdateiname (zB mess01.dat > wave_mess01.dat)' ...
               ,0      ,'insert_end'       ,'_neu'   ,'Zusatzname vor Messdateiname (zB mess01.dat > wave_mess01.dat)' ...
               ,0      ,'pos_sig_filt_on'  ,0        ,'pos. Signalfilter aus Einstellung verwenden' ...
               ,0      ,'neg_sig_filt_on'  ,0        ,'neg. Signalfilter aus Einstellung verwenden' ...
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

              case 1  % measure_dir          
          s_frage.comment   = 'Verzeichnisse auswählen';         % Kommentar
          s_frage.command   = '';                                % Kommando fürs Protokoll
          s_frage.start_dir = s_duh.s_einstell.measure_dir;    % Start-Verzeichnis zum suchen
          s_frage.multi_dir = 1;                                  % 0 ein Verzeichnis auchen 1: beliebige
                                                                         % Unterverzeichnisse finden
          [okay,c_dir] = o_abfragen_dir_f(s_frage); % ohne Protokoll und remote

                  if( okay ) % tbd muß zurückgesetzt werden
                      s_liste(option).tbd     = 0;
                      s_liste(option).c_value = c_dir;
                      measure_dir_count       = 0;
                  else
                      measure_dir_count = measure_dir_count+1;
                      if( measure_dir_count > 2 )
                          return;
                      end
                  end
              case 2 % sub_dirs_on

                  if( s_liste(option).c_value{1} )
                      s_liste(option).c_value{1} = 0;
                  else
                      s_liste(option).c_value{1} = 1;
                  end
                  s_liste(option).tbd     = 0;
              case 3 % input_format

                  s_frage.c_liste = {['(',inp_format_name{1},') Matlab-Format (dspace,duh,canalyser,Struktur)'] ...
                                    ,['(',inp_format_name{2},') Datalyser-das-Format (alt)'] ...
                                    ,['(',inp_format_name{3},') Datalyser-dl2-Format (neu)'] ...
                                    ,['(',inp_format_name{4},') Dia-Format'] ...
                                    ,['(',inp_format_name{5},') Csv-Format'] ...
                                    ,['(',inp_format_name{6},') Can_ascii-Format'] ...
                                    ,['(',inp_format_name{7},') Matlab-Format estruct'] ...
                                    };
                  s_frage.c_name = inp_format_name;
                  s_frage.frage  = 'Welches Input-Datenformat verwenden';
                  s_frage.single = 1;

                  [okay,selection] = o_abfragen_listbox_f(s_frage);

                  if( okay )
                      s_liste(option).tbd        = 0;
                      s_liste(option).c_value{1} = inp_format_name{selection(1)};
                      input_format_count         = 0;
                  else
                      input_format_count = input_format_count+1;
                      if( input_format_count > 2 )
                          return;
                      end
                  end                    

              case 4 % prc_file_on
                  if( s_liste(option).c_value{1} )
                      s_liste(option).c_value{1} = 0;
                      s_liste(option+1).c_value{1} = 'none';
                  else
                      s_liste(option).c_value{1} = 1;
                  end
                  s_liste(option).tbd     = 0;

              case 5 % prc_file
                  s_frage.comment   = 'Datalyser prc-Files auswählen';
                  s_frage.command   = 'datalyser_prc_files';
                  s_frage.file_spec = '*.prc';
                  s_frage.start_dir = s_duh.s_einstell.measure_dir;
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
              case 6 % dbc_file_on
                  if( s_liste(option).c_value{1} )
                      s_liste(option).c_value{1} = 0;
                      s_liste(option+1).c_value{1} = 'none';
                  else
                      s_liste(option).c_value{1} = 1;
                  end
                  s_liste(option).tbd     = 0;

              case 7 % dbc_file
                  s_frage.comment   = 'DBC-Files auswählen';
                  s_frage.command   = 'can_dbc_files';
                  s_frage.file_spec ='*.dbc';
                  s_frage.start_dir = s_duh.s_einstell.measure_dir;
                  s_frage.file_number    = 0;

                  [okay,c_filenames] = o_abfragen_files_f(s_frage);

                  if( okay ) % 
                      s_liste(option).tbd     = 0;
                      s_liste(option).c_value = c_filenames;
                      %               else
                      %return;
                  end

              case 8 % channel

                  % dbc-Files sind bestimmt worden
                  if( s_liste(6).c_value == 1 && iscell(s_liste(7).c_value)  )
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
              case 9 % delta_t

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
              case 10 % timeout

                  s_frage.frage   = 'Welche timeout-Zeit soll verwendet werden';
                  s_frage.command = 'timeout';
                  s_frage.type    = 'double';
                  s_frage.min     = 0.00000000001;
                  s_frage.default = 0.1;

                  [okay,value] = o_abfragen_wert_f(s_frage);

                  if( okay ) % 
                      s_liste(option).tbd        = 0;
                      s_liste(option).c_value{1} = value;
                  else
                      s_liste(option).tbd     = 1;
                      s_liste(option).c_value = {};
                      %return;
                  end
              case 11 % peak_filt_on


                  if( s_liste(option).c_value{1} )
                      s_liste(option).c_value{1} = 0;
                  else
                      s_liste(option).c_value{1} = 1;
                  end
                  s_liste(option).tbd     = 0;


              case 12 % peakfilter faktor

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

              case 13 % eigene(s) m-File(s) nutzen

                  s_frage.comment  = 'eigene(s) m-File(s) nutzen?';
                  s_frage.default  = 1;
                  s_frage.def_value  = ~s_liste(option).c_value{1};

                  if( s_liste(option).c_value{1} < 0.5 )
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


              case 14 % myfunc
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
                      s_liste(option).c_value{1} = c_filenames;
                      %else
                      %return;
                  end

              case 15% output_format

                  s_frage.c_liste = {['(',out_format_name{1},') Matlab im dspace-Format'] ...
                                    ,['(',out_format_name{2},') Matlab im duh-Format'] ...
                                    ,['(',out_format_name{3},') Matlab mit Vektoren'] ...
                                    ,['(',out_format_name{4},') Csv-Format'] ...
                                    ,['(',out_format_name{5},') Diadem-Ascii-Format'] ...
                                    ,['(',out_format_name{6},') Diadem-r32-Format'] ...
                                    };

                  s_frage.c_name = out_format_name;
                  s_frage.frage  = 'Welches Output-Datenformat verwenden';
                  s_frage.single = 1;

                  [okay,selection] = o_abfragen_listbox_f(s_frage);

                  if( okay )
                      s_liste(option).tbd        = 0;
                      s_liste(option).c_value{1} = out_format_name{selection(1)};
                      output_format_count         = 0;
                  else
                      output_format_count = output_format_count+1;
                      if( output_format_count > 2 )
                          return;
                      end
                  end

              case 16 % insert_file_name
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
              case 17 % insert_file_name_en
                  s_frage.c_comment = {}; %     enthält Kommentar ohne Zeilenumbruch (Auswahlliste, etc.)
                  s_frage.frage     = 'Welchen Zusatznamen am ende des Namens der Messdateien einfügen'; %    Frage nach dem Wert
                  s_frage.type      = 'char'; % Type angeben (default)
                  [okay,value]      = o_abfragen_wert_f(s_frage);

                  if( okay )
                      s_liste(option).tbd        = 0;
                      s_liste(option).c_value{1} = value;
                      %else
                      %return;
                  end

              case 18 % pos_sig_filt_on

                  if( s_liste(option).c_value{1} )
                      s_liste(option).c_value{1} = 0;
                  else
                      if( isempty(s_duh.s_einstell.c_pos_signal_list) )
                          fprintf('Erst Liste mit Signalen in Einstellungen erstellen');
                      else
                          s_liste(option).c_value{1} = 1;
                      end
                  end
                  s_liste(option).tbd     = 0;
              case 19 % neg_sig_filt_on

                  if( s_liste(option).c_value{1} )
                      s_liste(option).c_value{1} = 0;
                  else
                      if( isempty(s_duh.s_einstell.c_neg_signal_list) )
                          fprintf('Erst Liste mit Signalen in Einstellungen erstellen');
                      else
                          s_liste(option).c_value{1} = 1;
                      end
                  end
                  s_liste(option).tbd     = 0;

          end
    end
  end

  inp_format = cell_find_f(inp_format_name,s_liste(3).c_value{1},'v');
  out_format = cell_find_f(out_format_name,s_liste(15).c_value{1},'v');

  % postive Filter-Liste
  if( s_liste(18).c_value{1} )
      c_pos_sig_list = s_duh.s_einstell.c_pos_signal_list;
  else
      c_pos_sig_list = {};
  end
  % negative Filter-Liste
  if( s_liste(19).c_value{1} )
      c_neg_sig_list = s_duh.s_einstell.c_neg_signal_list;
  else
      c_neg_sig_list = {};
  end

  % Auswerten
  start_time = cputime;

  n_data = duh_das_daten_wandeln_do_f(s_liste(1).c_value, s_liste(2).c_value{1}, inp_format ...
                                     ,s_liste(4).c_value{1}, s_liste(5).c_value ...
                                     ,s_liste(6).c_value{1}, s_liste(7).c_value, s_liste(8).c_value{1}, s_liste(9).c_value{1}, s_liste(10).c_value{1} ...
                                     ,s_liste(11).c_value{1}, s_liste(12).c_value{1} ...
                                     ,s_liste(13).c_value{1}, s_liste(14).c_value{1} ...
                                     ,out_format, s_liste(16).c_value{1}, s_liste(17).c_value{1} ...
                                     ,inp_format_ext, out_format_name ...
                                     ,c_pos_sig_list, c_neg_sig_list ...
                                     );
  end_time = cputime;
  a=sprintf('\nstart: %g end: %g delta: %g\ndata_sets: %g time/data_set: %g\n', ...
            start_time,end_time,end_time-start_time,n_data,(end_time-start_time)/max(n_data,1));
  o_ausgabe_f(a,s_duh.s_prot.debug_fid);
end         
function   n_data = duh_das_daten_wandeln_do_f(measure_dir,   sub_dirs_on, input_format ...
                                              ,prc_file_on,   prc_files ...
                                              ,dbc_file_on,   dbc_files, chanvec , delta_t, timeout ...
                                              ,peak_filt_on,  peak_filt_fact ...
                                              ,my_func_on,    my_func_file_list_1234567890 ...
                                              ,output_format, insert_name, insert_name_end ...
                                              ,inp_format_ext ...
                                              ,out_format_name ...
                                              ,c_pos_sig_list ...
                                              ,c_neg_sig_list ...
                                              )

  % measure_dir
  if( ~iscell(measure_dir) )
      measure_dir = {measure_dir};
  end
  % In cell wandeln                                          
  if( ~iscell(prc_files) )

      if( strcmp(prc_files,'none') )
          prc_files = {};
      else
          prc_files = {prc_files};
      end
  end

  if( ~iscell(dbc_files) )

      if( strcmp(dbc_files,'none') )
          dbc_files = {};
      else
          dbc_files = {dbc_files};
      end
  end

  % In cell wandeln
  if( ~iscell(my_func_file_list_1234567890) )

      if( strcmp(my_func_file_list_1234567890,'none') )
          my_func_file_list_1234567890 = {};
      else
          my_func_file_list_1234567890 = {my_func_file_list_1234567890};
      end
  end

  n_data = 0;                              

  % Unterverzeichnisse sammeln
  if( sub_dirs_on )
      c_sub = s_subpathes_f(measure_dir);
  else
      c_sub = measure_dir;
  end

  % Input-Fileliste erstellen
  s_files = suche_files_ext(c_sub,inp_format_ext(input_format));

  % Files einlesen, bearbeiten und ausgeben
  for i=1:length(s_files)
        
      % Datalayserdaten einlesen
      n_data = n_data+1;
      if( input_format == 7 )
        [okay,e,f] = e_data_read_mat(s_files(i).fullname);
        if( okay )
          zero_time = 1;
          [d,u,c] = d_data_read_e(e,delta_t,zero_time,-1,-1,timeout);

          s_data.file        = str_change_f(f,'_e.mat','.mat');
          s_data.name        = str_change_f(s_files(i).name,'_e','');
          s_data.d           = d;
          s_data.u           = u;
          s_data.h           = {'estruct-read',c};
          n_s_data           = 1;
        end
      else
        [okay,s_data,n_s_data] = duh_all_daten_wandeln_einlesen_f(s_files(i).fullname ...
                                                        ,prc_file_on,   prc_files ...
                                                        ,dbc_file_on,   dbc_files, chanvec, delta_t ...
                                                        ,input_format ...
                                                        );
      end
      if( ~okay )
         n_data = n_data-1;
      else
    
        % positive Filterliste
        %=====================
        if( ~isempty(c_pos_sig_list) )

            d  = [];
            u  = [];
            for j=1:n_s_data

                for jj = 1:length(c_pos_sig_list)

                    if( struct_find_f(s_data(j).d,c_pos_sig_list{jj}) )

                        d.(c_pos_sig_list{jj}) = s_data(j).d.(c_pos_sig_list{jj});

                        if( struct_find_f(s_data(j).u,c_pos_sig_list{jj}) )

                            u.(c_pos_sig_list{jj}) = s_data(j).u.(c_pos_sig_list{jj});
                        end
                    end
                end
                s_data(j).d = d;
                s_data(j).u = duh_check_du_f(d,u);
            end


        end

        % negative Filterliste
        %=====================
        if( ~isempty(c_neg_sig_list) )

            for j=1:n_s_data

                s_data(j).d = rmfield(s_data(j).d, c_neg_sig_list);
                s_data(j).u = rmfield(s_data(j).u, c_neg_sig_list);

                s_data(j).u = duh_check_du_f(s_data(j).d,s_data(j).u);
            end                                        
        end

        for j=1:n_s_data

            % Peakfiltern
            if( peak_filt_on )

                o_ausgabe_f('\nPeakfilter an den Stellen-------------------------------------------------',0);
                [s_data(j).d,c_comment] = duh_peak_filter_f(s_data(j).d,peak_filt_fact,0);

                for k=1:length(c_comment)
                    a = sprintf('\n%s',c_comment{k});
                    o_ausgabe_f(a,0);
                end
                o_ausgabe_f('\n--------------------------------------------------------------------------',0);
            end

            if( my_func_on )

                % eigene Funktion ausführen
                n = length( my_func_file_list_1234567890 );            
                for k=1:n

                    if( ~isempty(my_func_file_list_1234567890{k}) )
                        s_file = str_get_pfe_f( my_func_file_list_1234567890{k} );

                        o_ausgabe_f('\n--------------------------------------------------------------------------\n',0);
                        if( ~isempty(s_file.dir) )
                            act_dir = pwd;
                            command = ['cd ',s_file.dir];
                            o_ausgabe_f(command,0);
                            o_ausgabe_f('\n',0);
                            eval(command);
                        else
                            act_dir = '.';
                        end

                        command = ['[s_data(j).d,s_data(j).u,s_data(j).h] = ',s_file.name,'(s_data(j).d,s_data(j).u,s_data(j).h);'];
                        o_ausgabe_f(command,0);
                        o_ausgabe_f('\n',0);
                        eval(command);

                        command = ['cd ',act_dir];
                        eval(command);
                        o_ausgabe_f('\n--------------------------------------------------------------------------',0);
                        s_data(j).u = duh_check_du_f(s_data(j).d,s_data(j).u);
                    end
                end
            end

            % Namen für abspeichern festlegen
            filename = [s_files(i).dir,'\',insert_name,s_data(j).name,insert_name_end];


            % Daten speichern
            [okay,f] = duh_daten_speichern_format(s_data(j),filename,out_format_name(output_format));

            if( length(s_files(i).fullname) > 30)
                fprintf('%s\n-> %s\n',s_files(i).fullname,f)
            else
                fprintf('%s -> %s\n',s_files(i).fullname,f)
            end
        end

      end
  end
end
   
function [okay,s_data,n_data] = duh_all_daten_wandeln_einlesen_f(filename ...
                                                                ,prc_file_on,   prc_files ...
                                                                ,dbc_file_on,   dbc_files, chanvec, delta_t ...
                                                                ,inp_format ...
                                                                )                                                     
  switch(inp_format)

      case 1 % mat-Format

          [okay,s_data,n_data] = duh_mat_daten_einlesen_f(filename);
      case 2 % das-Format
          [okay,s_data] = duh_das_daten_einlesen_f(filename,prc_files);
          n_data = 1;
      case 3 % dl2-Format
          [okay,s_data] = duh_das2_daten_einlesen_f(filename,prc_files);
          n_data = 1;
      case 4 % dia-Format
          [okay,s_data] = duh_dia_daten_einlesen_f(filename);
          n_data = 1;
      case 5 % csv-Format
          [okay,s_data] = duh_csv_daten_einlesen_f(filename);
          n_data = 1;
      case 6 % can_ascii-Format
          [okay,s_data] = duh_can_ascii_daten_einlesen_f(filename,dbc_files,delta_t,chanvec);
          n_data = 1;
  end

  if( isempty(s_data.d) )
    okay = 0;
  else
    [s_data.d,s_data.u] = struct_elim_null_vecs(s_data.d,s_data.u);
  end
   
end