function [okay,errtext] = convert_rtas_modul_in_vpu_code(q)
%
% [okay,errtext] = convert_rtas_modul_in_vpu_code(q)
%
% Konvertiert ein rtas Modul, das in der vpu mit 
% /* #sswrtas: n: ssw_name_init, f: init */
% /* #sswrtas: n: ssw_name_loop, f: loop */
%
% 
%
% input                   type    default   description                     example
% q.vpu_dir               char    no        project path of VPU-Environment example:'D:\VPU_HAF\VPU_HAF1_RTAS'
%
% q.rtas_dir              char    no       rtas-directory                  example:'d:\APU_rtas\rtas'
%                                          wenn q.rtas_dir benutzt, dann
%                                          sin das Verzeichnis mod und app
%                                          im gleichen Verzeichnis
%
% q.rtas_mod_dir          char    no       Wenn das rtas-Verzeichnis mod
% q.rtas_app_dir          char    no       und app an verschiedenen Stellen liegen, 
%                                          sollten q.rtas_mod_dir und
%                                          q.rtas_app_dir benutzt werden 
%                                          (jeweils das directory über mod bzw. app)
%
%                                           RTAS Application type selction:
% q.rtas_ssw_platform     char    no       RTAS-SSW-Platform bisher nur vpu default: 'vpu-cg';
% q.rtas_ssw_type_name    char    no       RTAS-SSW-type name               default: 'default';
% q.rtas_ssw_config_name  char    no       RTAS-SSW-configuration-name      default: '' => no RTAS-include 
%                                                                            (example: 'had')
% q.rtas_project_name     char    no       RTAS PAM "Project name"
%                                          (project-Application-Manager)
%
% q.vc_version            char    no       bisher nur 'VC9' möglich
%
% q.build                 num     no       1:  Rtas-Schnittstelle auflösen
%                                              und mit Code füllen
%                                          2:  Rtas-Schnittstelle ergzeugen
%==========================================================================
% 
%==========================================================================
  okay    = 1;
  errtext = '';
  %==========================================================================
  % interne Felder
  %==========================================================================
  q.source_files      = {};
  q.include_dirs      = {};
  q.KENNINITSTART     = '#RTAS_CODE_INIT_START#';
  q.KENNINITEND       = '#RTAS_CODE_INIT_END#';
  q.KENNLOOPSTART     = '#RTAS_CODE_LOOP_START#';
  q.KENNDONEEND       = '#RTAS_CODE_LOOP_END#';
  q.KENNDONESTART     = '#RTAS_CODE_DONE_START#';
  q.KENNLOOPEND       = '#RTAS_CODE_DONE_END#';
  q.KENNINCLUDESTART  = '#INCLUDE_START#';
  q.KENNINCLUDEEND    = '#INCLUDE_END#';

  %==========================================================================
  % check input
  %==========================================================================
  
  %==========================================================================
  % VPU-Dir
  %----------------
  if( ~check_val_in_struct(q,'vpu_dir','char',1) )
    error('input q.vpu_dir nicht gesetzt (see help %s)',mfilename);
  end
  if( ~exist(q.vpu_dir,'dir') )
    error('%s: input q.vpu_dir=''%s'' wrong (see help %s)',mfilename,q.vpu_dir);
  end
  
  %==========================================================================
  % RTAS-dir
  %-------------------------------------------------------------------
  if( ~check_val_in_struct(q,'rtas_dir','char',1) )
    q.rtas_dir = '';
  end

  if( ~check_val_in_struct(q,'rtas_mod_dir','char',1) )
    q.rtas_mod_dir = q.rtas_dir;
  end

  if( ~check_val_in_struct(q,'rtas_app_dir','char',1) )
    q.rtas_app_dir = q.rtas_dir;
  end

  if( ~isempty(q.rtas_mod_dir) && ~exist(q.rtas_mod_dir,'dir') )
    error('RTAS-mod-Verzeichnis q.rtas_mod_dir = %s existiert nicht',q.rtas_mod_dir);
  end
  if( ~isempty(q.rtas_app_dir) && ~exist(q.rtas_app_dir,'dir') )
    error('RTAS-app-Verzeichnis q.rtas_app_dir = %s existiert nicht',q.rtas_app_dir);
  end
    
  % RTAS-SSW environment
  %-------------------------------------------------------------------
  % q.rtas_ssw_platform     char    yes       RTAS-SSW-Platform bisher nur vpu defaut:'vpu-cg';
  if( ~check_val_in_struct(q,'rtas_ssw_platform','char',1) )
    q.rtas_ssw_platform = 'vpu-cg';
  end
  % q.rtas_ssw_type_name    char    yes       RTAS-SSW-type name               default:'default';
  if( ~check_val_in_struct(q,'rtas_ssw_type_name','char',1) )
    q.rtas_ssw_type_name = 'default';
  end
  % q.rtas_ssw_config_name  char    no       RTAS-SSW-configuration-name      default: '' => no RTAS-include 
  if( ~check_val_in_struct(q,'rtas_ssw_config_name','char',1) )
    error('%s: q.rtas_ssw_config_name = ''abc'' muss angebene werden',mfilename);
  end
  % q.rtas_project_name     char    no       RTAS PAM "Project name"
  %                                          (project-Application-Manager)
  if( ~check_val_in_struct(q,'rtas_project_name','char',1) )
    error('%s: q.rtas_project_name = ''def'' muss angebene werden',mfilename);
  end
  
  % q.rtas_modul
  if( ~check_val_in_struct(q,'rtas_modul','cell',1) )
    error('%s: q.rtas_modul = {''modul_name'',...} muss angebenen werden',mfilename);
  end
  
  %-------------------------------------------------------------------
  % build-Anwesiung
  %-------------------------------------------------------------------
  if( ~check_val_in_struct(q,'build','num',1) )
    error('input q.build nicht gesetzt (see help %s)',mfilename);
  end
  
  
  %==========================================================================
  % RTAS-SSW und RTAS-Module vorbereiten und in source-liste eintragen
  %-------------------------------------------------------------------
  % q.rtas_ssw_platform     char    yes       RTAS-SSW-Platform bisher nur vpu defaut:'vpu-cg';
  % q.rtas_ssw_type_name    char    yes       RTAS-SSW-type name               default:'default';
  % q.rtas_ssw_config_name  char    no        RTAS-SSW-configuration-name      example 'had'

  q = build_vcproj_for_mex_Simulation_rtas_ssw(q);
  
  if( q.build == 1 )
    fprintf('%s\n','Wandele rtas-Implementierung in C-Code um');
    q = convert_rtas_modul_in_vpu_code_conv_rtas_to_source(q);
  else
    q = convert_rtas_modul_in_vpu_code_conv_source_to_rtas(q);
    fprintf('%s\n','Wandele C-Code in rtas-Implementierung um');
  end
  
  %========================================================================
  % Ende
  %-------------------------------
  
