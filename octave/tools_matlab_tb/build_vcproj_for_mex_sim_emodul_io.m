function q = build_vcproj_for_mex_sim_emodul_io(q)

  % Behandlung sim_EMODUL_SIM.cpp
  q = build_vcproj_for_mex_sim_emodul_io_sim_modul(q);
  % Behandlung fkt_EMODUL_SIM.cpp
  q = build_vcproj_for_mex_sim_emodul_io_fkt(q);
end
function q = build_vcproj_for_mex_sim_emodul_io_sim_modul(q)

  % Kennzeichnung im Header 
  q.KENNUNG_SIM_START_H        = '/*##EMODUL_SIM_START_H##*/';
  q.KENNUNG_SIM_END_H          = '/*##EMODUL_SIM_END_H##*/';
  % Kennzeichnung im Include-Bereich 
  q.KENNUNG_SIM_START_INC      = '/*##EMODUL_SIM_START_INC##*/';
  q.KENNUNG_SIM_END_INC        = '/*##EMODUL_SIM_END_INC##*/';
  % Kennzeichnung im Inpput-Loop-Bereich (d.h. nach ausgeführter Loop-Berechnung)
  q.KENNUNG_SIM_START_INP_LOOP = '/*##EMODUL_SIM_START_INP_LOOP##*/';
  q.KENNUNG_SIM_END_INP_LOOP   = '/*##EMODUL_SIM_END_INP_LOOP##*/';
  % Kennzeichnung im Output-Loop-Bereich (d.h. nach ausgeführter Loop-Berechnung)
  q.KENNUNG_SIM_START_OUT_LOOP = '/*##EMODUL_SIM_START_OUT_LOOP##*/';
  q.KENNUNG_SIM_END_OUT_LOOP   = '/*##EMODUL_SIM_END_OUT_LOOP##*/';

  q.VAR_SIM_INP_NAME                  = 'pSimInpVarNames';
  q.VAR_SIM_INP_UNIT_NAME             = 'pSimInpUnitNames';
  q.VAR_SIM_OUT_NAME                  = 'pSimOutVarNames';
  q.VAR_SIM_OUT_UNIT_NAME             = 'pSimOutUnitNames';

  q.SIM_KENNUNG_SIM_N_INP          = 'SIM_EMODUL_SIM_N_INP';
  q.SIM_KENNUNG_SIM_STRUCT_INP_VAR = 'SimInp';
  q.SIM_KENNUNG_SIM_N_OUT          = 'SIM_EMODUL_SIM_N_OUT';
  q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR = 'SimOut';
  

  % sim_MODUL_SIM.cpp suchen
  %---------------------------
  simcppfile = '';
  for i=1:length(q.source_files)
    if(str_find_f(q.source_files{i}{1},'sim_EMODUL_SIM.cpp'))
      simcppfile = q.source_files{i}{1};
      simhfile = str_filename_change_ext(simcppfile,'h');
      break;
    end
  end
  if( isempty(simcppfile) )
    error(' Die Datei sim_EMODUL_SIM.cpp konnte in q.source_files nicht gefunden werden');
  end
      
  % Parameter
  % Kennzeichnung im Header
  if( ~check_val_in_struct(q,'KENNUNG_SIM_START_H','char',1) )
    q.KENNUNG_SIM_START_H        = '/*##EMODUL_SIM_START_H##*/';
    q.KENNUNG_SIM_END_H          = '/*##EMODUL_SIM_END_H##*/';
  end
  % Kennzeichnung im Include-Bereich 
  if( ~check_val_in_struct(q,'KENNUNG_SIM_START_INC','char',1) )
    q.KENNUNG_SIM_START_INC      = '/*##EMODUL_SIM_START_INC##*/';
    q.KENNUNG_SIM_END_INC        = '/*##EMODUL_SIM_END_INC##*/';
  end
  
  % Kennzeichnung im Loop-const-Bereich (d.h. vor Loop-Berechnung)
  q.KENNUNG_SIM_START_PAR_PERM = '/*##EMODUL_SIM_START_PAR_PERM##*/';
  q.KENNUNG_SIM_END_PAR_PERM   = '/*##EMODUL_SIM_END_PAR_PERM##*/';
  % Kennzeichnung im Loop-Bereich (d.h. vor Loop-Berechnung)
  q.KENNUNG_SIM_START_PAR_LOOP = '/*##EMODUL_SIM_START_PAR_LOOP##*/';
  q.KENNUNG_SIM_END_PAR_LOOP   = '/*##EMODUL_SIM_END_PAR_LOOP##*/';
  % Kennzeichnung im Init-Bereich vor ausführung init
  q.KENNUNG_SIM_START_PAR_INIT0 = '/*##EMODUL_SIM_START_PAR_INIT0##*/';
  q.KENNUNG_SIM_END_PAR_INIT0   = '/*##EMODUL_SIM_END_PAR_INIT0##*/';
  % Kennzeichnung im Init-Bereich nach ausführung init
  q.KENNUNG_SIM_START_PAR_INIT1 = '/*##EMODUL_SIM_START_PAR_INIT1##*/';
  q.KENNUNG_SIM_END_PAR_INIT1   = '/*##EMODUL_SIM_END_PAR_INIT1##*/';

  q.VAR_SIM_PAR_NAME                  = 'pSimParVarNames';
  q.VAR_SIM_PAR_UNIT_NAME             = 'pSimParUnitNames';

  q.SIM_KENNUNG_SIM_N_PAR      = 'SIM_EMODUL_SIM_N_PAR';
  q.SIM_KENNUNG_SIM_N_LOOP_PAR = 'SIM_EMODUL_SIM_N_LOOP_PAR';

  q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR = 'SimPar';

  % sim_MODUL_SIM.cpp suchen
  %---------------------------
  if( isempty(simcppfile) )
    error('%s: Das Simulationsfile ist nicht festgelegt',mfilename);
  end

  q = build_vcproj_for_mex_sim_io_build_sim_hfile(q,simhfile);
  q = build_vcproj_for_mex_sim_io_build_sim_cppfile(q,simcppfile);
end
function q = build_vcproj_for_mex_sim_io_build_sim_hfile(q,simhfile)

