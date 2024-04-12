function q = build_vcproj_for_mex_Simulation_rtas_ssw(q)
%
% q.rtas_build_source_for_vcproj = 1;      Wir benutzt, um ein Visual-C-Projekt für Simulation zu ergzeugen
% Input:
% q.rtas_ssw_platform     char    no       RTAS-SSW-Platform bisher nur vpu example: 'vpu-cg';
% q.rtas_ssw_type_name    char    no       RTAS-SSW-type name               example: 'default';
% q.rtas_ssw_config_name  char    no       RTAS-SSW-configuration-name      example: 'had'
% q.vpu_dir               char    no       project path of VPU-Environment example:'D:\VPU_HAF\VPU_HAF1_RTAS'
% q.proj_source_dir       char    no       path where to copy and modify interface-file to vpu 
% q.source_files          cell    no       source-files
% q.include_dirs          cell    no       include-dirs
% q.vc_version            char    no       bisher nur 'VC9' möglich
% Output:
% q.rtas_ssw_cfg_dir      char
% q.rtas_app_prj_dir      char
% q.rtas_app_src_frame_dir char
% q.ssw_vpu(n)            struct
% q.rtas_mod(n)           struct
% q.source_files          cell    no       source-files
% q.include_dirs          cell    no       include-dirs
%
%
  q.rtas_ssw_cfg_dir       = fullfile(q.rtas_projconf_dir,'.rtas_asap_ssw\cfg',q.rtas_ssw_type_name,q.rtas_ssw_config_name);
  q.rtas_app_prj_dir       = fullfile(q.rtas_app_dir,'app',q.rtas_ssw_platform,'prj',q.rtas_project_name);
  q.rtas_app_src_frame_dir = fullfile(q.rtas_app_prj_dir,'src\frame');
  
  if( ~exist(q.rtas_ssw_cfg_dir,'dir') )
    error('%s_err: q.rtas_ssw_cfg_dir <%s> konnte nicht gefudnen werden',mfilename,q.rtas_ssw_cfg_dir);
  end
  if( ~exist(q.rtas_app_prj_dir,'dir') )
    error('%s_err: q.rtas_app_prj_dir <%s> konnte nicht gefudnen werden',mfilename,q.rtas_app_prj_dir);
  end
  if( ~exist(q.rtas_app_src_frame_dir,'dir') )
    error('%s_err: q.rtas_app_src_frame_dir <%s> konnte nicht gefudnen werden',mfilename,q.rtas_app_src_frame_dir);
  end
  
  if( ~check_val_in_struct(q,'rtas_build_source_for_vcproj','num',1) )
    q.rtas_build_source_for_vcproj = 0;
  end
  if( ~check_val_in_struct(q,'source_files','cell') )
    q.source_files = {};
  end
  if( ~check_val_in_struct(q,'include_dirs','cell') )
    q.include_dirs = {};
  end

  % Source-Files auslassen not used
  q.rtas_not_source_files  = {'vclibexe_frame.c'};
  
  
  

  %=========================================================================
  % read infos of interface vpu-modules (ssw.rmll)
  %-------------------------------------------------------------------------
  % q.ssw_vpu(i).comment: 'n: iqf_ctrl_loop, f: loop'
  %          endpos: '45'
  %        filename: 'fct_lat_ctrl.c'
  %           ftype: 'loop'
  %         inc_cfg: 'iqf'
  %          inc_fn: 'd:\vpu2_vpu4\vpu4_cg_iqf_rtas\src\fct\lat\fct_lat_ctrl.c.325.inc'
  %   inc_statement: '#include "fct_lat_ctrl.c.325.inc"'
  %            line: '/* #sswrtas: n: iqf_ctrl_loop, f: loop */'
  %          lineno: '325'
  %           locid: 'd:\vpu2_vpu4\vpu4_cg_iqf_rtas\src\fct\lat\fct_lat_ctrl.c.325'
  %          lockey: 'iqf_ctrl_loop_loop'
  %         locname: 'iqf_ctrl_loop'
  %         loctype: 'iqf_ctrl_loop.loop'
  %            path: 'd:\vpu2_vpu4\vpu4_cg_iqf_rtas\src\fct\lat'
  %    rmodul_names: '[iqf]'
  %         srcname: 'd:\vpu2_vpu4\vpu4_cg_iqf_rtas\src\fct\lat\fct_lat_ctrl.c'
  %         ssw_off: '/* #sswrtas: n: iqf_ctrl_loop, f: loop */'
  %          ssw_on: '/* #sswrtas: n: iqf_ctrl_loop, f: loop */  #include "fct_lat_ctrl.c.325.inc"'
  %        ssw_type: '*id001'
  %            ydct: ':'
  %-------------------------------------------------------------------------
  [q.ssw_vpu,okay,errtext] = read_rtas_rmll_file(fullfile(q.rtas_ssw_cfg_dir,'ssw.rmll'));
  if( ~okay )
    error('%s_err: %s',mfilename,errtext);
  end
  
  %=========================================================================
  % read rtas-modules
  %-------------------------------------------------------------------------
  % q.rtas_mod(i).name
  % q.rtas_mod(i).mod_name             
  % q.rtas_mod(i).mod_dir  
  %-------------------------------------------------------------------------
  q.rtas_mod = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules_rml(q);

  if( q.rtas_build_source_for_vcproj )
        
    %=========================================================================
    % add function-call in source-file
    %-------------------------------------------------------------------------
    q = build_vcproj_for_mex_Simulation_rtas_ssw_interface_vpu(q);

    %=========================================================================
    % add frame-file
    %-----------------------------------------------
    q = build_vcproj_for_mex_Simulation_rtas_ssw_add_frame(q);


  end
  
  %=========================================================================
  % add modules ####
  %-----------------------------------------------
  q = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules(q);