end

function q = convert_rtas_modul_in_vpu_code_conv_rtas_to_source(q)

  % Check all rtas entries:
  i_ssw_vpu_collect =  [];
  for i = 1:length(q.ssw_vpu)
    
    % Modul finden 
    irtas = convert_rtas_modul_in_vpu_find_rtas_mod(q.ssw_vpu(i),q.rtas_mod);
    
    ifound1 = cell_find_f(q.rtas_ssw_name,q.rtas_mod(irtas).name,'f');
    ifound2 = cell_find_f(q.rtas_modul,q.rtas_mod(irtas).mod_name,'f');

    if( ~isempty(ifound1) && ~isempty(ifound2) )
      
      % Source-File einlesen
      [ okay,c,n ] = read_ascii_file(q.ssw_vpu(i).srcname);
      if( ~okay )
        error('%s: Datei <%s> konnte nicht geöffnet werden',mfilename,q.ssw_vpu(i).srcname);
      end
    
    
      % RTAS-Aufruf raussuchen, wenn einer fehlt, wird mit error beendet
      % Wenn Schleife weiterläuft dann ist alles gut
      [c,i0] = convert_rtas_modul_in_vpu_find_sswrtas_call(q.ssw_vpu(i),c);
      
      i_ssw_vpu_collect = [i_ssw_vpu_collect;i];
    end
  end
  
  % Jetzt Umwandeln
  cbearbeited = {};
  for ic = 1:length(i_ssw_vpu_collect)
    
    i = i_ssw_vpu_collect(ic);
    
    % Modul finden 
    irtas = convert_rtas_modul_in_vpu_find_rtas_mod(q.ssw_vpu(i),q.rtas_mod);
    
    % Source-File einlesen
    [ okay,c,n ] = read_ascii_file(q.ssw_vpu(i).srcname);
    if( ~okay )
      error('%s: Datei <%s> konnte nicht geöffnet werden',mfilename,q.ssw_vpu(i).srcname);
    end
    
    % RTAS-Aufruf raussuchen
    [c,i0] = convert_rtas_modul_in_vpu_find_sswrtas_call(q.ssw_vpu(i),c);
    
    % RTAS-Aufruf löschen
    c      = cell_delete(c,i0);
  
    % Include für modul einfügen
    if( strcmpi(q.ssw_vpu(i).ftype,'loop') )
      [c,nzeilen] = convert_rtas_modul_in_vpu_insert_include(q.rtas_mod(irtas) ...
                                                            ,c ...
                                                            ,q.KENNINCLUDESTART,q.KENNINCLUDEEND);
      i0     = i0 + nzeilen;
    end    
    % den vollständigne Funktionsuafruf einfügen
    c      = convert_rtas_modul_in_vpu_insert_function_call(q.ssw_vpu(i) ...
                                                           ,q.rtas_mod(irtas) ...
                                                           ,c,i0 ...
                                                           ,q.KENNINITSTART,q.KENNINITEND ...
                                                           ,q.KENNLOOPSTART,q.KENNLOOPEND ...
                                                           ,q.KENNDONESTART,q.KENNDONEEND ...
                                                           ,q.rtas_app_src_frame_dir);
    
    % Surce File schreiben
    okay = write_ascii_file(q.ssw_vpu(i).srcname,c);
    if( ~okay )
      error('%s: Datei <%s> konnte nicht geschrieben werden',mfilename,q.ssw_vpu(i).srcname);
    end
    
    % c- und h- Files des rtas-Moduls kopieren
    %=========================================
    % passendes Modul-Files suchen
    [q.source_files,cbearbeited] = convert_rtas_modul_in_vpu_copy_modulfiles(q.ssw_vpu(i),q.rtas_mod(irtas),cbearbeited,q.source_files,q.build);
  end