% simhfile bearbeiten
% sim_EMODUL_SIM.h          q.type='time_step'
%
  % h-Datei einlesen
  %-----------------
  [ okay,c,n ] = read_ascii_file(simhfile);
  if( ~okay )
    error('%s_error: simhfile: <%s> konnte nicht eingelesen werden !!!',mfilename,simhfile);
  end
  
  % h-Bereich bearbeiten
  %---------------------------
  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_SIM_START_H,q.KENNUNG_SIM_END_H,0);

  cinsert = {};
  ninsert = 0;
  % Input zählen
  ninp = 0;
  for i=1:length(q.sim_def_var_inp)
    if(  strcmp(q.sim_def_var_inp(i).type,'single') ...
      || strcmp(q.sim_def_var_inp(i).type,'char') ...
      || strcmp(q.sim_def_var_inp(i).type,'string') ...
      )
      ninp = ninp + 1;
    elseif( strcmp(q.sim_def_var_inp(i).type,'mBuffer') )
      ninp = ninp + length(q.sim_def_var_inp(i).vecnames);
      ninp = ninp + 1; % Counter 
    else
      error('%s_errror: type=%s ist nicht bekannt',q.sim_def_var_inp(i).type);
    end
  end
  % Output zählen
  nout = 0;
  for i=1:length(q.sim_def_var_out)
    if(  strcmp(q.sim_def_var_out(i).type,'single') ...
      || strcmp(q.sim_def_var_out(i).type,'string') ...
      || strcmp(q.sim_def_var_out(i).type,'char') ...
      )
      nout = nout + 1;
    elseif( strcmp(q.sim_def_var_out(i).type,'mBuffer') )
      nout = nout + length(q.sim_def_var_out(i).vecnames);
      nout = nout + 1; % Counter 
    else
      error('%s_errror: type=%s ist nicht bekannt',q.sim_def_var_out(i).type);
    end
  end
  % Parameter zählen
  npar     = length(q.sim_def_var_par);
  npar = 0;
  for i=1:length(q.sim_def_var_par)
    if(  ~strcmp(q.sim_def_var_par(i).type,'cperm') ...
      && ~strcmp(q.sim_def_var_par(i).type,'cinit0') ...
      && ~strcmp(q.sim_def_var_par(i).type,'cinit1') ...
      )
      npar = npar + 1;
    end
  end
  nlooppar = 0;
  for i=1:length(q.sim_def_var_par)
    if( strcmp(q.sim_def_var_par(i).type,'single') )
      nlooppar = nlooppar + 1;
    end
  end
  % definition wieviele Ausgabestrukturen  
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_h(q ...
                    , ninp ...
                    , nout ...
                    , npar ...
                    , nlooppar ...
                    , cinsert,ninsert);

  % Zellen einfügen
  c  = cell_insert(c,i0,cinsert);
    
  % h-Simfile schreiben
  %------------------
  okay = write_ascii_file(simhfile,c);
  if( ~okay )
    error('%s_error: Fehler bei Schreiben von simhfile: <%s>',mfilename,simhfile);
  end
  
end
function q = build_vcproj_for_mex_sim_io_build_sim_cppfile(q,simcppfile)
%
% simcppfile bearbeiten
% sim_EMODUL_SIM.cpp          q.type='time_step'

  % Include-Files aus q.sim_def_var_inp und q.sim_def_var_out und q.sim_def_var_par sammeln
  %------------------------------------------------------------------
  [include_files,cpptype] = build_vcproj_for_mex_sim_io_build_sim_cppfile_get_includes(q);
  %------------------------------------------------------------------
  
  % cpp-Datei einlesen
  %-------------------
  [ okay,c,n ] = read_ascii_file(simcppfile);
  if( ~okay )
    error('%s_error: simcppfile: <%s> konnte nicht eingelesen werden !!!',mfilename,simcppfile);
  end
  
  % include-Bereich bearbeiten
  %---------------------------
  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_SIM_START_INC,q.KENNUNG_SIM_END_INC,0);
  
  cinsert = {};
  ninsert = 0;
  % includes und Definition der Ausgabename und Units
  %--------------------------------------------------
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_include(include_files,cpptype,cinsert,ninsert);
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_simnames(q,cinsert,ninsert);
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_units(q,cinsert,ninsert);
  %[cinsert,ninsert] = build_vcproj_for_mex_sim_output_build_sim_file_out_struct(q,cinsert,ninsert);

  % Zellen einfügen
  %----------------
  c  = cell_insert(c,i0,cinsert);
    
  % Loop-weise Eingabe-Bereich bearbeiten
  %--------------------------------------
  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_SIM_START_INP_LOOP,q.KENNUNG_SIM_END_INP_LOOP,1);

  cinsert = {};
  ninsert = 0;
  % Zuordnung Werte  
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_input_loop(q,cinsert,ninsert);

  % Zellen einfügen
  c  = cell_insert(c,i0,cinsert);

  % Ausgabe-Loop-Bereich bearbeiten
  %---------------------------------
  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_SIM_START_OUT_LOOP,q.KENNUNG_SIM_END_OUT_LOOP,1);

  cinsert = {};
  ninsert = 0;
  % Zuordnung Werte  
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_output_loop(q,cinsert,ninsert);

  % Zellen einfügen
  c  = cell_insert(c,i0,cinsert);
  
  % Parameter-Loop-perm-Bereich bearbeiten
  %----------------------------------------
  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_SIM_START_PAR_PERM,q.KENNUNG_SIM_END_PAR_PERM,1);

  cinsert = {};
  ninsert = 0;
  % Zuordnung Werte  
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_parameter_const(q,cinsert,ninsert);

  % Zellen einfügen
  if( ninsert )
    c  = cell_insert(c,i0,cinsert);
  end
  
  % Parameter-Loop-Bereich bearbeiten
  %---------------------------------
  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_SIM_START_PAR_LOOP,q.KENNUNG_SIM_END_PAR_LOOP,1);

  cinsert = {};
  ninsert = 0;
  % Zuordnung Werte  
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_parameter_loop(q,cinsert,ninsert);

  % Zellen einfügen
  if( ninsert )
    c  = cell_insert(c,i0,cinsert);
  end

  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_SIM_START_PAR_INIT0,q.KENNUNG_SIM_END_PAR_INIT0,1);

  cinsert = {};
  ninsert = 0;
  % Zuordnung Werte  
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_parameter_init0(q,cinsert,ninsert);

  % Zellen einfügen
  if( ninsert )
    c  = cell_insert(c,i0,cinsert);
  end

  [c,i0] = Kennung_bereinigen(c,q.KENNUNG_SIM_START_PAR_INIT1,q.KENNUNG_SIM_END_PAR_INIT1,1);

  cinsert = {};
  ninsert = 0;
  % Zuordnung Werte  
  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_parameter_init1(q,cinsert,ninsert);

  % Zellen einfügen
  if( ninsert )
    c  = cell_insert(c,i0,cinsert);
  end
  
  % c-Simfile schreiben
  %------------------
  okay = write_ascii_file(simcppfile,c);
  if( ~okay )
    error('%s_error: Fehler bei Schreiben von simcppfile: <%s>',mfilename,simcppfile);
  end