end
function q = build_vcproj_for_mex_Simulation_rtas_ssw_interface_vpu(q)

  
  nssw_vpu = length(q.ssw_vpu);
  t_src_dir  = fullfile(q.proj_source_dir,q.rtas_ssw_config_name);
  s_src_file_liste = {};
  t_src_file_liste = {};
  for i = 1:nssw_vpu
  
    % Kopiere c-Files mit Interface und füge Interface ein
    modul_names = q.ssw_vpu(i).rmodul_names;
    modul_names = str_cut_a_f(modul_names,'[');
    modul_names = str_cut_e_f(modul_names,']');
    modul_names = str_cut_ae_f(modul_names,' ');
    % Modul vorhanden
    if( ~isempty(modul_names) )
      s_src_file = q.ssw_vpu(i).srcname;
      s_file     = str_get_pfe_f(s_src_file);
      t_src_file = fullfile(t_src_dir,[s_file.name,'.',s_file.ext]);
        
      if( ~exist(s_src_file,'file') )
        error('%s_err: s_src_file: <%s> konnte nicht gefunden werden .',mfilename,s_src_file);
      end
      if( ~exist(t_src_dir,'dir') )
        mkdir(t_src_dir);
      end
      [jcell,jpos] = cell_find_from_ipos(s_src_file_liste,1,1,s_src_file,'for');
      if( jcell == 0 ) % noch nicht vorhanden
        s_src_file_liste = cell_add(s_src_file_liste,s_src_file);
        t_src_file_liste = cell_add(t_src_file_liste,t_src_file);
        [ okay,c,n ] = read_ascii_file(s_src_file);
        if( ~okay )
          errtext = sprintf('%_error: File: <%s> konnte nicht eingelesen werden !!!',mfilename,s_src_file);
          error(errtext);
        end
      else % schon vorhanden
        [ okay,c,n ] = read_ascii_file(t_src_file_liste{jcell});
        if( ~okay )
          errtext = sprintf('%_error: File: <%s> konnte nicht eingelesen werden !!!',mfilename,t_src_file_liste{jcell});
          error(errtext);
        end
      end
      [jcell,jpos] = cell_find_from_ipos(c,1,1,q.ssw_vpu(i).line,'for');
      if( jcell > 0 )
        c{jcell} = q.ssw_vpu(i).inc_statement;
        %c{jcell} = q.ssw_vpu(i).ssw_on;
        
        okay = write_ascii_file(t_src_file,c);
        if( ~okay )
          error('%_error: Fehler bei Schreiben von t_src_file: <%s>',mfilename,t_src_file);
        end
      end
      tfile = change_file_dir(q.ssw_vpu(i).inc_fn,t_src_dir);
      [okay,message] = copy_file_if_newer(q.ssw_vpu(i).inc_fn,tfile,1);
      if( ~okay )
        error('%s_err: %s',mfilename,message);
      end

      % c-File in Liste eintragen, bzw umtragen
      j0 = search_in_source_files(q.source_files,q.ssw_vpu(i).filename);
      if( j0 ~= 0 )
         q.source_files = cell_delete(q.source_files,j0);
      end
      q.source_files = cell_add(q.source_files,{{t_src_file,q.rtas_ssw_config_name}});
      % Include-Verzeichnis
      [jcell,jpos] = cell_find_from_ipos(q.include_dirs,1,1,t_src_dir,'for');
      if( jcell == 0 )
         q.include_dirs = cell_add(q.include_dirs,t_src_dir);
      end
    end
      
  end
      