end
%
% 
%
function q = convert_rtas_modul_in_vpu_code_conv_source_to_rtas(q)

  cbearbeited        = {};
  cbearbeited_build3 = {};

  % Check all rtas entries:
  for i = 1:length(q.ssw_vpu)
    
    % Modul finden 
    irtas = convert_rtas_modul_in_vpu_find_rtas_mod(q.ssw_vpu(i),q.rtas_mod);
    
    ifound1 = cell_find_f(q.rtas_ssw_name,q.rtas_mod(irtas).name,'f');
    ifound2 = cell_find_f(q.rtas_modul,q.rtas_mod(irtas).mod_name,'f');

    if( ~isempty(ifound1) && ~isempty(ifound2) )
      
      % Source-File einlesen
      [ okay,c,n ] = read_ascii_file(q.ssw_vpu(i).srcname);
      if( ~okay )
        error('%s: Datei <%s> konnte nicht geöffnet werden',mfilename,q.ssw_vpu(i).srcname);
      end

      % Source-Code-Aufruf raussuchen, wenn einer fehlt, wird mit error beendet
      % Wenn Schleife weiterläuft dann ist alles gut
      [sloesch] = convert_rtas_modul_in_vpu_find_source(q.ssw_vpu(i),c ...
                                                       ,q.KENNINCLUDESTART,q.KENNINCLUDEEND ...
                                                       ,q.KENNINITSTART,q.KENNINITEND ...
                                                       ,q.KENNLOOPSTART,q.KENNLOOPEND ...
                                                       ,q.KENNDONESTART,q.KENNDONEEND ...
                                                       );
      if( isempty(sloesch) )
        error('%s: In Datei: <%s> konnte  für rtas-Modul ''%s'' kein ModulCode gefunden',mfilename,q.ssw_vpu(i).srcname,q.ssw_vpu(i).locname)
      end
    
      c = convert_rtas_modul_in_vpu_replace_source_with_rtas_description(q.ssw_vpu(i),c,sloesch);

      % Source File schreiben
      okay = write_ascii_file(q.ssw_vpu(i).srcname,c);
      if( ~okay )
        error('%s: Datei <%s> konnte nicht geschrieben werden',mfilename,q.ssw_vpu(i).srcname);
      end

      if( q.build == 3 ) 
        % c- und h- Files des rtas-Moduls kopieren
        %=========================================
        % passendes Modul-Files suchen
        [q.source_files,cbearbeited_build3] = convert_rtas_modul_in_vpu_copy_modulfiles(q.ssw_vpu(i),q.rtas_mod(irtas),cbearbeited_build3,q.source_files,q.build);
      end
      % c- und h- Files des rtas-Moduls weglöschen
      %===========================================
      % passendes Modul-Files suchen
      convert_rtas_modul_in_vpu_delete_modulfiles(q.ssw_vpu(i),q.rtas_mod(irtas),cbearbeited,q.source_files);
    end
  end
  
