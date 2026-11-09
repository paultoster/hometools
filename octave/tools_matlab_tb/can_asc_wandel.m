function okay = can_asc_wandel(q)
% q = [];
% q.mess_start_dir      = 'D:\mess';         Dort wird Messung gesucht
% q.asci_files          = {};                Liste mi ascii-Files angeben
%                                            oder leer lassen für Auswahl
% q.wand_if_no_mat      = 0;                 nur wandeln, wenn noch nicht
%                                            existiert
% q.delta_t             = 0.01;              Loopzeit Zeitvektor
% q.zero_time           = 1;                 Bei Schneiden, Daten
%                                            zeitlich nullen
% q.tstart              = -1.;               Schneiden bei tstart
% q.tend                = -1.;               Schneiden bis tend
% q.dbcfile{1}          = 'D:\Ronja\dbc\ContiGuard_VPU.DBC';  dbc-File
% q.dbcfile{2}          = 'D:\Ronja\dbc\PQ35_46_mit_6D0.dbc';
% q.channel             = [1,2];             Kanalbelegung
% q.save_e_struct       = 0;                 Orginal mit Zeitmessung
%                                            speichern
% q.save_type           = 'mat_duh';         mat_duh Matlab duh-Format
%                                            mat_dspa Matlab dspae-Format
%                                            dia     Dia-Format
%                                            dia_asc Dia-Ascii-Format
% Signalliste:
% isig = isig+1;
% q.Ssig(isig).name_in      = 'HOmgS_Z';  %    Name im DBC-File
% q.Ssig(isig).unit_in      = '°/s';      %    Einheit Input, wenn nicht im DBC-File
% q.Ssig(isig).name_sign_in = '';         %    CAN-Signal das das Vrzeichen bestimmt == 1 negativ (VW-Konvention)
% q.Ssig(isig).lin_in       = 1;          %    Linearisierungsflag
% q.Ssig(isig).name_out     = 'yawpIMAR'; %    Ausgabename
% q.Ssig(isig).unit_out     = 'rad/s';    %    Einheit Ausgabe
% q.Ssig(isig).comment      = 'Gierrate IMAR-Messplattform'; 


  if( ~isfield(q,'mess_start_dir') )
    q.mess_start_dir = 'd:';
  end
  if( ~isfield(q,'asci_files') )
    q.asci_files = {};
  end
  if( ~isfield(q,'wand_if_no_mat') )
    q.wand_if_no_mat = 0;
  end
  if( ~isfield(q,'delta_t') )
    q.delta_t = 0.01;
  end
  if( ~isfield(q,'zero_time') )
    q.zero_time = 0;
  end
  if( ~isfield(q,'tstart') )
    q.tstart = -1.;
  end
  if( ~isfield(q,'tend') )
    q.tend = -1.;
  end
  if( ~isfield(q,'dbcfile') )
    error('q.dbcfile{i}: DBC-File muß angegeben werden')
  end
  if( isempty(q.dbcfile) )
    error('q.dbcfile{i}: DBC-Fileliste leer')
  end
  for i=length(q.dbcfile)
    if( ~exist(q.dbcfile{i},'file') )
      error('q.dbcfile{%i}=%s existiert nicht',i,q.dbcfile{i});
    end
  end
  if( ~isfield(q,'channel') )
    q.channel = [1:1:length(q.dbcfile)];
  end
  if( ~isfield(q,'save_e_struct') )
    q.save_e_struct = 0;
  end
  if( ~isfield(q,'save_type') )
    q.save_type = 'mat_duh';
  end
  if( ~isfield(q,'Ssig') )
    error('Signalliste q.Ssig(i) anlegen');
  end



  % Messdateien:
  %-------------
  if( isempty(q.asci_files) )

    clear s_frage
    s_frage.start_dir = q.mess_start_dir;
    [path_okay,c_dirname] = o_abfragen_dir_f(s_frage);

    mess_files = suche_files_f(c_dirname,'asc',1);

    for i=1:length(mess_files)
      q.asci_files{length(q.asci_files)+1} = mess_files(i).full_name;
    end
  end

  wand_files = {};
  % Nur neue Files wandeln
  if( q.wand_if_no_mat )
    mat_files = suche_files_f(c_dirname,'mat',1);

    for i=1:length(q.asci_files)
      
      s_file = str_get_pfe_f(q.asci_files{i});

      flag = 0;
      for j=1:length(mat_files)
        
        

        if( strcmp(s_file.name,mat_files(j).body) )
          flag = 1;
          break;
        end
      end
      if( ~flag )
        wand_files{length(wand_files)+1} = q.asci_files{i};
      end
    end
    % alle Files wandeln
  else
    for i=1:length(q.asci_files)
      wand_files{length(wand_files)+1} = q.asci_files{i};
    end
  end

  for i=1:length(wand_files)
    [d,u,c] = can_asc_read_and_filter(wand_files{i},q);

    h = {[wand_files{i}]};
    s_file = str_get_pfe_f(wand_files{i});
    % File speichern
    %----------------------
    h{length(h)+1} = c;
    switch(q.save_type)
      case 'mat_dspa'
        mat_mess_file = fullfile(s_file.dir,[s_file.name,'.mat']);
        okay = d_data_save(mat_mess_file,d,u,h,'dspa');
        fprintf('Mat-Ausgabe-Datei dspa-Format: <%s>\n========================================================================================================\n' ...
                ,mat_mess_file);
      case 'mat_duh'
        mat_mess_file = fullfile(s_file.dir,[s_file.name,'.mat']);
        okay = d_data_save(mat_mess_file,d,u,h,'duh');
        fprintf('Mat-Ausgabe-Datei duh-Format: <%s>\n========================================================================================================\n' ...
                ,mat_mess_file);

      case 'dia'
        dia_file = fullfile(s_file.dir,[s_file.name,'.dat']);
        okay = d_data_save(dia_file,d,u,h,'dia');
        fprintf('Dia-Ausgabe-Datei diadem-Format: <%s>\n========================================================================================================\n' ...
                ,dia_file);
      case 'dia_asc'
        dia_file = fullfile(s_file.dir,[s_file.name,'_dia.dat']);
        okay = d_data_save(dia_file,d,u,h,'dia_asc');
        fprintf('Dia-Ausgabe-Datei diadem-Format: <%s>\n========================================================================================================\n' ...
                ,dia_file);

      otherwise
        fprintf('Kein gültiges Format zum speichern <%s>\n========================================================================================================\n' ...
                ,q.save_type);

    end       

  end
end
