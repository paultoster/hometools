function [okay,d,u,h] = cg_convert_cm_data(q)
%
% [okay,d,u,h] = cg_convert_cm_data(q)
%
% Wandelet erg-Files aus IPG-Simulation in Mat-File mit dennotwendigen
% Signalen, Eine Signalliste aus .\matlab\cm\CarMakerSigList.m wird benutzt
% (haupsächlich Kommentar) mit q.SsigExtra können zusätzliche Signale
% definiert werden
%
% q.read_type         = 1  ErgebnisDateien müssen ausgewählt werden
%                          q.start_dir angeben
%                     = 2  übergeordnetes Verzeichnis angeben
%                          q.read_simout_path angeben
% q.star_dir               Startverzeichnis
% q.read_simout_path       Ausgabepfad
% q.save_type              'mat_dspa'    Mat-Format-DSpace-Format
%   = 'mat_dspa';          'mat_duh'     Mat-Format d,u,h -Struktur
% q.add_to_save_file_name  = ''; an den Savenamen anhängen
% q.tstart = -1.;          startzeit (default -1.)
% q.tend = -1.;            endzeit (default -1.)
% q.zero_time = 1;         Zeit nullen 
% q.delta_t = 0.01;        Zeitschritt
% q.read_if_no_mat_exist   Keine Wandlung, wenn schon vorhanden
%
% q.SsigExtra              Extra CarMaker-Output-Signalliste
%                          q.Ssig(i).name_in   = 'ContiUser_LinQfIn_SALaLoIqf2_tqRampDistL';
%                          q.Ssig(i).name_out  = 'SALaLoIqf2_tqRampDistL';
%                          q.Ssig(i).unit_in   = 'm';  (will be used if not set)
%                          q.Ssig(i).unit_out  = 'm';
%                          q.Ssig(i).lin_in    = 0;    (interpolate linear or const)
%                          q.Ssig(i).comment   = 'Rampe Virtual Wall';
%
% q.mod_dDataCG      0/1 (default 1) 
%                    modify Data mit der fest vorgegebenen Funktion
%                    d = cg_mod_data(d)
  cg_base_variables;
  okay = 1;
  d    = [];
  u    = [];
  h    = {};
  if( ~exist('q','var') )
    q = struct([]);
  end
      
  % read type
  if( ~isfield(q,'read_type') )
    q.read_type = 1;
  end
  
  % start-DIr
  if( ~isfield(q,'start_dir') || isempty(q.start_dir) || ~exist(q.start_dir,'dir') )
    q.start_dir = 'D:\';
  end
  if( q.read_type == 2 ) % übergeordnetes Verzeichnis angeben q.read_simout_path angeben
  
    if( ~isfield(q,'read_simout_path') || isempty(q.read_simout_path) || ~exist(q.read_simout_path,'dir') )

      % Path auswählen
      %---------------
      s_frage.comment   = 'Pfad mit den Simulationsergebnisseb auswählen';
      s_frage.start_dir = q.start_dir;
      [path_okay,c_dirname] = o_abfragen_dir_f(s_frage);
      if( path_okay )
        q.read_simout_path = c_dirname{1};
      else
        okay = 0;
        return
      end
    end
  end  
                         
  
  % Save-Type
  %==========
  if( ~isfield(q,'save_type') )
    q.save_type = 'mat_duh';   % 'mat_dspa'    Mat-Format-DSpace-Format
                               % 'mat_duh'     Mat-Format d,u,h -Struktur 
  end
  
  if( ~isfield(q,'add_to_save_file_name') )
    q.add_to_save_file_name = '';
  end
  
  % Ausschnitt bearbeiten
  %----------------------
  if( ~isfield(q,'index_start') )
    q.index_start = 2;
  end
  if( ~isfield(q,'index_end') )
    q.index_end   = -1.;
  end
  if( ~isfield(q,'tstart') )
    q.tstart = -1.;
  end
  if( ~isfield(q,'tend') )
    q.tend   = -1.;
  end
  if( ~isfield(q,'zero_time') )
    q.zero_time   = 1;
  end
  %  Zeit bei null beginnen lassen
  
  if( ~isfield(q,'zero_time') )
    q.zero_time = 1;
  end
  
  % Zeitschritt
  %------------
  if( ~isfield(q,'delta_t') )
    q.delta_t = 0.01;
  end
  
  % Nur wandeln, wenn kein matfile vorhanden
  %-----------------------------------------
  if( ~isfield(q,'read_if_no_mat_exist') )
    q.read_if_no_mat_exist = 0;
  end
  
  % Signalliste
  %------------
  try
    eval(['q.Ssig = ',SCG.CM_MFILE_SIGLISTE,';'])
  catch exception
    throw(exception)
  end
  
  if( isfield(q,'SsigExtra') && ~isempty(q.SsigExtra) )
    n = length(q.Ssig);
    for i=1:length(q.SsigExtra)
      
      n = n+1;