end
%
%--------------------------------------------------------------------------
%
function  irtas = convert_rtas_modul_in_vpu_find_rtas_mod(ssw_vpu,rtas_mod)
%
% Modulnamen in Liste finden
%
    modul_names = ssw_vpu.rmodul_names;
    modul_names = str_cut_a_f(modul_names,'[');
    modul_names = str_cut_e_f(modul_names,']');
    modul_names = str_cut_ae_f(modul_names,' ');
    
    [cmodul,n] = str_split(modul_names,',');
    flag = 1;
    for i=1:n
      
      for j=1:length(rtas_mod)
        if( strcmpi(rtas_mod(j).name,cmodul{i}) )
          flag = 0;
          irtas = j;
          break;
        end
      end
      if( flag == 0 )
        break;
      end
    end
    if( flag )
      error('%s: Aus ssw_vpu.locname = ''%s'' konnte ssw_vpu.rmodul_names = ''%s''  nicht in rtas_mod gefunden werden',mfilename,ssw_vpu.locname,ssw_vpu.rmodul_names)
    end
end
function [c,i0] = convert_rtas_modul_in_vpu_find_sswrtas_call(ssw_vpu,c)

    [ifound,ipos] = cell_find_f(c,'#sswrtas','nl');
    if( isempty(ifound) )
      error('%s: ''#sswrtas'' konnte nicht in File <%s> gefunden werden',mfilename,ssw_vpu.srcname);
    end
    flag = 1;
    for i=1:length(ifound)
      i0 = ifound(i);
      if( str_find_f(c{i0},ssw_vpu.locname,'vs') > 0 )
        flag = 0;
        break;
      end
    end
    if( flag )
      error('%s: ''#sswrtas'' und ''%s'' konnte nicht in File <%s> gefunden werden',mfilename,ssw_vpu.locname,ssw_vpu.srcname);
    end
end
function [c,nzeilen] = convert_rtas_modul_in_vpu_insert_include(rtas_mod,c,KENNSTART,KENNEND)

  nzeilen = 0;
  
  % Start Kommentar suchen
  [ifound,ipos] = cell_find_f(c,KENNSTART,'nl');
  if( isempty(ifound) ) % Noch keinen Include-Kommentar vorhanden
    % Kommentarstart
    c = cell_insert(c,1,sprintf('/* %s */',KENNSTART));
    nzeilen = nzeilen + 1;
    
    % Include
    i0 = 2;
    [c,i0] = convert_rtas_modul_in_vpu_insert_include_rtas_mod(rtas_mod,c,i0);
    nzeilen = nzeilen + (i0-2);
    
    % Kommentarend
    c = cell_insert(c,i0,sprintf('/* %s */',KENNEND));
    nzeilen = nzeilen + 1;
  else % Kommentar vorhanden
    i0 = ifound(1)+1;

    % Include
    [c,i1] = convert_rtas_modul_in_vpu_insert_include_rtas_mod(rtas_mod,c,i0);
    nzeilen = nzeilen + (i1-i0);
  end