end
function q = build_vcproj_for_mex_Simulation_rtas_ssw_add_frame(q)
% q.rtas_app_src_frame_dir  dir von vpu-cg_frame.c

  % vpu-cg frame-file
  vpu_cg_frame_file = fullfile(q.rtas_app_src_frame_dir,[q.rtas_ssw_platform,'_frame.c']);
  s_file = str_get_pfe_f(vpu_cg_frame_file);
  
  j0 = search_in_source_files(q.source_files,s_file.filename);
  if( j0 ~= 0 )
     q.source_files = cell_delete(q.source_files,j0);
  end
  q.source_files = cell_add(q.source_files,{{vpu_cg_frame_file,q.rtas_ssw_config_name}});
  
  % Include-Verzeichnis
  [jcell,jpos] = cell_find_from_ipos(q.include_dirs,1,1,s_file.dir,'for');
  if( jcell == 0 )
     q.include_dirs = cell_add(q.include_dirs,s_file.dir);
  end
  
end
function q = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules(q)

  for i = 1:length(q.rtas_mod)
    
    % [src_files,inc_dirs] = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules_vcproj(q.rtas_mod(i),q.vc_version,q.rtas_not_source_files);
    [src_files,inc_dirs,preprocess_defs] = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules_mak(q.rtas_mod(i),q.rtas_app_prj_dir,q.rtas_not_source_files);
    
    for j = 1:length(src_files)
      j0 = search_in_source_files(q.source_files,src_files{j});
      if( j0 == 0 )
         q.source_files = cell_add(q.source_files,{{src_files{j},q.rtas_mod(i).name}});
      end
    end
    for j = 1:length(inc_dirs)
      [jcell,jpos] = cell_find_from_ipos(q.include_dirs,1,1,inc_dirs{j},'for');
      if( jcell == 0 )
         q.include_dirs = cell_add(q.include_dirs,inc_dirs{j});
      end
    end
    for j = 1:length(preprocess_defs)
      j0 = search_in_preprocess_defs(q.preprocess_defs,preprocess_defs{j});
      if( j0 == 0 )
         q.preprocess_defs = cell_add(q.preprocess_defs,preprocess_defs{j});
      end
    end
    
  end

end
function  rtas_mod = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules_rml(q)

  rml_file = fullfile(q.rtas_app_prj_dir,[q.rtas_project_name,'.rml']);
  
  if( ~exist(rml_file,'file') )
    error('%s_err: rml_file: <%s> konnte nicht gefunden werden .',mfilename,rml_file);
  end
  [ okay,c,n ] = read_ascii_file(rml_file);
  if( ~okay )
    errtext = sprintf('%_error: rml-File: <%s> konnte nicht eingelesen werden !!!',mfilename,rml_file);
    error(errtext);
  end
  for i=1:n
    [c_names,icount] = str_split(c{i},' ');
    c_names = cell_delete_if_empty(c_names);
    m       = length(c_names);
    if( m > 2 )
      rtas_mod(i).name     = c_names{1};
      rtas_mod(i).mod_name = c_names{2};
      rtas_mod(i).mod_dir  = c_names{3};
    end
  end