end
function [include_files,cpptype] = build_vcproj_for_mex_sim_io_build_sim_cppfile_get_includes(q)
%------------------------------------------------------------------
% Include-Files aus q.sim_def_var_inp und q.sim_def_var_out sammeln
%------------------------------------------------------------------
  include_files = {};
  cpptype       = [];
  
  n = length(q.sim_def_var_inp);
  for i = 1:n
    if( ~isempty(q.sim_def_var_inp(i).varinc) )
      ctext = str_split(q.sim_def_var_inp(i).varinc,'|');
      for k=1:length(ctext)
        [ifound,ipos] = cell_find_f(include_files,ctext{k},'fl');
        if( isempty(ifound) )
          include_files = cell_add(include_files,ctext{k});
          if( strcmpi(q.sim_def_var_inp(i).vartype,'C++') )
            cpptype = [cpptype;1];  % cpp-type
          else
            cpptype = [cpptype;0];  % kein cpp-type
          end
        end
      end
    end
  end
  n = length(q.sim_def_var_out);
  for i = 1:n
    if( ~isempty(q.sim_def_var_out(i).varinc) )
      ctext = str_split(q.sim_def_var_out(i).varinc,'|');
      for k=1:length(ctext)
        [ifound,ipos] = cell_find_f(include_files,ctext{k},'fl');
        if( isempty(ifound) )
          include_files = cell_add(include_files,ctext{k});
          if( strcmpi(q.sim_def_var_out(i).vartype,'C++') )
            cpptype = [cpptype;1];  % cpp-type
          else
            cpptype = [cpptype;0];  % kein cpp-type
          end
        end
      end
    end
  end
  n = length(q.sim_def_var_par);
  for i = 1:n
    if( ~isempty(q.sim_def_var_par(i).varinc) )
      ctext = str_split(q.sim_def_var_par(i).varinc,'|');
      for k=1:length(ctext)
        [ifound,ipos] = cell_find_f(include_files,ctext{k},'fl');
        if( isempty(ifound) )
          include_files = cell_add(include_files,ctext{k});
          if( strcmpi(q.sim_def_var_par(i).vartype,'C++') )
            cpptype = [cpptype;1];  % cpp-type
          else
            cpptype = [cpptype;0];  % kein cpp-type
          end
        end
      end
    end
  end
end
function  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_h(q,ninp,nout,npar,nlooppar,cinsert,ninsert)

  ninsert = ninsert+1;
  if( ninp )
    cinsert{ninsert} = sprintf('#define %s %i',q.SIM_KENNUNG_SIM_N_INP,ninp);
  else
    cinsert{ninsert} = sprintf('#define %s %i',q.SIM_KENNUNG_SIM_N_INP,1);
  end
  
  ninsert = ninsert+1;
  if( nout )
    cinsert{ninsert} = sprintf('#define %s %i',q.SIM_KENNUNG_SIM_N_OUT,nout);
  else
    cinsert{ninsert} = sprintf('#define %s %i',q.SIM_KENNUNG_SIM_N_OUT,1);
  end
  
  ninsert = ninsert+1;
  if( npar )
    cinsert{ninsert} = sprintf('#define %s %i',q.SIM_KENNUNG_SIM_N_PAR,npar);
  else
    cinsert{ninsert} = sprintf('#define %s %i',q.SIM_KENNUNG_SIM_N_PAR,1);
  end
  
  ninsert = ninsert+1;
  cinsert{ninsert} = sprintf('#define %s %i',q.SIM_KENNUNG_SIM_N_LOOP_PAR,nlooppar);
    