end
function c = convert_rtas_modul_in_vpu_insert_function_call(ssw_vpu,rtas_mod,c,i0 ...
                                                           ,KENNINITSTART,KENNINITEND,KENNLOOPSTART,KENNLOOPEND,KENNDONESTART,KENNDONEEND ...
                                                           ,rtas_app_src_frame_dir)

  % Start Kopmmmentar einfügen
  if( strcmpi(ssw_vpu.ftype,'init') )
    c = cell_insert(c,i0,sprintf('  /* %s %s */',KENNINITSTART,ssw_vpu.locname));
    i0 = i0 + 1;
    [c,i0] = convert_rtas_modul_in_vpu_insert_function(1,ssw_vpu,rtas_mod,c,i0,rtas_app_src_frame_dir);
    % End Kopmmmentar einfügen
    c = cell_insert(c,i0,sprintf('  /* %s %s */',KENNINITEND,ssw_vpu.locname));
  elseif( strcmpi(ssw_vpu.ftype,'loop') )
    c = cell_insert(c,i0,sprintf('  /* %s %s */',KENNLOOPSTART,ssw_vpu.locname));
    i0 = i0 + 1;
    [c,i0] = convert_rtas_modul_in_vpu_insert_function(2,ssw_vpu,rtas_mod,c,i0,rtas_app_src_frame_dir);
    % End Kopmmmentar einfügen
    c = cell_insert(c,i0,sprintf('  /* %s %s */',KENNLOOPEND,ssw_vpu.locname));
  elseif( strcmpi(ssw_vpu.ftype,'done') )
    c = cell_insert(c,i0,sprintf('  /* %s %s */',KENNDONESTART,ssw_vpu.locname));
    i0 = i0 + 1;
    [c,i0] = convert_rtas_modul_in_vpu_insert_function(3,ssw_vpu,rtas_mod,c,i0,rtas_app_src_frame_dir);
    % End Kopmmmentar einfügen
    c = cell_insert(c,i0,sprintf('  /* %s %s */',KENNDONEEND,ssw_vpu.locname));
  else
    error('%s:ssw_vpu.ftype = ''%s'' nicht programmiert',mfilename,ssw_vpu.ftype)
  end
    

end
function [c,i0] = convert_rtas_modul_in_vpu_insert_include_rtas_mod(rtas_mod,c,i0)

  pvf_file = fullfile(rtas_mod.mod_dir,'mod',rtas_mod.mod_name,'src\frames\rtas',[rtas_mod.mod_name,'.pvf']);
  [ okay,cpvf,npvf ] = read_ascii_file(pvf_file);
  if( ~okay )
    error('%s: Datei <%s> konnte nicht geöffnet werden',mfilename,pvf_file);
  end
      
  [ifound,ipos] = cell_find_f(cpvf,'DEFINITION_PARAMETER_UND_VARIABLEN','nl');
  if( isempty(ifound) )
    error('%s: DEFINITION_PARAMETER_UND_VARIABLEN konnte nicht in der Datei <%s> gefunden werden',mfilename,pvf_file);
  end
  
  % Include eintragen
  include_call = cpvf{ifound+1};
  c = cell_insert(c,i0,sprintf('%s',include_call));
  i0 = i0 + 1;
end
function [c,i0] = convert_rtas_modul_in_vpu_insert_function(type,ssw_vpu,rtas_mod,c,i0,rtas_app_src_frame_dir)
  % type = 1 'init'
  %        2 'loop'
  %        3 'done'
  pvf_file = fullfile(rtas_mod.mod_dir,'mod',rtas_mod.mod_name,'src\frames\rtas',[rtas_mod.mod_name,'.pvf']);
  [ okay,cpvf,npvf ] = read_ascii_file(pvf_file);
  if( ~okay )
    error('%s: Datei <%s> konnte nicht geöffnet werden',mfilename,pvf_file);
  end
  
  if( type ==  1 ) % init
    
    [ifound,ipos] = cell_find_f(cpvf,'INIT_FUNKTION','nl');
    if( isempty(ifound) )
      error('%s: INIT_FUNKTION konnte nicht in der Datei <%s> gefunden werden',mfilename,pvf_file);
    end
  
    % Funktionsaufruf eintragen
    func_call = cpvf{ifound+1};
    c = cell_insert(c,i0,sprintf('  %s;',func_call));
    i0 = i0 + 1;
  elseif( type ==  2 ) % loop
    
    % Input eintragen
    %----------------
    imap_file = fullfile(rtas_app_src_frame_dir,rtas_mod.name,'imap.c');
    
    if( exist(imap_file,'file') )
      c1 = convert_rtas_modul_in_vpu_get_map_file(imap_file);
    else
      warning('Es wurde keine imap-Datei <%s> gefunden',imap_file);
    end
    
    for ii=1:length(c1)
      c  = cell_insert(c,i0,sprintf('  %s',c1{ii}));
      i0 = i0 + 1;
    end
    
    %  Funktionsaufruf eintragen
    %---------------------------
    [ifound,ipos] = cell_find_f(cpvf,'LOOP_FUNKTION','nl');
    if( isempty(ifound) )
      error('%s: LOOP_FUNKTION konnte nicht in der Datei <%s> gefunden werden',mfilename,pvf_file);
    end
  
    func_call = cpvf{ifound+1};
    c = cell_insert(c,i0,'');
    c = cell_insert(c,i0,sprintf('  %s;',func_call));
    c = cell_insert(c,i0,'');
    i0 = i0 + 3;

    % Ouput eintragen
    %-----------------
    omap_file = fullfile(rtas_app_src_frame_dir,rtas_mod.name,'omap.c');
    
    if( exist(imap_file,'file') )
      c1 = convert_rtas_modul_in_vpu_get_map_file(omap_file);
    else
      warning('Es wurde keine omap-Datei <%s> gefunden',omap_file);
    end
    
    for ii=1:length(c1)
      c  = cell_insert(c,i0,sprintf('  %s',c1{ii}));
      i0 = i0 + 1;
    end

  else  % done
    
    [ifound,ipos] = cell_find_f(cpvf,'DONE_FUNKTION','nl');
    if( isempty(ifound) )
      error('%s: DONE_FUNKTION konnte nicht in der Datei <%s> gefunden werden',mfilename,pvf_file);
    end
  
    % Funktionsaufruf eintragen
    func_call = cpvf{ifound+1};
    c = cell_insert(c,i0,sprintf('  %s;',func_call));
    i0 = i0 + 1;
  end
