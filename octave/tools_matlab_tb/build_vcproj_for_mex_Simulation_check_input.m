function q = build_vcproj_for_mex_Simulation_check_input(q)

  %==========================================================================
  % check input
  %==========================================================================

  %==========================================================================
  % type
  %==========================================================================
  if( ~check_val_in_struct(q,'type','char',1) )
    error('input q.type wrong (see help %s)',mfilename);
  end
  
  if(  ~strcmp(q.type,'can_full') ...
    && ~strcmp(q.type,'modul') ...
    && ~strcmp(q.type,'emodul') ...
    && ~strcmp(q.type,'smodul') ...
    && ~strcmp(q.type,'time_step') ...
    )
    error('input q.type = %s not possible (see help %s)',q.type,mfilename);
  end
  
  %==========================================================================
  % run-dir
  %==========================================================================
  if( strcmp(q.type,'time_step') )
    if( ~check_val_in_struct(q,'run_path','char',1) )
      error('input q.run_path wrong (see help %s)',mfilename);
    end
    if( ~exist(q.run_path,'dir') )
      error('run path:<%s> does not exist',q.run_path);
    end
  end  
  %==========================================================================
  % project-name und project-dir
  %==========================================================================
  if( ~check_val_in_struct(q,'proj_name','char',1) )
    error('input q.proj_name wrong (see help %s)',mfilename);
  else
    q.proj_name = str_cut_ae_f(q.proj_name,' ');
    q.proj_name = str_change_f(q.proj_name,' ','');
  end
  if( ~check_val_in_struct(q,'proj_dir','char',1) )
    error('input q.proj_dir wrong (see help %s)',mfilename);
  end
  [c_names,ncount] = str_split(q.proj_dir,'\');

  if( ~strcmp(c_names{ncount},q.proj_name) ) 
    q.proj_dir = fullfile(q.proj_dir,q.proj_name);
  end

  %==========================================================================
  % VPU-Environment
  %==========================================================================
  if( ~check_val_in_struct(q,'use_vpu_code','num',1) )
    q.use_vpu_code = 0;
  end
  
  if( q.use_vpu_code )
  
    if( ~check_val_in_struct(q,'vpu_dir','char',1) )
      error('input q.vpu_dir nicht gesetzt (see help %s)',mfilename);
    end
    if( ~exist(q.vpu_dir,'dir') )
      error('%s_error: input q.vpu_dir=''%s'' wrong (see help %s)',mfilename,q.vpu_dir);
    end
  end  
  
  
  %==========================================================================
  % rtas-Environment
  %==========================================================================
  if( ~check_val_in_struct(q,'use_rtas_code','num',1) )
    q.use_rtas_code = 0;
  end
  
  if( q.use_rtas_code )
    % RTAS-dir
    %-------------------------------------------------------------------
    if( ~check_val_in_struct(q,'rtas_dir','char',1) )
      q.rtas_dir = '';
    end
    
    if( ~check_val_in_struct(q,'rtas_mod_dir','char',1) )
      q.rtas_mod_dir = '';
    end
    
    if( ~check_val_in_struct(q,'rtas_app_dir','char',1) )
      q.rtas_app_dir = '';
    end
    if( ~check_val_in_struct(q,'rtas_projconf_dir','char',1) )
      q.rtas_projconf_dir = '';
    end

    if( ~isempty(q.rtas_mod_dir) && ~exist(q.rtas_mod_dir,'dir') )
      error('RTAS-mod-Verzeichnis q.rtas_mod_dir = %s existiert nicht',q.rtas_mod_dir);
    end
    if( ~isempty(q.rtas_app_dir) && ~exist(q.rtas_app_dir,'dir') )
      error('RTAS-app-Verzeichnis q.rtas_app_dir = %s existiert nicht',q.rtas_app_dir);
    end
    if( ~isempty(q.rtas_projconf_dir) && ~exist(q.rtas_projconf_dir,'dir') )
      error('RTAS-app-Verzeichnis q.rtas_projconf_dir = %s existiert nicht',q.rtas_projconf_dir);
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
    % q.rtas_ssw_config_name  char    yes       RTAS-SSW-configuration-name      default: '' => no RTAS-include 
    if( ~check_val_in_struct(q,'rtas_ssw_config_name','char',1) )
      error('%s: q.rtas_ssw_config_name = ''abc'' muss angebene werden',mfilename);
    end
    % q.rtas_project_name     char    no       RTAS PAM "Project name"
    %                                          (project-Application-Manager)
    if( ~check_val_in_struct(q,'rtas_project_name','char',1) )
      error('%s: q.rtas_project_name = ''def'' muss angebene werden',mfilename);
    end
  end  
  
  
  %==========================================================================
  % Matlab-dir
  %==========================================================================
  if( ~check_val_in_struct(q,'matlab_dir','char',1) )
    error('input q.matlab_dir nicht gesetzt (see help %s)',mfilename);
  end
  if( ~exist(q.matlab_dir,'dir') )
    error('%s_error: input q.matlab_dir=''%s'' wrong (see help %s)',mfilename,q.matlab_dir);
  end
  
  
  %==========================================================================
  % Source-File-Liste (q.source_files) überprüfen
  %==========================================================================
  % q.source_files anlegen wenn Variable nicht vorhanden
  % und Filter für visual C vervollständigen
  %--------------------------------------------
  if( ~check_val_in_struct(q,'source_files','cell',0) )
    q.source_files = {};
  else
    for i=1:length(q.source_files)
      if( ischar(q.source_files{i}) )
        q.source_files{i} = {q.source_files{i},q.VC_FILTER_NAME};
      elseif( iscell(q.source_files{i}) && (length(q.source_files{i}) == 1) )
        q.source_files{i} = {q.source_files{i}{1},q.VC_FILTER_NAME};
      end
    end
  end
  % prüfen, ob doppelt
  %---------------------
  n = length(q.source_files);
  i = 0;
  while( i < n )
    i = i+1;
    j = i;
    while( j < n )
      j = j + 1;
      if( strcmpi(q.source_files{i}{1},q.source_files{j}{1}) )
        q.source_files = cell_delete(q.source_files,j);
        n              = length(q.source_files);
      end
    end
  end

  % prüfen, ob vorhanden
  %---------------------
  for i=1:length(q.source_files)
    if( ~exist(q.source_files{i}{1},'file') )
      error('%s_error: q.source_files{%i} = {''%s'',''%s''} nicht vorhanden',mfilename,i,str_change_f(q.source_files{i}{1},sprintf('\\'),'/'),q.source_files{i}{2});
    end
  end

  %==========================================================================
  % Source-File-to-copy-Liste (q.source_file_to_copy) überprüfen
  % q.source_file_to_copy bilden, wenn nicht vorhanden
  % und Filter für visual C vervollständigen
  %==========================================================================
  if( ~check_val_in_struct(q,'source_file_to_copy','cell',0) )
    q.source_file_to_copy = {};
  else
    for i=1:length(q.source_file_to_copy)
      if( ischar(q.source_file_to_copy{i}) )
        q.source_file_to_copy{i} = {q.source_file_to_copy{i},q.VC_FILTER_NAME};
      elseif( iscell(q.source_file_to_copy{i}) && (length(q.source_file_to_copy{i}) == 1) )
        q.source_file_to_copy{i} = {q.source_file_to_copy{i}{1},q.VC_FILTER_NAME};
      end
    end
  end
  % prüfen, ob vorhanden
  %---------------------
  for i=1:length(q.source_file_to_copy)
    if( ~exist(q.source_file_to_copy{i}{1},'file') )
      error('%s_error: q.source_file_to_copy{%i} = {''%s'',''%s''} nicht vorhanden',mfilename,q.source_file_to_copy{i}{1},q.source_file_to_copy{i}{2});
    end
  end

  %==========================================================================
  % sim_def_var_inp prüfen: bilden, wenn nicht vorhanden
  %==========================================================================
  if( ~check_val_in_struct(q,'sim_def_var_inp','struct',0) )
    q.sim_def_var_inp = {};
  else
    q.sim_def_var_inp = Sim_def_var_check(q.sim_def_var_inp,'','i');
  end
  if( strcmp(q.type,'time_step') )
    if( ~check_val_in_struct(q,'time_step_index','char',1) )
      q.time_step_index = 'iTime';
    end
  end
  
  %==========================================================================
  % sim_def_var_out prüfen: bilden, wenn nicht vorhanden
  %==========================================================================
  if( ~check_val_in_struct(q,'sim_def_var_out','struct',0) )
    q.sim_def_var_out = {};
  else
    q.sim_def_var_out = Sim_def_var_check(q.sim_def_var_out,'','o');
  end
  
  %==========================================================================
  % sim_def_var_par prüfen: bilden, wenn nicht vorhanden
  %==========================================================================
  if( ~check_val_in_struct(q,'sim_def_var_par','struct',0) )
    q.sim_def_var_par = {};
  else
    q.sim_def_var_par = Sim_def_var_check(q.sim_def_var_par,'','p');
  end
  
  %==========================================================================
  % sim_def_fkt_code prüfen: bilden, wenn nicht vorhanden
  %==========================================================================
  if( ~check_val_in_struct(q,'sim_def_fkt_code','struct',0) )
    q.sim_def_fkt_code = [];
  else
    q.sim_def_fkt_code = Sim_def_fkt_code_check(q.sim_def_fkt_code);
  end
  
  %==========================================================================
  % vcproj vorbereiten
  %==========================================================================
  if( ~check_val_in_struct(q,'vc_version','char',1) )
    q.vc_version   = 'VC9';
  end
  if( strcmpi(q.vc_version,'VC9') )
    if( ~check_val_in_struct(q,'vc_proj_file','char',1) )
      q.vc_proj_file = fullfile(q.proj_dir,['mex_',q.proj_name,'.vcproj']); 
    end
    if( ~check_val_in_struct(q,'vc_sln_file','char',1) )
      q.vc_sln_file = fullfile(q.proj_dir,['mex_',q.proj_name,'.sln']); 
    end
  elseif( strcmpi(q.vc_version,'VC11') )
    if( ~check_val_in_struct(q,'vc_proj_file','char',1) )
      q.vc_proj_file = fullfile(q.proj_dir,['mex_',q.proj_name,'.vcxproj']); 
    end
    if( ~check_val_in_struct(q,'vc_filters_file','char',1) )
      q.vc_filters_file = fullfile(q.proj_dir,['mex_',q.proj_name,'.vcxproj.filters']); 
    end
    if( ~check_val_in_struct(q,'vc_sln_file','char',1) )
      q.vc_sln_file = fullfile(q.proj_dir,['mex_',q.proj_name,'.sln']); 
    end
  elseif( strcmpi(q.vc_version,'VC14') )
    if( ~check_val_in_struct(q,'vc_proj_file','char',1) )
      q.vc_proj_file = fullfile(q.proj_dir,['mex_',q.proj_name,'.vcxproj']); 
    end
    if( ~check_val_in_struct(q,'vc_filters_file','char',1) )
      q.vc_filters_file = fullfile(q.proj_dir,['mex_',q.proj_name,'.vcxproj.filters']); 
    end
    if( ~check_val_in_struct(q,'vc_sln_file','char',1) )
      q.vc_sln_file = fullfile(q.proj_dir,['mex_',q.proj_name,'.sln']); 
    end
  else
    error('%s_error: VisualC-Version=<%s> ist nicht vorhanden',mfilename,q.vc_version);
  end
  
  
  %==========================================================================
  % build_mex festlegen
  %==========================================================================
  if( ~check_val_in_struct(q,'build_mex','num',1) )
   q.build_mex = 0;
  end
  if( q.build_mex > 2 ),q.build_mex = 2;end

  
  %==========================================================================
  % vc_sln_write
  %==========================================================================
  if( ~check_val_in_struct(q,'vc_sln_write','num',1) )
   q.vc_sln_write = 0;
  end
  
  
  %==========================================================================
  % Pfad q.src_copy_dir mit sourcen allg\src suchen
  %==========================================================================
  [c,n] = getpath_with('src_modul');
  if( n == 0 )
    error('%s_error: Das Verzeichnis ...\\src_modul konnte im path nicht gefunden werden',mfilename);
  end
  flag = 1;
  for i=1:n
    q.src_copy_dir = c{i};
    if( exist(q.src_copy_dir,'dir') )
      flag = 0;
      break;
    end
  end
  if( flag )
    for i=1:n
      error('%s_error: Das Verzeichnis allg\src mit den sourcen konnte im path nicht gefunden werden',mfilename);
    end
  end

  %==========================================================================
  % time_step
  %==========================================================================
  if( ~check_val_in_struct(q,'vc_sln_write','char',1) )
   q.time_step_index = 'iTime';
  end
  
  

end