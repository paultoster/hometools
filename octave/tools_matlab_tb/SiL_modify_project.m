function q = SiL_modify_project(q)
%
% SiL_modify_project(q)
%
% Modify SiL-generateted Project (wxWave)
%
% input                   type    default   description                example
% q.proj_name             char    no        Project name               'SIM_VPU_HAF1'
% q.proj_dir              char    no        project path               'D:\VPU_HAF\SIM_VPU_HAF1'
% q.source_files          cell    no        vollständige source-Files  {'D:\VPU_HAF\VPU_HAF1\src\fct\fct_main.c',...}
% q.variable_pre_name     char    yes       Pre-Name wird for Variablen für
%                                           Ausgang gesetzt (default: 'SimOut')
% q.interface_cplusplus   single    0         Schnittstelle mit C++ (1) oder C (0)
% q.interface_h_files     char/cell no        vollständiger Headerfilename(n)
% q.interface_init_call   char      ''        Funktionsaufruf Init ('': keiner)
% q.interface_loop_call   char      no        Funktionsaufruf Loop
%
% Variable wie zu beschreiben:
% q.sim_def_var_h_files   char/cell no        vollständiger Headerfilename(n)
%
% q.sim_def_var_inp(i)          struct      variablen definition input struct SimInp
% q.sim_def_var_inp(i).name     = 'b';           % Simulationsname
% q.sim_def_var_inp(i).varformat   = 'char';        % c-format
% q.sim_def_var_inp(i).unit     = '-';           % Einheit aus der Simulation                                   
% q.sim_def_var_inp(i).type     = 'single';      % 'single','mBuffer'
% q.sim_def_var_inp(i).variable  = 'FctInp.b';    % Variablenname in c zur weitergabe
% q.sim_def_var_inp(i).varunit  = '-';           % Einheit für die Variable
% q.sim_def_var_inp(i).comment  = 'Test a';                 % Kommentar
%
% q.sim_def_var_out(i)          struct      variablen definition output struct SimOut
% q.sim_def_var_out(i).name     = 'b';           % Simulationsname
% q.sim_def_var_out(i).varformat   = 'char';        % c-format
% q.sim_def_var_out(i).unit     = '-';           % Einheit aus der Simulation                                   
% q.sim_def_var_out(i).type     = 'single';      % 'single','mBuffer'
% q.sim_def_var_out(i).variable  = 'FctInp.b';    % Variablenname in c zur weitergabe
% q.sim_def_var_out(i).varunit  = '-';           % Einheit für die Variable
% q.sim_def_var_out(i).comment  = 'Test a';                 % Kommentar
%
% Wird im File gesetzt:
%
%   q.variables_cpp_file
%   q.sim_def_h_file            = fullfile(q.proj_dir,'source','sim_io_cfg.h');
%   q.sim_def_struct_inp_name   = 'sim_io_inp';
%   q.sim_def_struct_out_name   = 'sim_io_out';
%   q.sim_def_variable_inp_name = 'SimInp';
%   q.sim_def_variable_out_name = 'SimOut';
%   q.code_kennung_start        = '#SIL_KENNSTART#';
%   q.code_kennung_end          = '#SIL_KENNEND#';

  q.modify_flag = 0;

  %==========================================================================
  % check input
  %==========================================================================
  % project-name und project-dir
  if( ~check_val_in_struct(q,'proj_name','char',1) )
    errror('input q.proj_name wrong (see help %s)',mfilename);
  end
  if( ~check_val_in_struct(q,'proj_dir','char',1) )
    errror('input q.proj_dir wrong (see help %s)',mfilename);
  end
  [c_names,ncount] = str_split(q.proj_dir,'\');

  if( ~strcmp(c_names{ncount},q.proj_name) ) q.proj_dir = fullfile(q.proj_dir,q.proj_name);end

  if( ~exist(q.proj_dir,'dir') ),error('proj_dir=''%s'' does not exist',q.proj_dir);end
  
  % source-files
  if( ~check_val_in_struct(q,'source_files','cell',1) )
    errror('input q.source_files = {} falscher Typ (help %s)',mfilename);
  end
  
  % Interface-Funktion
  %===================
  % interface_cplusplus
  if( ~isfield(q,'interface_cplusplus') )
    q.interface_cplusplus = 0;
  end
  % interface_h_files
  if( ~isfield(q,'interface_h_files') )
    error('interface-Header-Filename in q.interface_h_files nicht gesetzt!!');
  end
  if( ischar(q.interface_h_files) )
    q.interface_h_files = {q.interface_h_files};
  end
  if( ~check_val_in_struct(q,'interface_h_files','cell',1) )
    errror('input q.interface_h_files = {} falscher Typ (see help %s)',mfilename);
  end  
  for i = 1:length(q.interface_h_files)
    if( ~exist(q.interface_h_files{i},'file') )
      error('q.interface_h_files{%i} = %s existiert nicht',i,q.interface_h_files{i});
    end
  end
  % interface_init_call
  if( ~isfield(q,'interface_init_call') )
    q.interface_init_call = '';
  end
  if( ~check_val_in_struct(q,'interface_init_call','char',0) )
    error('input q.interface_init_call = {} falscher Typ (help %s)',mfilename);
  end  
  % interface_loop_call
  if( ~isfield(q,'interface_init_call') )
    error('q.interface_loop_call muss gesetzt sein (siehe %s)',mfilename);
  end
  if( ~check_val_in_struct(q,'interface_loop_call','char',1) )
    errror('input q.interface_loop_call = {} falscher Typ (help %s)',mfilename);
  end

  % Variablendefinition und Übergabe
  %=================================
  % sim_def_var_h_files
  if( ~isfield(q,'sim_def_var_h_files') )
    error('Varialen-Header-Filename(n) in q.sim_def_var_h_files nicht gesetzt!!');
  end
  if( ischar(q.sim_def_var_h_files) )
    q.sim_def_var_h_files = {q.sim_def_var_h_files};
  end
  if( ~check_val_in_struct(q,'sim_def_var_h_files','cell',1) )
    errror('input q.sim_def_var_h_files = {} falscher Typ (see help %s)',mfilename);
  end  
  for i = 1:length(q.sim_def_var_h_files)
    if( ~exist(q.sim_def_var_h_files{i},'file') )
      error('q.sim_def_var_h_files{%i} = %s existiert nicht',i,q.sim_def_var_h_files{i});
    end
  end
  % Var-In-Struct
  if( isfield(q,'sim_def_var_inp') )
    q.sim_def_n_var_inp = length(q.sim_def_var_inp);
  else
    q.sim_def_n_var_inp = 0;
  end
  % Var-Out-Struct
  if( isfield(q,'sim_def_var_out') )
    q.sim_def_n_var_out = length(q.sim_def_var_out);
  else
    q.sim_def_n_var_out = 0;
  end
  
  % Pre-Name für Simulationsoutput
  %===============================
  if( ~isfield(q,'variable_pre_name') )
    q.variable_pre_name         = 'SimOut';
  end
  
  %==========================================================================
  %==========================================================================  
  % sim-io-struct
  q.sim_def_h_file            = fullfile(q.proj_dir,'source','sim_io_cfg.h');
  q.sim_def_struct_inp_name   = 'sim_io_inp';
  q.sim_def_struct_out_name   = 'sim_io_out';
  q.sim_def_variable_inp_name = 'SimInp';
  q.sim_def_variable_out_name = 'SimOut';
  q.code_kennung_start        = '#SIL_KENN_START#';
  q.code_kennung_end          = '#SIL_KENN_END#';
  % variables.cpp
  %--------------
  q.variables_cpp_file = fullfile(q.proj_dir,'source','frame','variables.cpp');
  % module_fr.cpp
  %--------------
  q.module_fr_cpp_file = fullfile(q.proj_dir,'source','frame','module_fr.cpp');
  % wave_PROJ_NAME.c
  %-----------------
  q.wave_c_file = fullfile(q.proj_dir,'source',['wave_',q.proj_name,'.c']);
  
  % Var-In-Struct überprüfen
  if( q.sim_def_n_var_inp )
    q.sim_def_var_inp = Sim_def_var_check(q.sim_def_var_inp);
    for i = 1:length(q.sim_def_var_inp)
      q.sim_def_var_inp(i).cname = [q.sim_def_variable_inp_name,'.',q.sim_def_var_inp(i).name];
    end
  end
  % Var-Out-Struct überprüfen
  if( q.sim_def_n_var_out )
    q.sim_def_var_out = Sim_def_var_check(q.sim_def_var_out,q.variable_pre_name);
    for i = 1:length(q.sim_def_var_out)
      q.sim_def_var_out(i).cname = [q.sim_def_variable_out_name,'.',q.sim_def_var_out(i).name];
    end
  end
  %==========================================================================
  % vcporj
  %==========================================================================
  % vcproj name
  q.vcproj_file = fullfile(q.proj_dir,[q.proj_name,'_lib.vcproj']);
  q.vcproj_root = xml_read_build_struct(q.vcproj_file);
  
  %==========================================================================
  % sourcen hinzufügen
  %==========================================================================
  source_files = q.source_files;
  source_files = cell_add(source_files,q.sim_def_h_file);
  if( ~isempty(q.sim_def_var_h_files) )
    source_files = cell_add(source_files,q.sim_def_var_h_files);
  end
  if( ~isempty(q.interface_h_files) )
    source_files = cell_add(source_files,q.interface_h_files);
  end
  q = SiL_modify_project_add_sources(q,source_files);  
  %==========================================================================
  % Includes hinzufügen mit q.ss_new aus(SiL_modify_project_add_sources)
  %==========================================================================
  q = SiL_modify_project_add_includes(q);
  %==========================================================================
  % PreprocessorDefinition hinzufügen
  %==========================================================================
  q = SiL_modify_project_add_preprocessdef(q,{'SIM_CFG'});
    
  %==========================================================================
  % vcproj
  %==========================================================================
  % Wieder in vcproj schreiben
  if( q.modifyflag )
    okay = xml_struct_write_to_xml(q.vcproj_file,q.vcproj_root);
  end
  % okay = xml_struct_write_to_xml('test.vcproj',q.vcproj_root);
  
  
  %==========================================================================
  % sim-io-header-file mit q.sim_def_h_file
  %==========================================================================
  okay = SiL_modify_project_make_sim_def_h_file(q.sim_def_h_file ...
                                               ,q.sim_def_struct_inp_name ...
                                               ,q.sim_def_struct_out_name ...
                                               ,q.sim_def_variable_inp_name ...
                                               ,q.sim_def_variable_out_name ...
                                               ,q.sim_def_var_inp ...
                                               ,q.sim_def_var_out ...
                                               ,q.sim_def_n_var_inp ...
                                               ,q.sim_def_n_var_out);
  if( ~okay )
    error('SiL_modify_project_make_sim_def_h_file hat nicht funktioniert');
  end
  %==========================================================================
  % variables.cpp-file mit q.variables_cpp_file
  %==========================================================================
  okay = SiL_modify_project_make_variables_cpp_file(q.proj_name ...
                                                   ,q.sim_def_var_inp ...
                                                   ,q.sim_def_var_out ...
                                                   ,q.sim_def_n_var_inp ...
                                                   ,q.sim_def_n_var_inp ...
                                                   ,q.variables_cpp_file ...
                                                   ,q.sim_def_h_file ...
                                                   ,q.code_kennung_start ...
                                                   ,q.code_kennung_end);
  if( ~okay )
    error('SiL_modify_project_make_variables_cpp_file hat nicht funktioniert');
  end
  if( q.interface_cplusplus )
  else
    %==========================================================================
    % wave_PROJ_NAME.c-file
    %==========================================================================
    okay = SiL_modify_project_make_wave_c_file(q.proj_name ...
                                              ,q.sim_def_var_inp ...
                                              ,q.sim_def_var_out ...
                                              ,q.sim_def_n_var_inp ...
                                              ,q.sim_def_n_var_inp ...
                                              ,q.wave_c_file ...
                                              ,q.sim_def_h_file ...
                                              ,q.interface_h_files ...
                                              ,q.sim_def_var_h_files ...
                                              ,q.interface_init_call ...
                                              ,q.interface_loop_call ...
                                              ,q.code_kennung_start ...
                                              ,q.code_kennung_end);
  end  
  
  fprintf('================================================================\n');
  fprintf('================================================================\n');
  fprintf('Projekt %s in Verzeichnis %s erstellt\n',q.proj_name,q.proj_dir);
  fprintf('================================================================\n');
  fprintf('================================================================\n');
  
  
end
function q = SiL_modify_project_add_sources(q,source_files)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Files.Filter'
  % mit Attribut Name='sources'
  %
  fchilds = xml_struct_find_children_in_childs(q.vcproj_root,'VisualStudioProject.Files.Filter','a.Name.sources');
  
  % Hole davon alle mit attribut 'RelativePAth'
  source_list = xml_struct_get_list_childs_w_attribute(fchilds,'RelativePath');
  
  % Suche die hinzuzufügenden Sourcen
  q.ss_exist = SiL_modify_project_get_path_struct(q.proj_dir,source_list);
  q.ss_new   = SiL_modify_project_get_path_struct(q.proj_dir,source_files);
  ss_add   = SiL_modify_project_check_source_files(q.ss_exist,q.ss_new);
  
  if( ~isempty(ss_add) )
    fchilds        = SiL_modify_project_set_children(fchilds,ss_add);
    [q.vcproj_root,okay,errText] = xml_struct_set_children(q.vcproj_root,fchilds,'VisualStudioProject.Files.Filter','a.Name.sources',1);
    if( ~okay )
      fprintf('Fehler in Sourcen hinzufügen: \n%s',errText);
    end
    q.modifyflag = 1;
  end
end
function q = SiL_modify_project_add_includes(q)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  % Release
  %--------
  fchilds = xml_struct_find_children_in_childs(q.vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
  [include_str,newflag] = SiL_modify_project_check_include_list(ll{1},q.ss_new);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalIncludeDirectories',include_str);
    [q.vcproj_root,okay,errText] = xml_struct_set_children(q.vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
    if( ~okay )
      fprintf('Fehler in Include directory hinzufügen: \n%s',errText);
    end
    q.modifyflag = 1;
  end
  % Debug
  %------
  fchilds = xml_struct_find_children_in_childs(q.vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'AdditionalIncludeDirectories');
  [include_str,newflag] = SiL_modify_project_check_include_list(ll{1},q.ss_new);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'AdditionalIncludeDirectories',include_str);
    [q.vcproj_root,okay,errText] = xml_struct_set_children(q.vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
    if( ~okay )
      fprintf('Fehler in Include directory hinzufügen: \n%s',errText);
    end
    q.modifyflag = 1;
  end
end
function q = SiL_modify_project_add_preprocessdef(q,ppd_list)
  % Sucht die den Zweig (Children) in 'VisualStudioProject.Configurations.Configuration'
  % mit Attribut Name='AdditionalIncludeDirectories'
  %
  % Release
  %--------
  fchilds = xml_struct_find_children_in_childs(q.vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'PreprocessorDefinitions');
  [ppd_str,newflag] = SiL_modify_project_check_ppd_list(ll{1},ppd_list);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'PreprocessorDefinitions',ppd_str);
    [q.vcproj_root,okay,errText] = xml_struct_set_children(q.vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Release.valnotexact',1);
    if( ~okay )
      fprintf('Fehler in Include directory hinzufügen: \n%s',errText);
    end
    q.modifyflag = 1;
  end
  % Debug
  %------
  fchilds = xml_struct_find_children_in_childs(q.vcproj_root,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact');

  % Hole davon alle mit attribut 'RelativePAth'
  [ll,ivec] = xml_struct_get_list_childs_w_attribute(fchilds,'PreprocessorDefinitions');
  [ppd_str,newflag] = SiL_modify_project_check_ppd_list(ll{1},ppd_list);
  if( newflag )
    fchilds = xml_struct_set_attribute_to_children(fchilds,ivec(1),'PreprocessorDefinitions',ppd_str);
    [q.vcproj_root,okay,errText] = xml_struct_set_children(q.vcproj_root,fchilds,'VisualStudioProject.Configurations.Configuration','a.Name.Debug.valnotexact',1);
    if( ~okay )
      fprintf('Fehler in Include directory hinzufügen: \n%s',errText);
    end
    q.modifyflag = 1;
  end
end
%===============================================================================
%===============================================================================
%===============================================================================
function ss = SiL_modify_project_get_path_struct(proj_dir,ll)
  
  n = length(ll);
  for i=1:n
    s = str_get_pfe_f(ll{i});
     
    ss(i).file_name = [s.name,'.',s.ext];
     
    if( is_abs_dir(s.dir) )
      ss(i).abs_dir   = s.dir;
      ss(i).rel_dir   = get_rel_dir(s.dir,proj_dir);
    else
      ss(i).abs_dir   = get_abs_dir(s.dir,proj_dir);
      ss(i).rel_dir   = s.dir;
    end
  end
end
function ss_add   = SiL_modify_project_check_source_files(ss_exist,ss_new)
  n_exist = length(ss_exist);
  n_new   = length(ss_new);
  n_add   = 0;
  
  % ss_add  = struct('file_name','','rel_dir','','abs_dir','');
  for i=1:n_new
    flag = 1;
    for j=1:n_exist
      if( strcmpi(ss_exist(j).file_name,ss_new(i).file_name) )
        flag = 0;
        break;
      end
    end
    if( flag )
      n_add         = n_add+1;
      ss_add(n_add) = ss_new(i);
    end
  end
  if( ~exist('ss_add','var') )
    ss_add = struct([]);
  end
end
function children = SiL_modify_project_set_children(children,ss_add)

  n0        = length(children);
  n         = length(ss_add);
  if( n0 == 0 )
    allocCell = cell(1, n);

    children  = struct(             ...
                'Name', allocCell, 'Attributes', allocCell,    ...
                'Data', allocCell, 'Children', allocCell);
  end            
  for i = 1:n
    
    children(i+n0).Name = 'File';
    children(i+n0).Attributes(1).Name  = 'RelativePath';
    children(i+n0).Attributes(1).Value = fullfile(ss_add(i).rel_dir,ss_add(i).file_name);
  end
  
end
function [include_string,newflag] = SiL_modify_project_check_include_list(include_string,ss)
%
% ss(i).abs_dir
% ss(i).rel_dir
% ss(i).file_name
%
  newflag = 0;
  ll = str_split(include_string,';');
  ns = length(ss);
  n  = length(ll);
  add_list = {};
  for i = 1:ns
    flag = 1;
    for j=1:n
      if( is_abs_dir(ll{j}) )        
        if( dircmpi(ss(i).abs_dir,ll{j}) )
          flag = 0;
        end
      else
        if( dircmpi(ss(i).rel_dir,ll{j}) )
          flag = 0;
        end
      end
    end
    if( flag )
      add_list = cell_add(add_list,ss(i).rel_dir);
    end
  end
  if( ~isempty(add_list) )
    ll = cell_add(ll,add_list);
    include_string = str_compose(ll,';');
    newflag = 1;
  end
end
function [ppd_string,newflag] = SiL_modify_project_check_ppd_list(ppd_string,ppd_list)
%
%
  newflag = 0;
  ll = str_split(ppd_string,';');
  np = length(ppd_list);
  n  = length(ll);
  add_list = {};
  for i = 1:np
    flag = 1;
    for j=1:n
      if( strcmp(ppd_list{i},ll{j}) )
        flag = 0;
        break;
      end
    end
    if( flag )
      add_list = cell_add(add_list,ppd_list{i});
    end
  end
  if( ~isempty(add_list) )
    ll = cell_add(ll,add_list);
    ppd_string = str_compose(ll,';');
    newflag = 1;
  end
end


  