end
function [src_files,inc_dirs] = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules_vcproj(rtas_mod,vc_version,rtas_not_source_files)
  src_files =  {};
  inc_dirs =  {};
 
  % test with VC9
  %==============
  vc_proj_file = fullfile(rtas_mod.mod_dir,'mod',rtas_mod.mod_name,'mak\vc9lib',[rtas_mod.mod_name,'.vcproj']);
  if( exist(vc_proj_file,'file') )
    [s_files,inc_dirs] = VC9_get_vcproj(vc_proj_file);
  else
    error('%s_error: vc_proj_file konnte nicht gefunden werden',mfilename);
  end
  
  % s_files nach behandeln
  for i = 1:length(s_files)
    sf     = str_get_pfe_f(s_files{i});
    ifound = cell_find_f({'c','cpp','h','he'},sf.ext,'fl');
    if( ~isempty(ifound) )
      ifound = cell_find_f(rtas_not_source_files,sf.name,'nl');
      if( isempty(ifound) )
        src_files = cell_add(src_files,s_files{i});
      end
    end
  end
    
end
function [src_files,inc_dirs,preprocess_defs] = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules_mak(rtas_mod,rtas_app_prj_dir,rtas_not_source_files)
  src_files =  {};
  inc_dirs =  {};
  preprocess_defs = {};
  
  % test with rules_rm.mak
  %=======================
  rules_file = fullfile(rtas_app_prj_dir,'mak',rtas_mod.mod_name,'rules_rm.mak');
  if( exist(rules_file,'file') )
    [s_files,inc_dirs,preprocess_defs] = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules_mak_sip(rules_file);
  else
    error('%s_error: rules_file konnte in <%s> nicht gefunden werden',mfilename,rules_file);
  end
  
  % s_files nach behandeln
  for i = 1:length(s_files)
    sf     = str_get_pfe_f(s_files{i});
    ifound = cell_find_f({'c','cpp','h','he'},sf.ext,'fl');
    if( ~isempty(ifound) )
      ifound = cell_find_f(rtas_not_source_files,sf.name,'nl');
      if( isempty(ifound) )
        src_files = cell_add(src_files,s_files{i});
      end
    end
  end
    
end
function [src_files,inc_dirs,predefs] = build_vcproj_for_mex_Simulation_rtas_ssw_add_modules_mak_sip(rules_file)
  
  src_files =  {};
  inc_dirs =  {};
  predefs =  {};
  % read rules_file
  %----------------
  [ okay,c,n ] = read_ascii_file(rules_file);
  if( ~okay )
    error('%s_error: read_ascii_file(%s) funktioniert nicht',mfilename,rules_file);
  end
  
  % Find sources and include dirs
  %------------------------------
  for i=1:n
    if( str_find_f(c{i},'CFLAGS','vs') == 1 )
      tt = [c{i},'$'];
      c_text = str_get_quot_f(tt,'(PFTPF_I)','$','i');
      for j= 1:length(c_text)
        inc_dirs = cell_add(inc_dirs,str_cut_ae_f(c_text{j},' '));
      end
      c_text = str_get_quot_f(tt,'(PFTPF_D)','$','i');
      for j= 1:length(c_text)
        predefs = cell_add(predefs,str_cut_ae_f(c_text{j},' '));
      end
    elseif(  ~isempty(c{i}) ...
      && (c{i}(1) ~= '#') ...
      && (c{i}(1) ~= ' ') ...
      && (c{i}(1) ~= sprintf('\t')) ...
      )
      cc = str_split(c{i},': ');
      if( length(cc) == 2 )
        src_files = cell_add(src_files,cc{2});
      end
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
function j0 = search_in_preprocess_defs(preprocess_defs,new_def)
  j0   = 0;
  cc = str_split(new_def,'=');
  tt_new = str_cut_ae_f(cc{1},' ');
  for j=1:length(preprocess_defs)
    cc = str_split(preprocess_defs{j},'=');
    tt = str_cut_ae_f(cc{1},' ');
    if( strcmp(tt,tt_new) )
      j0 = j;
      break;
    end
  end
end