end
function c1 = convert_rtas_modul_in_vpu_get_map_file(map_file)

  [ okay,c1,n ] = read_ascii_file(map_file);
  if( ~okay )
    error('%s: Datei <%s> konnte nicht geöffnet werden',mfilename,map_file);
  end
  % Kommentar eleminieren
  [ifound,ipos] = cell_find_f(c1,'/*','nl');
  for i=1:length(ifound)
    i0  = ifound(i);
    ip0 = ipos(i);
    
    if( ip0 == 1 )
      [i1,ip1] = cell_find_from_ipos(c1,i0,ip0,'*/','for');
      if( (i1 > 0) && (ip1 > 0) )
        c1 = cell_delete(c1,i0,i1);
      end
    end
  end
end
%
%--------------------------------------------------------------------------
%
function [sloesch] = convert_rtas_modul_in_vpu_find_source(ssw_vpu,c ...
                                                        ,KENNINCLUDESTART,KENNINCLUDEEND ...
                                                        ,KENNINITSTART,KENNINITEND ...
                                                        ,KENNLOOPSTART,KENNLOOPEND ...
                                                        ,KENNDONESTART,KENNDONEEND ...
                                                        )
%
%   sloesch(i).name          Name 'include','init','loop','done'
%   sloesch(i).i0            erste Zeile
%   sloesch(i).i1            letzte Zeile
%
%   q.KENNSTART         = '#RTAS_CODE_START#';
%   q.KENNEND           = '#RTAS_CODE_END#';
%   q.KENNINCLUDESTART  = '#INCLUDE_START#';
%   q.KENNINCLUDEEND    = '#INCLUDE_END#';

  sloesch = [];
  if( strcmpi(ssw_vpu.ftype,'init') )
    t0 = KENNINITSTART;
    t1 = KENNINITEND;
    [ifound,ipos] = cell_find_f(c,t0,'nl');
    if( ~isempty(ifound) )
      for i=1:length(ifound)
        i0 = ifound(i);
        tt = c{i0};

        % suche Modul
        if( str_find_f(tt,ssw_vpu.locname,'vs') > 0 )        
          [jfound,jpos] = cell_find_from_ipos(c,i0,ipos(i),t1,'for');
          if( isempty(jfound) )
            error('%s: Zu dem Kommentaranfang: %s konnte das ende %s in Datei <%s> nicht gefunden werden' ...
                 ,mfilename,t0,t1,ssw_vpu.srcname);
          end
          i1 = jfound(1);
          if( isempty(sloesch) )
            sloesch.name = 'init';
            sloesch.i0   = i0;
            sloesch.i1   = i1;
          else
            n = length(sloesch);
            sloesch(n+1).name = 'init';
            sloesch(n+1).i0   = i0;
            sloesch(n+1).i1   = i1;
          end
        end
      end
    end
  elseif( strcmpi(ssw_vpu.ftype,'loop') )
    [ifound,ipos] = cell_find_f(c,KENNINCLUDESTART,'nl');
    if( ~isempty(ifound) )
      for i=1:length(ifound)
        i0 = ifound(i);
        [jfound,jpos] = cell_find_from_ipos(c,i0,ipos(i),KENNINCLUDEEND,'for');
        if( isempty(jfound) )
          error('%s: Zu dem Kommentaranfang: %s konnte das ende %s in Datei <%s> nicht gefunden werden' ...
               ,mfilename,KENNINCLUDESTART,KENNINCLUDEEND,ssw_vpu.srcname);
        end
        i1 = jfound(1);
        if( isempty(sloesch) )
          sloesch.name = 'include';
          sloesch.i0   = i0;
          sloesch.i1   = i1;
        else
          n = length(sloesch);
          sloesch(n+1).name = 'include';
          sloesch(n+1).i0   = i0;
          sloesch(n+1).i1   = i1;
        end
      end
    end
    t0 = KENNLOOPSTART;
    t1 = KENNLOOPEND;
    [ifound,ipos] = cell_find_f(c,t0,'nl');
    if( ~isempty(ifound) )
      for i=1:length(ifound)
        i0 = ifound(i);
        tt = c{i0};

        % suche Modul
        if( str_find_f(tt,ssw_vpu.locname,'vs') > 0 )        
          [jfound,jpos] = cell_find_from_ipos(c,i0,ipos(i),t1,'for');
          if( isempty(jfound) )
            error('%s: Zu dem Kommentaranfang: %s konnte das ende %s in Datei <%s> nicht gefunden werden' ...
                 ,mfilename,t0,t1,ssw_vpu.srcname);
          end
          i1 = jfound(1);
          if( isempty(sloesch) )
            sloesch.name = 'loop';
            sloesch.i0   = i0;
            sloesch.i1   = i1;
          else
            n = length(sloesch);
            sloesch(n+1).name = 'loop';
            sloesch(n+1).i0   = i0;
            sloesch(n+1).i1   = i1;
          end
        end
      end
    end
  else
    t0 = KENNDONESTART;
    t1 = KENNDONEEND;
    [ifound,ipos] = cell_find_f(c,t0,'nl');
    if( ~isempty(ifound) )
      for i=1:length(ifound)
        i0 = ifound(i);
        tt = c{i0};

        % suche Modul
        if( str_find_f(tt,ssw_vpu.locname,'vs') > 0 )        
          [jfound,jpos] = cell_find_from_ipos(c,i0,ipos(i),t1,'for');
          if( isempty(jfound) )
            error('%s: Zu dem Kommentaranfang: %s konnte das ende %s in Datei <%s> nicht gefunden werden' ...
                 ,mfilename,t0,t1,ssw_vpu.srcname);
          end
          i1 = jfound(1);
          if( isempty(sloesch) )
            sloesch.name = 'loop';
            sloesch.i0   = i0;
            sloesch.i1   = i1;
          else
            n = length(sloesch);
            sloesch(n+1).name = 'loop';
            sloesch(n+1).i0   = i0;
            sloesch(n+1).i1   = i1;
          end
        end
      end
    end
  end