end
function [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_include(include_files,cpptype,cinsert,ninsert)

  % cpp-include-Files
  for i=1:length(include_files)
    if( cpptype(i) )
      s = str_get_pfe_f(include_files{i});
      if( isempty(s.ext) )
        file_flag = 0;
      else
        file_flag = 1;
      end
      ninsert = ninsert+1;
      if( file_flag )
        cinsert{ninsert} = sprintf('#include "%s"',include_files{i});
      else
        cinsert{ninsert} = sprintf('%s;',include_files{i});
      end
    end
  end
  % c-include-Files
  cinsert{ninsert+1} = '#ifdef __cplusplus';
  cinsert{ninsert+2} = 'extern "C" {';
  cinsert{ninsert+3} = '#endif';
  ninsert            = ninsert+3;
  for i=1:length(include_files)
    if( ~cpptype(i) )
      s = str_get_pfe_f(include_files{i});
      if( isempty(s.ext) )
        file_flag = 0;
      else
        file_flag = 1;
      end
      ninsert = ninsert+1;
      if( file_flag )
        cinsert{ninsert} = sprintf('#include "%s"',include_files{i});
      else
        cinsert{ninsert} = sprintf('%s;',include_files{i});
      end
    end
  end
  cinsert{ninsert+1} = '#ifdef __cplusplus';
  cinsert{ninsert+2} = '}';
  cinsert{ninsert+3} = '#endif';
  ninsert            = ninsert+3;
end
function  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_simnames(q,cinsert,ninsert)
  
%Definition der Input-simulationsnamen
  %-------------------------------------    
  % Liste erstellen 
  liste_namen = {};
  for i=1:length(q.sim_def_var_inp)
    if(  strcmp(q.sim_def_var_inp(i).type,'single') ... 
      || strcmp(q.sim_def_var_inp(i).type,'string') ...
      || strcmp(q.sim_def_var_inp(i).type,'char') ...
      )
      liste_namen = cell_add(liste_namen,q.sim_def_var_inp(i).name);
    elseif( strcmp(q.sim_def_var_inp(i).type,'mBuffer') )
      for j=1:length(q.sim_def_var_inp(i).vecnames)
        liste_namen = cell_add(liste_namen,[q.sim_def_var_inp(i).name,'_',q.sim_def_var_inp(i).vecnames{j}]);
      end
      liste_namen = cell_add(liste_namen,[q.sim_def_var_inp(i).name,'_mBufferCnt']);
    else
      error('%s_errror: type=%s ist nicht bekannt',q.sim_def_var_inp(i).type);
    end
  end

  if( ~isempty(liste_namen) )
    cinsert{ninsert+1} = sprintf('char *%s[] = {"%s"',q.VAR_SIM_INP_NAME,liste_namen{1});
  else
    cinsert{ninsert+1} = sprintf('char *%s[] = {"dummy"',q.VAR_SIM_INP_NAME);
  end
  ninsert = ninsert+1;

  ll = [];for i=1:length(q.VAR_SIM_INP_NAME)+11,ll = [ll,' '];end 
  for i=2:length(liste_namen)
    ninsert = ninsert+1;
    cinsert{ninsert} = sprintf('%s,"%s"',ll,liste_namen{i});
  end
  ninsert = ninsert+1;
  cinsert{ninsert} = sprintf('%s};',ll);

  % Definition der Output-Simulationsnamen
  %---------------------------------------

  % Liste erstellen 
  liste_namen = {};
  for i=1:length(q.sim_def_var_out)
    if(  strcmp(q.sim_def_var_out(i).type,'single') ...
      || strcmp(q.sim_def_var_out(i).type,'string') ...
      || strcmp(q.sim_def_var_out(i).type,'char') ...
      )
      liste_namen = cell_add(liste_namen,q.sim_def_var_out(i).name);
    elseif( strcmp(q.sim_def_var_out(i).type,'mBuffer') )
      for j=1:length(q.sim_def_var_out(i).vecnames)
        liste_namen = cell_add(liste_namen,[q.sim_def_var_out(i).name,'_',q.sim_def_var_out(i).vecnames{j}]);
      end
      liste_namen = cell_add(liste_namen,[q.sim_def_var_out(i).name,'_mBufferCnt']);
    else
      error('%s_errror: type=%s ist nicht bekannt',q.sim_def_var_out(i).type);
    end
  end


  ninsert = ninsert+1;
  if( ~isempty(liste_namen) )
    cinsert{ninsert} = sprintf('char *%s[] = {"%s"',q.VAR_SIM_OUT_NAME,liste_namen{1});
  else
    cinsert{ninsert} = sprintf('char *%s[] = {"dummy"',q.VAR_SIM_OUT_NAME);
  end
  ll = [];for i=1:length(q.VAR_SIM_OUT_NAME)+11,ll = [ll,' '];end 
  for i=2:length(liste_namen)
    ninsert = ninsert+1;
    cinsert{ninsert} = sprintf('%s,"%s"',ll,liste_namen{i});
  end
  ninsert = ninsert+1;
  cinsert{ninsert} = sprintf('%s};',ll);

  % Parameter
  % Liste erstellen 
  liste_namen = {};
  for i=1:length(q.sim_def_var_par)
    if(  ~strcmp(q.sim_def_var_par(i).type,'cperm') ...
      && ~strcmp(q.sim_def_var_par(i).type,'cinit0') ...
      && ~strcmp(q.sim_def_var_par(i).type,'cinit1') ...
      )
      liste_namen = cell_add(liste_namen,q.sim_def_var_par(i).name);
    end
  end
  ninsert = ninsert+1;
  if( ~isempty(liste_namen) )
    cinsert{ninsert} = sprintf('char *%s[] = {"%s"',q.VAR_SIM_PAR_NAME,liste_namen{1});
  else
    cinsert{ninsert} = sprintf('char *%s[] = {"dummy"',q.VAR_SIM_PAR_NAME);
  end
  ll = [];for i=1:length(q.VAR_SIM_PAR_NAME)+11,ll = [ll,' '];end 
  for i=2:length(liste_namen)
    ninsert = ninsert+1;
    cinsert{ninsert} = sprintf('%s,"%s"',ll,liste_namen{i});
  end
  ninsert = ninsert+1;
  cinsert{ninsert} = sprintf('%s};',ll);
end
function  [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_units(q,cinsert,ninsert)

  liste_unit = {};
  for i=1:length(q.sim_def_var_inp)
    if(  strcmp(q.sim_def_var_inp(i).type,'single') ...
      || strcmp(q.sim_def_var_inp(i).type,'string') ...
      || strcmp(q.sim_def_var_inp(i).type,'char') ...
      )
      liste_unit = cell_add(liste_unit,q.sim_def_var_inp(i).unit);
    elseif( strcmp(q.sim_def_var_inp(i).type,'mBuffer') )
      for j=1:length(q.sim_def_var_inp(i).unit)
        liste_unit = cell_add(liste_unit,q.sim_def_var_inp(i).unit{j});
      end
      liste_unit = cell_add(liste_unit,'enum'); % Counter
    else
      error('%s_errror: type=%s ist nicht bekannt',q.sim_def_var_inp(i).type);
    end
  end

  %Definition der Input-simulations-unit-namen
  ninsert = ninsert+1;
  if( ~isempty(liste_unit) )
    cinsert{ninsert} = sprintf('char *%s[] = {"%s"',q.VAR_SIM_INP_UNIT_NAME,liste_unit{1});
  else
    cinsert{ninsert} = sprintf('char *%s[] = {"-"',q.VAR_SIM_INP_UNIT_NAME);
  end
  ll = [];for i=1:length(q.VAR_SIM_INP_UNIT_NAME)+11,ll = [ll,' '];end 
  for i=2:length(liste_unit)
    ninsert = ninsert+1;
    cinsert{ninsert} = sprintf('%s,"%s"',ll,liste_unit{i});
  end
  ninsert = ninsert+1;
  cinsert{ninsert} = sprintf('%s};',ll);
  
  liste_unit = {};
  for i=1:length(q.sim_def_var_out)
    if( strcmp(q.sim_def_var_out(i).type,'single') ...
      || strcmp(q.sim_def_var_out(i).type,'string') ...
      || strcmp(q.sim_def_var_out(i).type,'char') ...
      )
      liste_unit = cell_add(liste_unit,q.sim_def_var_out(i).unit);
    elseif( strcmp(q.sim_def_var_out(i).type,'mBuffer') )
      for j=1:length(q.sim_def_var_out(i).unit)
        liste_unit = cell_add(liste_unit,q.sim_def_var_out(i).unit{j});
      end
      liste_unit = cell_add(liste_unit,'enum'); % Counter
    else
      error('%s_errror: type=%s ist nicht bekannt',q.sim_def_var_out(i).type);
    end
  end

  %Definition der Output-simulations-unit-namen
  ninsert = ninsert+1;
  if( ~isempty(liste_unit) )
    cinsert{ninsert} = sprintf('char *%s[] = {"%s"',q.VAR_SIM_OUT_UNIT_NAME,liste_unit{1});
  else
    cinsert{ninsert} = sprintf('char *%s[] = {"-"',q.VAR_SIM_OUT_UNIT_NAME);
  end
  ll = [];for i=1:length(q.VAR_SIM_OUT_UNIT_NAME)+11,ll = [ll,' '];end 
  for i=2:length(liste_unit)
    ninsert = ninsert+1;
    cinsert{ninsert} = sprintf('%s,"%s"',ll,liste_unit{i});
  end
  ninsert = ninsert+1;
  cinsert{ninsert} = sprintf('%s};',ll);

  if( ~isempty(q.sim_def_var_par) )   
    liste_unit = {};
    for i=1:length(q.sim_def_var_par)
      if(  ~strcmp(q.sim_def_var_par(i).type,'cperm') ...
        && ~strcmp(q.sim_def_var_par(i).type,'cinit0') ...
        && ~strcmp(q.sim_def_var_par(i).type,'cinit1') ...
        )
        liste_unit = cell_add(liste_unit,q.sim_def_var_par(i).unit);
      end
    end
    
    %Definition der Output-simulations-unit-namen
    ninsert = ninsert+1;
    if( ~isempty(liste_unit) )
      cinsert{ninsert} = sprintf('char *%s[] = {"%s"',q.VAR_SIM_PAR_UNIT_NAME,liste_unit{1});
    else
      cinsert{ninsert} = sprintf('char *%s[] = {"-"',q.VAR_SIM_PAR_UNIT_NAME);
    end
    ll = [];for i=1:length(q.VAR_SIM_PAR_UNIT_NAME)+11,ll = [ll,' '];end 
    for i=2:length(liste_unit)
      ninsert = ninsert+1;
      cinsert{ninsert} = sprintf('%s,"%s"',ll,liste_unit{i});
    end
    ninsert = ninsert+1;
    cinsert{ninsert} = sprintf('%s};',ll);

  end
end
function [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_input_loop(q,cinsert,ninsert)
% q.sim_def_var_inp(i).name      Simulationsname
% q.sim_def_var_inp(i).unit      Einheit in der Simulation
% q.sim_def_var_inp(i).type      single, Buffer
% q.sim_def_var_inp(i).id        CAN-ID, wenn gesetzt wird beim Einlesen der Botschaft der Wert
%                                gesetzt, ansonsten nach der Loop
% q.sim_def_var_inp(i).channel   Channel zu id
% q.sim_def_var_inp(i).varname   vollständiger C-Name
% q.sim_def_var_inp(i).varinc    include-Datei für die Variable z.B. 'abc.h'
% q.sim_def_var_inp(i).vartype   'C' oder 'C++', default 'C' für include
% q.sim_def_var_inp(i).varformat C-Format von varname float, ...
% q.sim_def_var_inp(i).varunit   Einheit für varname
% q.sim_def_var_inp(i).comment   Kommentar

  mBuffer_flag = 0;
  for i=1:length(q.sim_def_var_inp)
    if( strcmp(q.sim_def_var_inp(i).type,'mBuffer') )
      mBuffer_flag = 1;
      break;
    end
  end
%     size_t i;
% 
%     /* VehicleDynamicsIn_flagNew */
%     if( (*ptime >= SimInp[0].time[SimInp[0].iAct]) && (SimInp[0].iAct < SimInp[0].n) )
%     {
%       AD2PInput.VehicleDynamicsIn_flagNew = (unsigned char)(SimInp[0].vec[SimInp[0].iAct]);
%       if( SimInp[0].iAct < SimInp[0].n ) ++(SimInp[0].iAct);
%     }
% 
   
  tt = '  ';
  cinsert{ninsert+1} = [tt,'{'];
  tt = '    ';
  cinsert{ninsert+2} = [tt,'size_t i;'];
  ninsert            = ninsert+2;

  i = 0;
  for ii=1:length(q.sim_def_var_inp)
    
    if( strcmp(q.sim_def_var_inp(ii).type,'single') )
      i = i+1;
      [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_inp(ii).unit ...
                                                        ,q.sim_def_var_inp(ii).varunit);
      if( ~isempty(errtext) )
        error('%s: %s',q.sim_def_var_inp(ii).name,errtext);
      end
      if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
        nofacoffset = 1;
      else
        nofacoffset = 0;
      end

      cinsert{ninsert+1} = '';
      cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_inp(ii).name);
      cinsert{ninsert+3} = sprintf('%sif( %s[%i].iAct < %s[%i].n )' ...
                                  ,tt ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+4} = sprintf('%s{',tt);
      
      cinsert{ninsert+5} = sprintf('%sif( (*ptime >= %s[%i].time[%s[%i].iAct]) )' ...
                                  ,[tt,'  '] ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+6} = sprintf('%s{',[tt,'  ']);
      if( nofacoffset )
        cinsert{ninsert+7} = sprintf('%s%s = (%s)(%s[%i].vec[%s[%i].iAct]);' ...
                                    ,[tt,'    '] ...
                                    ,q.sim_def_var_inp(ii).varname ...
                                    ,q.sim_def_var_inp(ii).varformat ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    );
      else
        cinsert{ninsert+7} = sprintf('%s%s = (%s)(%s[%i].vec[%s[%i].iAct] * %f + %f);' ...
                                    ,[tt,'    '] ...
                                    ,q.sim_def_var_inp(ii).varname ...
                                    ,q.sim_def_var_inp(ii).varformat ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    ,fac ...
                                    ,offset ...
                                    );
      end
      cinsert{ninsert+8} = sprintf('%s++(%s[%i].iAct);' ...
                                  ,[tt,'    '] ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+9}  = sprintf('%s}',[tt,'  ']);
      cinsert{ninsert+10} = sprintf('%s}',tt);
      ninsert             = ninsert+10;
    elseif( strcmp(q.sim_def_var_inp(ii).type,'char') )
      i = i+1;
%    /* VehDsrdTraj1_appName */
%     if( SimInp[28].iAct < SimInp[28].n )
%     {
%       strcpy_s(ADCInput.VehDsrdTraj1_appName,10,SimInp[29].stringval.c_str());
%       ++(SimInp[28].iAct);
%     }

      cinsert{ninsert+1} = '';
      cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_inp(ii).name);
      cinsert{ninsert+3} = sprintf('%sif( %s[%i].iAct < %s[%i].n )' ...
                                  ,tt ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+4} = sprintf('%s{',tt);
      cinsert{ninsert+5} = sprintf('%sstd::string s = %s[%i].vecstring[%s[%i].iAct];' ...
                                  ,[tt,'    '] ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
       cinsert{ninsert+6} = sprintf('%sif( s.size() >= %i ) s.resize(%i);' ...
                                  ,[tt,'    '] ...
                                  ,q.sim_def_var_inp(ii).length ...
                                  ,(q.sim_def_var_inp(ii).length - 1) ...
                                  );
       cinsert{ninsert+7} = sprintf('%sstrcpy_s(%s,%i,s.c_str());' ...
                                  ,[tt,'    '] ...
                                  ,q.sim_def_var_inp(ii).varname ...
                                  ,q.sim_def_var_inp(ii).length ...
                                  );
      cinsert{ninsert+8} = sprintf('%s++(%s[%i].iAct);' ...
                                  ,[tt,'    '] ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+9} = sprintf('%s}',tt);
      ninsert             = ninsert+9;
    elseif( strcmp(q.sim_def_var_inp(ii).type,'string') )
      i = i+1;
%     /* VehDsrdTraj1_appName */
%     if( SimInp[28].iAct < SimInp[28].n )
%     {
%       ADCInput.VehDsrdTraj1_appName.clear();
%       ADCInput.VehDsrdTraj1_appName.append(SimInp[28].stringval);
%       ++(SimInp[28].iAct);
%     }
% 

      cinsert{ninsert+1} = '';
      cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_inp(ii).name);
      cinsert{ninsert+3} = sprintf('%sif( %s[%i].iAct < %s[%i].n )' ...
                                  ,tt ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+4} = sprintf('%s{',tt);
 
%       ADCInput.VehDsrdTraj1_appName.clear();
%       ADCInput.VehDsrdTraj1_appName.append(SimInp[28].stringval);
      
      cinsert{ninsert+5} = sprintf('%s%s.clear();' ...
                                  ,[tt,'  '] ...
                                  ,q.sim_def_var_inp(ii).varname ...
                                  );
      cinsert{ninsert+6} = sprintf('%s%s.append(%s[%i]);' ...
                                  ,[tt,'  '] ...
                                  ,q.sim_def_var_inp(ii).varname ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+7} = sprintf('%s++(%s[%i].iAct);' ...
                                  ,[tt,'    '] ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+8}  = sprintf('%s}',[tt,'  ']);
      ninsert             = ninsert+8;
    elseif( strcmp(q.sim_def_var_inp(ii).type,'mBuffer') )
%     /* VehDsrdTraj1_pointFrnt_x */
%     if( (*ptime >= SimInp[24].time[SimInp[24].iAct]) && (SimInp[24].iAct < SimInp[24].n) )
%     {
%       std::vector<double> vec = SimInp[24].vecvec[SimInp[24].iAct];
%       for(i=0;i<MIN(200,vec.size());i++)
%       {
%         AD2PInput.VehDsrdTraj1_pointFrnt_x[i] = (float)(vec[i]);
%       }
%       if( SimInp[24].iAct < SimInp[24].n ) ++(SimInp[24].iAct);
%     }
     for j=1:length(q.sim_def_var_inp(ii).vecnames)
        i = i+1;
        name                 = [q.sim_def_var_inp(ii).name,'_',q.sim_def_var_inp(ii).vecnames{j}];
        varname              = [q.sim_def_var_inp(ii).varname,'_',q.sim_def_var_inp(ii).vecnames{j}];
        name_cnt             = [q.sim_def_var_inp(ii).name,'_mBufferCnt'];
        varname_cnt          = [q.sim_def_var_inp(ii).varname,'_mBufferCnt'];
        varformat            = q.sim_def_var_inp(ii).varformat{j};
        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_inp(ii).varunit{j} ...
                                                          ,q.sim_def_var_inp(ii).unit{j});
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_inp(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end

        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,name);
        cinsert{ninsert+3} = sprintf('%sif( %s[%i].iAct < %s[%i].n )' ...
                                    ,tt ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+4} = sprintf('%s{',tt);
        cinsert{ninsert+5} = sprintf('%sif( (*ptime >= %s[%i].time[%s[%i].iAct]) )' ...
                                    ,[tt,'  '] ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+6} = sprintf('%s{',[tt,'  ']);
        cinsert{ninsert+7} = sprintf('%sstd::vector<double> vec = %s[%i].vecvec[%s[%i].iAct];' ...
                                    ,[tt,'    '] ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+8} = sprintf('%sfor(i=0;i<MIN(%i,vec.size());i++)' ...
                                    ,[tt,'    '] ...
                                    ,q.sim_def_var_inp(ii).length ...
                                    );
        cinsert{ninsert+9} = sprintf('%s{',[tt,'    ']);
        if( nofacoffset )
          cinsert{ninsert+10} = sprintf('%s  %s[i] = (%s)(vec[i]);' ...
                                      ,[tt,'    '] ...
                                      ,varname ...
                                      ,varformat ...
                                      );
        else
          cinsert{ninsert+10} = sprintf('%s  %s[i] = (%s)(vec[i] * %f + %f);' ...
                                      ,[tt,'    '] ...
                                      ,varname ...
                                      ,varformat ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        cinsert{ninsert+11} = sprintf('%s}',[tt,'    ']);
        cinsert{ninsert+12} = sprintf('%s++(%s[%i].iAct);' ...
                                    ,[tt,'    '] ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+13} = sprintf('%s}',[tt,'  ']);
        cinsert{ninsert+14} = sprintf('%s}',tt);
        
        ninsert            = ninsert+14;
      end
      i = i+1;
      cinsert{ninsert+1} = '';
      cinsert{ninsert+2} = sprintf('%s/* %s */',tt,name_cnt);
      cinsert{ninsert+3} = sprintf('%sif( %s[%i].iAct < %s[%i].n )' ...
                                  ,tt ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+4} = sprintf('%s{',tt);
      cinsert{ninsert+5} = sprintf('%sif( (*ptime >= %s[%i].time[%s[%i].iAct]) )' ...
                                  ,[tt,'  '] ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+6} = sprintf('%s{',[tt,'  ']);
      cinsert{ninsert+7} = sprintf('%s%s = (%s)(%s[%i].vec[%s[%i].iAct]);' ...
                                  ,[tt,'    '] ...
                                  ,varname_cnt ...
                                  ,'size_t' ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+8} = sprintf('%s++(%s[%i].iAct);' ...
                                  ,[tt,'    '] ...
                                  ,q.SIM_KENNUNG_SIM_STRUCT_INP_VAR ...
                                  ,(i-1) ...
                                  );
      cinsert{ninsert+9} = sprintf('%s}',[tt,'  ']);
      cinsert{ninsert+10} = sprintf('%s}',tt);
      ninsert            = ninsert+10;

    else
      error('%s_error: type = %s nicht programmiert',mfilename,q.sim_def_var_inp(ii).type)
    end
  end
  tt = '  ';
  cinsert{ninsert+1} = [tt,'}'];
  ninsert            = ninsert+1;
end
function [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_output_loop(q,cinsert,ninsert)
% q.sim_def_var_out(i).name      Simulationsname
% q.sim_def_var_out(i).unit      Einheit in der Simulation
% q.sim_def_var_out(i).type      single, Buffer
% q.sim_def_var_out(i).id        CAN-ID, wenn gesetzt wird beim Einlesen der Botschaft der Wert
%                                gesetzt, ansonsten nach der Loop
% q.sim_def_var_out(i).channel   Channel zu id
% q.sim_def_var_out(i).varname   vollständiger C-Name
% q.sim_def_var_out(i).varinc    include-Datei für die Variable z.B. 'abc.h'
% q.sim_def_var_out(i).vartype   'C' oder 'C++', default 'C' für include
% q.sim_def_var_out(i).varformat C-Format von varname float, ...
% q.sim_def_var_out(i).varunit   Einheit für varname
% q.sim_def_var_out(i).comment   Kommentar

  i = 0;
  for ii=1:length(q.sim_def_var_out)
    if( strcmp(q.sim_def_var_out(ii).type,'single') )
      i = i + 1;
      if( q.sim_def_var_out(ii).id == 0 )
        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_out(ii).unit ...
                                                          ,q.sim_def_var_out(ii).varunit);
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_out(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end

        tt = '  ';
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_out(ii).name);
        cinsert{ninsert+3} = sprintf('%s%s[%i].time.push_back(*ptime);' ...
                                    ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1));
        if( nofacoffset )
          cinsert{ninsert+4} = sprintf('%s%s[%i].vec.push_back(%s);' ...
                                      ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1) ...
                                      ,q.sim_def_var_out(ii).varname ...
                                      );
        else
          cinsert{ninsert+4} = sprintf('%s%s[%i].vec.push_back(%s*%f+%f);' ...
                                      ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1) ...
                                      ,q.sim_def_var_out(ii).varname ...
                                      ,fac, offset ...
                                      );
        end
        cinsert{ninsert+5} = sprintf('%s%s[%i].comment = "%s";' ...
                                    ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1) ...
                                    ,q.sim_def_var_out(ii).comment);
        cinsert{ninsert+6} = sprintf('%s%s[%i].isvecofvec = 0;' ...
                                    ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1));
        ninsert            = ninsert+6;                    
      end
    elseif( strcmp(q.sim_def_var_out(ii).type,'mBuffer') )
      for j=1:length(q.sim_def_var_out(ii).vecnames)
        i = i + 1;
        name                 = [q.sim_def_var_out(ii).name,'_',q.sim_def_var_out(ii).vecnames{j}];
        name_Counter         = [q.sim_def_var_out(ii).name,'_mBufferCnt'];
        varname              = [q.sim_def_var_out(ii).varname,'_',q.sim_def_var_out(ii).vecnames{j}];
        varname_Counter      = [q.sim_def_var_out(ii).varname,'_mBufferCnt'];
        varformat            = q.sim_def_var_out(ii).varformat{j};
        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_out(ii).varunit{j} ...
                                                          ,q.sim_def_var_out(ii).unit{j});
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_out(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end
        
        tt = '  ';
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,name);
        cinsert{ninsert+3} = sprintf('%s%s[%i].time.push_back(*ptime);' ...
                                    ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1));
        cinsert{ninsert+4} = sprintf('%s{' ...
                                    ,tt ...
                                    );
        cinsert{ninsert+5} = sprintf('%s  std::vector<double> vec;' ...
                                    ,tt ...
                                    );
        cinsert{ninsert+6} = sprintf('%s  size_t i;' ...
                                    ,tt ...
                                    );
        cinsert{ninsert+7} = sprintf('%s  for(i=0;i<%s;i++)' ...
                                    ,tt ...
                                    ,varname_Counter ...
                                    );
        cinsert{ninsert+8} = sprintf('%s  {' ...
                                    ,tt ...
                                    );
        if( nofacoffset )
          cinsert{ninsert+9} = sprintf('%s    vec.push_back(%s[i]);' ...
                                      ,tt ...
                                      ,varname ...
                                      );
        else
          cinsert{ninsert+9} = sprintf('%s    vec.push_back(%s[i]*%f+%f);' ...
                                      ,tt ...
                                      ,varname ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        cinsert{ninsert+10} = sprintf('%s  }' ...
                                    ,tt ...
                                    );
    
    
        cinsert{ninsert+11} = sprintf('%s  %s[%i].vecvec.push_back(vec);' ...
                                    ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1) ...
                                    );
        cinsert{ninsert+12} = sprintf('%s}' ...
                                    ,tt ...
                                    );
        cinsert{ninsert+13} = sprintf('%s%s[%i].comment = "%s";' ...
                                    ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1) ...
                                    ,q.sim_def_var_out(ii).comment);
        cinsert{ninsert+14} = sprintf('%s%s[%i].isvecofvec = 1;' ...
                                    ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1));
        ninsert            = ninsert+14;  
      end
      i = i + 1;
      tt = '  ';
      cinsert{ninsert+1} = '';
      cinsert{ninsert+2} = sprintf('%s/* %s */',tt,name_Counter);
      cinsert{ninsert+3} = sprintf('%s%s[%i].time.push_back(*ptime);' ...
                                  ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1));
      cinsert{ninsert+4} = sprintf('%s%s[%i].vec.push_back(%s*%f+%f);' ...
                                  ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1) ...
                                  ,varname_Counter ...
                                  ,1.0, 0.0 ...
                                  );
      cinsert{ninsert+5} = sprintf('%s%s[%i].comment = "%s";' ...
                                  ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1) ...
                                  ,q.sim_def_var_out(ii).comment);
      cinsert{ninsert+6} = sprintf('%s%s[%i].isvecofvec = 0;' ...
                                  ,tt,q.SIM_KENNUNG_SIM_STRUCT_OUT_VAR,(i-1));
      ninsert            = ninsert+6;                    
 
          
    else
        error('%s_errror: type=%s ist nicht bekannt',q.sim_def_var_out(ii).type);
    end

  end

