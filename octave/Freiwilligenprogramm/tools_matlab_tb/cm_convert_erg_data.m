function [okay,d,u,h,erg_dir] = cm_convert_erg_data(q,e)
%
% [okay,d,u,h,fullfilename] = cm_convert_erg_data(q,e)
%
% Liest erg-Daten (*.erg) aus CarMaker aus
%
% q.start_dir     Start-Dir zum Suchen 
%
% Daten einlesen
%
% q.SigListe_mFile    m-File mit Aufruf um Signalliste zu bekommen:
%                     Mit dieser Signalliste werden die Signale aus
%                     erg-File ausgesucht und mit Namen gewandelt
%
% q.AddSigListe_mFile m-File mit Aufruf um Signalliste zu bekommen:
%                     Mit dieser Add-Signalliste werden zusätzliche
%                     Signale aus den bereits eingelsenen Signalen
%                     generiert
%   Ssig(i).name_in        Name in der CAN-Messung dbc-File
%   Ssig(i).unit_in        Einheit Eingang
%                     (VW-Konvention)
%   Ssig(i).lin_in         Linearisierungsflag
%   Ssig(i).name_out       Ausgabename
%   Ssig(i).unit_out       Einheit Ausgabe
%   Ssig(i).comment        Kommentar
% q.index_start = 1   Index Start
% q.index_end = -1    Index Start
% q.tstart = -1.;     startzeit (default -1.)
% q.tend = -1.;       endzeit (default -1.)
% q.zero_time = 1;    Zeit nullen 
%
% q.delta_t = 0.01;   Zeitschritt

  okay = 1;
  d = struct([]);
  u = struct([]);
  h = {};
  erg_dir = '';
  if( ~exist('e','var') )
    e = struct([]);
  end

  if( ~check_val_in_struct(q,'start_dir','char',1) )
    q.start_dir = 'C:\';
  end
  

  % Dateinamen auswählen
  %=====================
  s_frage.comment     = 'Carmaker-erg-Dateien auswählen';
  s_frage.start_dir   = q.start_dir;
  s_frage.file_spec   = '*.erg';
  s_frage.file_number = 1;
    
  [file_okay,c_filenames] = o_abfragen_files_f(s_frage);

  if( ~file_okay )
    okay = 0;
    return;
  else
    s = str_get_pfe_f(c_filenames{1});
  end
  
  % Ssig zum einlsen erzeugen
  %==========================
  if( check_val_in_struct(q,'SigListe_mFile','char',1) )
    s_file = str_get_pfe_f(q.SigListe_mFile);
    if( ~isempty(s_file.dir) )
      org_dir = pwd;
      cd(s_file.dir);
    else
      org_dir = '';
    end
    if( ~exist([s_file.name,'.m'],'file') )
      error('M-File: %s konnte nicht gefunden werden',q.SigListe_mFile);
    end
    try
      q.Ssig = eval(s_file.name);
      if( ~isempty(org_dir) ),cd(org_dir),end;
      q.Ssig = proofSsig(q.Ssig);
    catch exception
      if( ~isempty(org_dir) ),cd(org_dir),end;
      throw(exception)
    end
    
  end
   
  % erg-File einlesen
  %==================
  [d,u,c,h] = read_cm_erg_and_filter(s.fullfile,q);
  
  % AddSsig erzeugen
  %=================
  if( check_val_in_struct(q,'AddSigListe_mFile','char',1) )
    s_file = str_get_pfe_f(q.AddSigListe_mFile);
    if( ~isempty(s_file.dir) )
      org_dir = pwd;
      cd(s_file.dir);
    else
      org_dir = '';
    end
    if( ~exist([s_file.name,'.m'],'file') )
      error('M-File: %s konnte nicht gefunden werden',q.AddSigListe_mFile);
    end
    try
      q.AddSsig = eval(s_file.name);
      if( ~isempty(org_dir) ),cd(org_dir),end;
      q.AddSsig = proofSsig(q.AddSsig);
    catch exception
      if( ~isempty(org_dir) ),cd(org_dir),end;
      throw(exception)
    end
    
    [d,u,c] = d_data_change_w_Ssig(q.AddSsig,'addfront',d,u,c);
  end
  
  e_load = 0;
  if( isempty(e) )
    filename = fullfile(s.dir,[s.name,'_e.mat']);
    if( exist(filename,'file') )
      eval(['load ''',filename,'''']);
      fprintf('load e-struct-Datei: <%s>\n',filename);
      e_load = 1;
    end
  end    
  
  % e-struktur einfügen
  [d,u,c] = d_data_merge_e(d,u,c,e);
  
  % Kommentarstruktur in h-cellarray unterbringen  
  h{2} = c;
  
  
  erg_dir = s.dir;    
    
  filename    = fullfile(s.dir,[s.name,'.mat']);
  okay        = d_data_save(filename,d,u,h,'duh');
  fprintf('Mat-Ausgabe-Datei duh-Format: <%s>\n========================================================================================================\n',filename);

  if( ~isempty(e) && ~e_load )
    filename = fullfile(s.dir,[s.name,'_e.mat']);
    eval(['save ''',filename,''' e']);
    fprintf('e-struct-Datei: <%s>\n',filename);
  end    
   
 
end