end
function c = convert_rtas_modul_in_vpu_replace_source_with_rtas_description(ssw_vpu,c,sloesch)
%
% Rauslöschen des c-codes in source c{i} mit sloesch(j).name,
% sloesch(j).i0,sloesch(j).i1 und ersetzen mit Kommentar für Rtas
%
  KENNUNG = '#*#*#*#*++++#*#*#*++++#*#*#*#*#*#*#*++++#*#*#*++++#*#*#*';
  
  for i=1:length(sloesch)
    
    for j = sloesch(i).i0:sloesch(i).i1        
      c{j} = KENNUNG;
    end
    if( ~strcmp(sloesch(i).name,'include') )
      c{sloesch(i).i0} = sprintf('  %s',ssw_vpu.ssw_off);
    end
  end
  [ifound,ipos] = cell_find_f(c,KENNUNG);
  if( ~isempty(ifound) )
    c = cell_delete(c,ifound);
  end  
end    
function [source_files,cbearbeited] = convert_rtas_modul_in_vpu_copy_modulfiles(ssw_vpu,rtas_mod,cbearbeited,source_files,build)
  vpu_dir = fullfile_get_dir(ssw_vpu.srcname);

  ifound = cell_find_f(cbearbeited,rtas_mod.name,'fl');
  if( isempty(ifound) ) % nur wenn nicht gefunden
    cbearbeited = cell_add(cbearbeited,rtas_mod.name);

    j = 1;
    while(j<=length(source_files))

      src_file = source_files{j}{1};
      s        = str_get_pfe_f(src_file);
      name     = source_files{j}{2};

      source_files = convert_rtas_modul_in_vpu_suche_fehlende_h_files(s.dir,name,source_files);

      add_dir_name = convert_rtas_modul_in_vpu_add_dir_name(s.dir,rtas_mod.name,rtas_mod.mod_name);

      if( strcmpi(rtas_mod.name,name) )
        if( isempty(add_dir_name) )
          trg_dir = fullfile(vpu_dir,name);
        else
          trg_dir = fullfile(vpu_dir,name,add_dir_name);
        end
        if( build ~= 3 )
          if( ~exist(trg_dir,'dir') )
            [SUCCESS,MESSAGE,MESSAGEID] = mkdir(trg_dir);
            if( ~SUCCESS )
              error(MESSAGEID,MESSAGE);
            end
          end
        end

        trg_file = fullfile(trg_dir,[s.name,'.',s.ext]);
        if( build == 3 ) %zurückkopieren
          [okay,message] = copy_file_if_newer(trg_file,src_file);
        else
          [okay,message] = copy_file_if_newer(src_file,trg_file);
        end
        if( ~okay )
          error('%s: %s',mfilename,message);
        elseif( ~isempty(message) )
          fprintf('%s: %s\n',mfilename,message);
        end
      end
      j = j+1;
    end
  end