end
function [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_parameter_const(q,cinsert,ninsert)

  cflag = 0;
  for ii=1:length(q.sim_def_var_par)
    if(  strcmp(q.sim_def_var_par(ii).type,'perm') ...
      || strcmp(q.sim_def_var_par(ii).type,'cperm') ...
      ) 
      cflag = 1;
      break;
    end
  end
  if( cflag )
    i = 0;
    tt = '  ';
    cinsert{ninsert+1} = [tt,'{'];
    tt = '    ';
    cinsert{ninsert+2} = [tt,'double *pdval;'];
    ninsert            = ninsert+2;
    
    for ii=1:length(q.sim_def_var_par)
      i = i+1;
      if( strcmp(q.sim_def_var_par(ii).type,'perm') )

        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_par(ii).varunit ...
                                                          ,q.sim_def_var_par(ii).unit);
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_par(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_par(ii).name);
        cinsert{ninsert+3} = sprintf('%sif( %s[%i].iAct < %s[%i].n )' ...
                                    ,tt ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+4} = sprintf('%s{',tt);

        cinsert{ninsert+5} = sprintf('%sif( (*ptime >= %s[%i].time[%s[%i].iAct]) )' ...
                                    ,[tt,'  '] ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+6} = sprintf('%s{',[tt,'  ']);
        if( nofacoffset )
          cinsert{ninsert+7} = sprintf('%s%s = (%s)(%s[%i].vec[%s[%i].iAct]);' ...
                                      ,[tt,'    '] ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                      ,(i-1) ...
                                      ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                      ,(i-1) ...
                                      );
        else
          cinsert{ninsert+7} = sprintf('%s%s = (%s)(%s[%i].vec[%s[%i].iAct] * %f + %f);' ...
                                      ,[tt,'    '] ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                      ,(i-1) ...
                                      ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                      ,(i-1) ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        cinsert{ninsert+8} = sprintf('%s++(%s[%i].iAct);' ...
                                    ,[tt,'    '] ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+9}  = sprintf('%s}',[tt,'  ']);
        cinsert{ninsert+10} = sprintf('%s}',tt);
        ninsert             = ninsert+10;
        
      elseif( strcmp(q.sim_def_var_par(ii).type,'cperm') )

        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_par(ii).varunit ...
                                                          ,q.sim_def_var_par(ii).unit);
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_par(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_par(ii).name);
        if( nofacoffset )
          cinsert{ninsert+3} = sprintf('%s%s = (%s)(%s);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.sim_def_var_par(ii).varval ...
                                      );
        else
          cinsert{ninsert+3} = sprintf('%s%s = (%s)(%s * %f + %f);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.sim_def_var_par(ii).varval ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        ninsert            = ninsert+3;        
      end

    end
    tt = '  ';
    cinsert{ninsert+1} = [tt,'}'];
    ninsert            = ninsert+1;
  end
end
function [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_parameter_loop(q,cinsert,ninsert)

  sflag = 0;
  for ii=1:length(q.sim_def_var_par)
    if( strcmp(q.sim_def_var_par(ii).type,'single') )
      sflag = 1;
      break;
    end
  end
  if( sflag )
    i = 0;
    tt = '  ';
    cinsert{ninsert+1} = [tt,'{'];
    tt = '    ';
    cinsert{ninsert+2} = [tt,'double *pdval;'];
    cinsert{ninsert+3} = [tt,''];

    ninsert            = ninsert+3;
    for ii=1:length(q.sim_def_var_par)
      i = i+1;
      if( strcmp(q.sim_def_var_par(ii).type,'single') )
        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_par(ii).varunit ...
                                                          ,q.sim_def_var_par(ii).unit);
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_par(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_par(ii).name);
        cinsert{ninsert+3} = sprintf('%sif( (*ptime >= %s[%i].time[%s[%i].iAct]) && (%s[%i].iAct < %s[%i].n) )' ...
                                    ,tt ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+4} = sprintf('%s{',tt);
        if( nofacoffset )
          cinsert{ninsert+5} = sprintf('%s%s = (%s)(%s[%i].vec[%s[%i].iAct]);' ...
                                      ,[tt,'  '] ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                      ,(i-1) ...
                                      ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                      ,(i-1) ...
                                      );
        else
          cinsert{ninsert+5} = sprintf('%s%s = (%s)(%s[%i].vec[%s[%i].iAct] * %f + %f);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                      ,(i-1) ...
                                      ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                      ,(i-1) ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        cinsert{ninsert+6} = sprintf('%sif( %s[%i].iAct < %s[%i].n ) ++(%s[%i].iAct);' ...
                                    ,[tt,'  '] ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    );
        cinsert{ninsert+7} = sprintf('%s}',tt);
        ninsert            = ninsert+7;
      end

    end
    tt = '  ';
    cinsert{ninsert+1} = [tt,'}'];
    ninsert            = ninsert+1;
  end
end
function [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_parameter_init0(q,cinsert,ninsert)

  flag = 0;
  for ii=1:length(q.sim_def_var_par)
    if(  strcmp(q.sim_def_var_par(ii).type,'init0') ...
      || strcmp(q.sim_def_var_par(ii).type,'cinit0') ...
      )
      flag = 1;
      break;
    end
  end
  if( flag )
    i = 0;
    tt = '  ';
    cinsert{ninsert+1} = [tt,'{'];
    tt = '    ';
    cinsert{ninsert+2} = [tt,'double *pdval;'];  

    ninsert            = ninsert+2;
    for ii=1:length(q.sim_def_var_par)
      i = i+1;
      if( strcmp(q.sim_def_var_par(ii).type,'init0') )

        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_par(ii).varunit ...
                                                          ,q.sim_def_var_par(ii).unit);
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_par(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_par(ii).name);
        cinsert{ninsert+3} = sprintf('%spdval = %s[%i].pvec[0];' ...
                                    ,tt ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    );
        if( nofacoffset )
          cinsert{ninsert+4} = sprintf('%s%s = (%s)(pdval[0]);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      );
        else
          cinsert{ninsert+4} = sprintf('%s%s = (%s)(pdval[0] * %f + %f);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        ninsert            = ninsert+4;
      elseif( strcmp(q.sim_def_var_par(ii).type,'cinit0') )

        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_par(ii).varunit ...
                                                          ,q.sim_def_var_par(ii).unit);
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_par(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_par(ii).name);
        if( nofacoffset )
          cinsert{ninsert+3} = sprintf('%s%s = (%s)(%s);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.sim_def_var_par(ii).varval ...
                                      );
        else
          cinsert{ninsert+3} = sprintf('%s%s = (%s)(%s * %f + %f);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.sim_def_var_par(ii).varval ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        ninsert            = ninsert+3;
      end

    end
    tt = '  ';
    cinsert{ninsert+1} = [tt,'}'];
    ninsert            = ninsert+1;
  end
end
function [cinsert,ninsert] = build_vcproj_for_mex_sim_io_build_sim_file_parameter_init1(q,cinsert,ninsert)

  flag = 0;
  for ii=1:length(q.sim_def_var_par)
    if(  strcmp(q.sim_def_var_par(ii).type,'init1') ...
      || strcmp(q.sim_def_var_par(ii).type,'cinit1') ...
      ) 
      flag = 1;
      break;
    end
  end
  if( flag )
    i = 0;
    tt = '  ';
    cinsert{ninsert+1} = [tt,'{'];
    tt = '    ';
    cinsert{ninsert+2} = [tt,'double *pdval;'];  

    ninsert            = ninsert+2;
    for ii=1:length(q.sim_def_var_par)
      i = i+1;
      if( strcmp(q.sim_def_var_par(ii).type,'init1') )

        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_par(ii).varunit ...
                                                          ,q.sim_def_var_par(ii).unit);
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_par(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_par(ii).name);
        cinsert{ninsert+3} = sprintf('%spdval = %s[%i].pvec[0];' ...
                                    ,tt ...
                                    ,q.SIM_KENNUNG_SIM_STRUCT_PAR_VAR ...
                                    ,(i-1) ...
                                    );
        if( nofacoffset )
          cinsert{ninsert+4} = sprintf('%s%s = (%s)(pdval[0]);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      );
        else
          cinsert{ninsert+4} = sprintf('%s%s = (%s)(pdval[0] * %f + %f);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        ninsert            = ninsert+4;
      elseif( strcmp(q.sim_def_var_par(ii).type,'cinit1') )

        [fac,offset,errtext] = get_unit_convert_fac_offset(q.sim_def_var_par(ii).varunit ...
                                                          ,q.sim_def_var_par(ii).unit);
        if( ~isempty(errtext) )
          error('%s: %s',q.sim_def_var_par(ii).name,errtext);
        end
        if( (abs(fac-1.0) < eps) && (abs(offset-0.0) < eps) )
          nofacoffset = 1;
        else
          nofacoffset = 0;
        end
        cinsert{ninsert+1} = '';
        cinsert{ninsert+2} = sprintf('%s/* %s */',tt,q.sim_def_var_par(ii).name);
        if( nofacoffset )
          cinsert{ninsert+3} = sprintf('%s%s = (%s)(%s);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.sim_def_var_par(ii).varval ...
                                      );
        else
          cinsert{ninsert+3} = sprintf('%s%s = (%s)(%s * %f + %f);' ...
                                      ,tt ...
                                      ,q.sim_def_var_par(ii).varname ...
                                      ,q.sim_def_var_par(ii).varformat ...
                                      ,q.sim_def_var_par(ii).varval ...
                                      ,fac ...
                                      ,offset ...
                                      );
        end
        ninsert            = ninsert+3;

      end

    end
    tt = '  ';
    cinsert{ninsert+1} = [tt,'}'];
    ninsert            = ninsert+1;
  end

end
function [c,i0] = Kennung_bereinigen(c,KENN_START,KENN_END,errflag)

  iliste0 = cell_find_f(c,KENN_START,'n');
  iliste1 = cell_find_f(c,KENN_END,'n');
  
  if( errflag && isempty(iliste0) )
    error('%s_error: Die Kennung <%s> konnte nicht gefunden werden',mfilename,KENN_START);
  end
  if( errflag && isempty(iliste1) )
    error('%s_error: Die Kennung <%s> konnte nicht gefunden werden',mfilename,KENN_END);
  end
  
  if( ~isempty(iliste0) && ~isempty(iliste1) )
    i0 = iliste0(1)+1;
    i1 = iliste1(1)-1;
    if( i1 >= i0 )
      c  = cell_delete(c,i0,i1);
    end
  elseif( ~isempty(iliste0) && isempty(iliste1) )
    i0 = iliste0(1)+1;
    c  = cell_insert(c,i0,KENN_END);
  elseif( isempty(iliste0) && ~isempty(iliste1) )
    i0 = iliste1(1)-1;
    c  = cell_insert(c,i0,KENN_START);
    i0 = i0+1;
  else
    i0 = 1;
    c  = cell_insert(c,i0,KENN_START);
    c  = cell_insert(c,i0+1,KENN_END);
    i0 = 2;
  end
end