%                          q.Ssig(i).name_in   = 'ContiUser_LinQfIn_SALaLoIqf2_tqRampDistL';
%                          q.Ssig(i).name_out  = 'SALaLoIqf2_tqRampDistL';
%                          q.Ssig(i).unit_in   = 'm';  (will be used if not set)
%                          q.Ssig(i).unit_out  = 'm';
%                          q.Ssig(i).lin_in    = 0;    (interpolate linear or const)
%                          q.Ssig(i).comment   = 'Rampe Virtual Wall';
      if( isfield(q.SsigExtra(i),'name_in') )
        q.Ssig(n).name_in = q.SsigExtra(i).name_in;
      else
        q.Ssig(n).name_in = '';
      end
      if( isfield(q.SsigExtra(i),'name_out') )
        q.Ssig(n).name_out = q.SsigExtra(i).name_out;
      else
        q.Ssig(n).name_out = '';
      end
      if( isfield(q.SsigExtra(i),'unit_in') )
        q.Ssig(n).unit_in = q.SsigExtra(i).unit_in;
      else
        q.Ssig(n).unit_in = '';
      end
      if( isfield(q.SsigExtra(i),'unit_out') )
        q.Ssig(n).unit_out = q.SsigExtra(i).unit_out;
      else
        q.Ssig(n).unit_out = '';
      end
      if( isfield(q.SsigExtra(i),'lin_in') )
        q.Ssig(n).lin_in = q.SsigExtra(i).lin_in;
      else
        q.Ssig(n).lin_in = 0;
      end
      if( isfield(q.SsigExtra(i),'comment') )
        q.Ssig(n).comment = q.SsigExtra(i).comment;
      else
        q.Ssig(n).comment = '';
      end
    end
  end
  
  % modify d-data
  %--------------
  if( ~isfield(q,'mod_dDataFkt') )
    q.mod_dDataFkt = '';
  end
  
  if( ischar(q.mod_dDataFkt) )    
    q.mod_dDataFkt = {q.mod_dDataFkt};
  elseif( ~iscell(q.mod_dDataFkt) )
    error('q.mod_dDataFkt muss char oder cellarray sein')
  end
  
  q.dFkt   = [];
  q.n_dFkt = 0;
  for i = 1:length(q.mod_dDataFkt)
    if( ~isempty(q.mod_dDataFkt{i}) ) 
      s = str_get_pfe_f(q.mod_dDataFkt{i});
      q.n_dFkt = q.n_dFkt + 1;
      q.dFkt(q.n_dFkt).name = s.name;
      q.dFkt(q.n_dFkt).dir  = s.dir;
    end
  end
  
  % Start
  %======
  if( q.read_type == 1 ) % ErgebnisDateien müssen ausgewählt werden q.start_dir angeben
    
    % Dateien auswählen
    %------------------
    s_frage.comment   = 'Simulationsergebnissdateien auswählen';
    s_frage.start_dir = q.start_dir;
    s_frage.file_spec = '*.erg';
    
    [files_okay,c_filenames] = o_abfragen_files_f(s_frage);
    if( files_okay )
      simout_files = suche_files_f(c_filenames,'erg',1,1);
    else
      okay = 0;
      return
    end
    
    
  elseif( q.read_type == 2 ) % übergeordnetes Verzeichnis angeben q.read_simout_path angeben
    
    simout_files = suche_files_f(q.read_simout_path,'erg',1);
    if( isempty(simout_files) )
      warning('Keine erg-Simdaten in Pfad: <%s> enthalten\',q.read_simout_path);
    end
  end
    
  i = 1;
  fail = 0;
  while(i <= length(simout_files) )
      
    mat_simout_file = cg_convert_cm_data_mat_filename(simout_files(i).full_name);
    % Wenn q.if_no_mat = 0, wird immer gewandelt
    % ist q.if_no_mat = 1 dann wird gewandelt, wenn mat_mess_file nicht
    % existiert
    %------------------------------------------------------------------
    if( ~q.read_if_no_mat_exist || ~exist(mat_simout_file,'file') )

      % Sim-Daten lesen
      [d,u,c,h] = cg_convert_cm_data_ipg_and_filter(simout_files(i).full_name,q);

      % Daten nachträglich bearbeiten
      %-------------------------------------
      if( ~isempty(d) )
        
        [d,u,c] = cg_convert_cm_data_dFkt(d,u,c,q);
        
        h{length(h)+1} = [simout_files(i).body,'/IPG'];
        h{length(h)+1} = c;

        % Matlab-File speichern
        %----------------------
        h{length(h)+1} = c;

        if( ~isempty(q.add_to_save_file_name) )
          mfile = suche_files_f(mat_simout_file,'',1,1);
          mat_simout_file = fullfile(mfile(1).dir,[mfile1(i).body,q.add_to_save_file_name,'.mat']);
        end
        q.mat_file{i} = mat_simout_file;

        switch(q.save_type)
          case 'mat_dspa'

            mat_mess_file = iqf_save_mat(d,u,h,q.mat_file{i},'dspa');
            fprintf('Mat-Ausgabe-Datei dspa-Format: <%s>\n========================================================================================================\n' ...
                    ,mat_mess_file);
          case 'mat_duh'

            mat_mess_file = iqf_save_mat(d,u,h,q.mat_file{i},'duh');
            fprintf('Mat-Ausgabe-Datei duh-Format: <%s>\n========================================================================================================\n' ...
                    ,mat_mess_file);
          otherwise
            fprintf('Kein gültiges Format für <%s>\n========================================================================================================\n' ...
                    ,mat_mess_file);

        end
      else
        warning('Kein Daten aus <%s>',mess_files(i).full_name);
      end


    end
    i = i+1;
  end
end
function okay = iqf_prepare_tacc_mess_check_data(full_name,S)

  
  [okay,d,u,h] = d_data_read_mat(full_name);
  
  c_text = fields(d);
  
  n = 0;
  for i=1:length(S)
    
    if( S(i).notwendig )
      n = n +1;
      c_such{n} = S(i).name_out;
    end
  end
  for i=1:n
    
    ifound = cell_find_f(c_text,c_such{i},'f');
    
    if( isempty(ifound) )
      
      okay = 0;
    end
  end
end

function [mat_file,mat_body] = cg_convert_cm_data_mat_filename(can_mess_file)


  % matlab-name bilden
  %-------------------
  s_file = str_get_pfe_f(can_mess_file);
  i0 = str_find_f(s_file.name,'canlog','vs');
  %if( strcmp(s_file.name,'canlog') ) 
  if( i0 > 0 ) 
      [c_names,ncount] = str_split(s_file.dir,'\');
      name = 'mat_out';
      for i=ncount:-1:1
          if( ~isempty(c_names{i}) )
              name = c_names{i};
              break;
          end
      end
      mat_file = [s_file.dir,name,'.mat'];
      mat_body = name;
  else
      mat_file = [s_file.dir,s_file.name,'.mat'];
      mat_body = s_file.name;
  end
end
function [d,u,c,h] = cg_convert_cm_data_ipg_and_filter(mess_file,q)
%
%  [d,u,c] = cg_convert_cm_data_can_and_filter(mess_file,q)
%  d -Datenstruktur
%  u - Einheitenstruktur
%  c - Kommentarstruktur
% Daten einlesen
%-------------------------
%
%   nsig = length(q.Ssig);
%   
%   % Signalliste
%   %============ 
%   c_signame = cell(nsig,1);
%   lin_liste = zeros(nsig,1);
%   for i=1:nsig
%     c_signame{i} = q.Ssig(i).name_in;
%     lin_liste(i) = q.Ssig(i).lin_in;
%   end
  tic
  [d,u,h,okay] =ccmread('erg_file',mess_file);
  
  
  if( ~okay )
    warning('cg_convert_cm_data_ipg_and_filt: Datei: <%s> enthält keine Daten',mess_file);
    d = [];
    u = [];
    c = [];
  else

    d = d_data_set_nan_to_zero(d);
    % äquidistant erstellen e -> d
    %-------------------------------------
    [d,u,c]  = cg_convert_cm_data_ipg_and_filter_wand(d,u,q);

    % Daten beschneiden, wenn gewünscht tstart, tend
    %-----------------------------------------------
    d = cg_convert_cm_data_can_and_filter_cut_time(d,q);
    
  end
  toc
end
function e = cg_convert_cm_data_can_and_filter_sign(e,sign_liste)

  for i=1:length(sign_liste)
    name_m = sign_liste{i}{1};
    name_s = sign_liste{i}{2};
    
    if( isfield(e,name_m) && isfield(e,name_s) )
      
      for j=1:min(length(e.(name_m).time),length(e.(name_s).time))
        
        if( e.(name_s).vec(j) > 0.5 )
          e.(name_m).vec(j) = e.(name_m).vec(j)*(-1.);
        end
      end
    end
  end
end
function [d,u,c]  = cg_convert_cm_data_ipg_and_filter_wand(de,ue,q)

  d = struct;
  u = struct;
  c = struct;

  % Namen der e-Struktur
  c_name = fieldnames(de);
  n      = length(c_name);

  % Länge der SSig-Struktur
  ns     = length(q.Ssig);
  
  % Anfangszeit t0
  t0 = 1e300;
  for i=1:n
    t0 = min(t0,de.time(1));
  end
  
  % Endzeit t1
  t1 = 0;
  for i=1:n
    t1 = max(t1,max(de.time));
  end

  % Zeitvektor
  d.time = [t0:q.delta_t:t1]';
  nt     = length(d.time);
  u.time = 's';
  
  sig_names_not_in_liste   = {};
  n_sig_names_not_in_liste = 0;
  
  for i=1:n
    
    % Signal in Ssig-Strukturliste suchen
    jsig = 0;
    for j=1:ns

      if( strcmp(c_name{i},q.Ssig(j).name_in) )
        jsig = j;
        break;
      end
    end
%     if( strcmp(c_name{i},'ContiUser_LinQfOut_IQF1_RefPriority') )
%       st = 0;
%     end
    
    if( jsig )
      % pause(1.0);
      % Factor und Offset für Einheitenäanderung
      %-----------------------------------------
      if( ~isempty(ue.(c_name{i})) )
        unit_in  = ue.(c_name{i});
      else
        unit_in  = q.Ssig(j).unit_in;
      end
      try
        [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,q.Ssig(jsig).unit_out);
      catch
        fac = 1;
        offset = 0;
        warning('%s -> %s ; Einheit <%s> konnte nicht in <%s> gewandelt werden.',q.Ssig(jsig).name_in,q.Ssig(jsig).name_out,unit_in,q.Ssig(jsig).unit_out)
      end
      if( ~isempty(errtext) )
        error('Fehler bei unit-convert in Signal <%s> \n%s',c_name{i},errtext)
      end
    
      if( q.Ssig(jsig).lin_in )

        name     = q.Ssig(j).name_out;

        if(  ~isa(de.(c_name{i}),'double') ...
          && ~isa(de.(c_name{i}),'float') ...
          && ~isa(de.(c_name{i}),'single') ...
          )

          if(  isa(de.(c_name{i}),'numeric') )
             de.(c_name{i}) = double(de.(c_name{i}));
          end
        end

        try
         d.(name) = interp1(de.time,de.(c_name{i}),d.time,'linear');
         d.(name) =  d.(name)* fac + offset;
        catch
          error('interp1');
        end

        % Einheit
        u.(name) = q.Ssig(jsig).unit_out;

        % Comment
        c.(c_name{i}) = q.Ssig(j).comment;

      else
        name = q.Ssig(j).name_out;
        try
          d.(name) = interp1_const(de.time,de.(c_name{i}),d.time);
          d.(name) =  d.(name)* fac + offset;
        catch
          error('interp1_const');
        end
        % Einheit
        u.(name) = q.Ssig(jsig).unit_out;

        % Comment
        c.(c_name{i}) = q.Ssig(j).comment;
      end
    else
      n_sig_names_not_in_liste = n_sig_names_not_in_liste + 1;
      sig_names_not_in_liste{n_sig_names_not_in_liste} = c_name{i};
    end
    
  end 
  for i = 1:n_sig_names_not_in_liste
    name = sig_names_not_in_liste{i};
    if( ~strcmp(name,'time') && ~struct_find_f(d,name) && (length(de.time)==length(de.(name))) )
      d.(name) = interp1(de.time,double(de.(name)),d.time,'linear');
      u.(name) = ue.(name);
      c.(name) = '';
    end
  end

  if( q.zero_time )
    d.time = d.time - d.time(1);
  end
end
function d = cg_convert_cm_data_can_and_filter_cut_time(d,q)

  % Zuerst Index
  index_start = 1;
  index_end   = length(d.time);
  flag        = 0;
  if( q.index_start > 0 )
    index_start = max(index_start,q.index_start);
    flag        = 1;
  end
  if( q.index_end > 0 )
    index_end = min(index_end,q.index_end);
    flag      = 1;
  end
  if( q.tstart >= 0.0 )
    index_start = max(index_start,suche_index(d.time,q.tstart));
    flag        = 1;
  end
  if( q.tend >= 0.0 )
    index_end = min(index_end,suche_index(d.time,q.tstart));
    flag      = 1;
  end
  if( flag )            
      if( index_start > 0 && index_end > 0 && index_end >= index_start )
          fields = fieldnames(d);

          for i = 1:length(fields)
              if( length(d.(fields{i})) >= index_end )
                  d.(fields{i}) = d.(fields{i})(index_start:index_end);
              end
          end
          if( q.zero_time )
            d.time = d.time - d.time(1);
          end
      end
  end
end
function [d,u,c] = cg_convert_cm_data_dFkt(d,u,c,q)
%
% Modifyfunction [d,u,c] = name(d,u,c);
%
  for i=1:q.n_dFkt

    dir_org = pwd;
    if( ~isempty(q.dFkt(i).dir) )
      if( ~exist(q.dFkt(i).dir,'dir') )
        error('Das Verzeichnis <%s> aus q.mod_dDataFkt{%i} exisistiert nicht !', ...
          q.dFkt(i).dir,i);
      else
        cd(q.dFkt(i).dir);
      end
    end
    try
      eval(['[d,u,c]=',q.dFkt(i).name,'(d,u,c);']);
    catch exception
     cd(dir_org);
     throw(exception)
    end
    cd(dir_org);
  end
end