end
function add_dir_name = convert_rtas_modul_in_vpu_add_dir_name(sdir,rtas_mod_name1,rtas_mod_name2)
%
% Es wird der letzte Verzeichnisname in der Kette extrahiert und
% weitergeben, wenn nicht einer der unten aufgeführten Namen hat
  add_dir_name = ''; 
  tt = str_change_f(sdir,'\','/');
  if( str_find_f(tt,'/') > 0 )
    cc           = cell_delete_if_empty(str_split(tt,'/'));
    n = length(cc);
    if( n )
      name = cc{n};
      ifound = cell_find_f({'src','files','frames',rtas_mod_name1,rtas_mod_name2},name,'fl');
      if( isempty(ifound) ) % nur wenn nicht gefunden
        add_dir_name = name;
      end
    end
  end
end
function source_files = convert_rtas_modul_in_vpu_suche_fehlende_h_files(sdir,sname,source_files)

% Suche h-Files
  [file_list,file_list_len] = suche_files_f(sdir,'*.h;*.he',0,0);
  
  for i=1:file_list_len
    j0 = search_in_source_files(source_files,file_list(i).full_name);
    if( j0 == 0 )
      source_files = cell_add(source_files,{{file_list(i).full_name,sname}});
    end
  end
end
function j0 = search_in_source_files(source_files,filename)
  j0   = 0;
  for j=1:length(source_files)
    i0 = str_find_f(source_files{j}{1},filename);
    if( i0 > 0 )
      j0   = j;
      break;
    end
  end
end
function convert_rtas_modul_in_vpu_delete_modulfiles(ssw_vpu,rtas_mod,cbearbeited,source_files)
  vpu_dir = fullfile_get_dir(ssw_vpu.srcname);

  ifound = cell_find_f(cbearbeited,rtas_mod.name,'fl');
  if( isempty(ifound) ) % nur wenn nicht gefunden
    cbearbeited = cell_add(cbearbeited,rtas_mod.name);

    j = 1;
    while(j<=length(source_files))

      src_file = source_files{j}{1};
      s        = str_get_pfe_f(src_file);
      name     = source_files{j}{2};
      
      add_dir_name = convert_rtas_modul_in_vpu_add_dir_name(s.dir,rtas_mod.name,rtas_mod.mod_name);

      if( strcmpi(rtas_mod.name,name) )
        if( isempty(add_dir_name) )
           trg_dir = fullfile(vpu_dir,name);
        else
           trg_dir = fullfile(vpu_dir,name,add_dir_name);
        end
        fprintf('%s: delete pass: %s \n',mfilename,trg_dir);
        if( exist(trg_dir,'dir') )
          [stat, mess]=rmdir(trg_dir,'s');
          if( ~stat )
            error('%s: %s',mfilename,mess);
          end
        end
      end
      j = j+1;
    end
  end

end
