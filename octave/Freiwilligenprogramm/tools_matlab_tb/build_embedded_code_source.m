function [okay,errtext] = build_embedded_code_source(q)
%
% [okay,errtext] = build_embedded_code_source(q)
%
% q.module_name             Name of module
% q.module_path             simulink model path
%
% q.vehicle_table           Vehicle table
%                           List with target vehicles
%                           (use same names as in target_vehicles.h of RPECU code)
%                           First item: Name of target vehicle as in target_vehicles.h of RPECU code
%                           Second item: Suffix of inititalization m-file which shall be used for target_vehicle
%
%                                               Target vehicle                      Corresponding ini file w/o extension 
%                           q.vehicle_table = {{'TRGT_TZ_4500',                     'ADMotionControlVehicle_init_PassatB8'} ...
%                                             ,{'TRGT_TZ_4500_SAI',                 'ADMotionControlVehicle_init_PassatB8'}...
%                                             ,{'TRGT_DDGE_CRYSLR_FOT1_PHAD2018',   'ADMotionControlVehicle_init_Chrysler300'} ...
%                                             };
%
% q.init_file_body          body of inititalization m-file: init_file_body + suffix + .m
%
%
%                             q.init_file_body = [q.module_name,'_init_'];
%
% q.target_path             target path for c-code
%
%                             q.target_path = getfullpath('..\src');
%
% q.target_path_to_copy     if you need another copy of all c-files (takes
%                           filelist and copies into target_path_to_copy
%
% q.interface_file_type   = 'C'   C-File For Interface File (default)
%                           'C++' oder 'CPP' Cpp-File
%
% q.build_cmake_file      = 1(default) build cmake File CMakeLists.txt
%                                      above q.target_path
%                         = 0          do not build
%
%
% q.build_run_task        = 1/0    build run task  
%

  okay    = 1;
  errtext = '';
  
  %========================================================================
  %========================================================================
  % check Input
  %========================================================================
  %========================================================================
  
  % q.modul_name
  %-------------
  if( ~check_val_in_struct(q,'module_name','char',1) )
    error('input q.module_name wrong or not set (see help %s)',mfilename);
  end

  % q.module_path
  %--------------
  if( ~check_val_in_struct(q,'module_path','char',1) )
    error('input q.module_path wrong or not set (see help %s)',mfilename);
  end

  if( ~exist(q.module_path,'dir') )
    error('dir q.module_path does not exist');
  end

  % q.module_abbrivation
  %---------------------
  if( ~check_val_in_struct(q,'module_abbrivation','char',1) )
    q.module_abbrivation = q.module_name;
  end
  
  % q.vehicle_table
  %----------------
  if( ~check_val_in_struct(q,'vehicle_table','cell',1) )
    error('input q.vehicle_table wrong or not set (see help %s)',mfilename);
  end
  
  q.n_vehicle_table = length(q.vehicle_table);
  for i=1:q.n_vehicle_table
    
    if( ~iscell(q.vehicle_table{i}) )
      error('input q.vehicle_table{i} is not a cell (see help %s)',i,mfilename);
    end
    if( length(q.vehicle_table{i}) < 2 )
      error('input q.vehicle_table{i} must have two items {Target vehicle,Corresponding suffix} (see help %s)',i,mfilename);
    end
  end

  % q.init_file_body
  %-----------------
  if( ~check_val_in_struct(q,'init_file_body','char',1) )
    error('input q.init_file_body wrong or not set (see help %s)',mfilename);
  end
  
  % q.target_path
  %--------------
  if( ~check_val_in_struct(q,'target_path','char',1) )
    error('input q.target_path wrong or not set (see help %s)',mfilename);
  end

  if( ~exist(q.target_path,'dir') )
    try
      [success,message,~] = mkdir(q.target_path);
    catch
      success = 0;
      message = sprintf(' crashed');
    end
    if( ~success )
      error('mkdir(%s):%s',q.target_path,message);
    end
  end
  
  % q.target_path_to_copy
  %----------------------
  if( ~check_val_in_struct(q,'target_path_to_copy','char',1) )
    q.target_path_to_copy = '';
  end
  
  if( ~isempty(q.target_path_to_copy) )
    if( ~exist(q.target_path_to_copy,'dir') )
      try
        [success,message,~] = mkdir(q.target_path_to_copy);
      catch
        success = 0;
        message = sprintf(' crashed');
      end
      if( ~success )
        error('mkdir(%s):%s',q.target_path_to_copy,message);
      end
    end
  end
  
  % q.interface_file_type
  %----------------------
  q.C_FILE_TYPE   = 1;
  q.CPP_FILE_TYPE = 2;
  if( ~check_val_in_struct(q,'interface_file_type','char',1) )
    q.intface_type = q.C_FILE_TYPE;
  elseif( strcmpi('c',q.interface_file_type) )
    q.intface_type = q.C_FILE_TYPE;
  else
    q.intface_type = q.CPP_FILE_TYPE;
  end
  
  % q.build_cmake_file
  %-------------------
  if( ~check_val_in_struct(q,'build_cmake_file','num',1) )
    
    q.build_cmake_file = 1;
  elseif( q.build_cmake_file == 0 )
    
    q.build_cmake_file = 0;
  else
    q.build_cmake_file = 1;
  end
  
  % q.build_run_task
  %-------------------
  if( ~check_val_in_struct(q,'build_run_task','num',1) )
    
    q.build_run_task = 0;
  elseif( q.build_run_task == 0 )
    q.build_run_task = 0;
  else
    q.build_run_task = 1;
  end
  
  % q.temp_path
  %------------
  q.temp_path = fullfile(pwd,[q.module_name,'_temp']);
  
  
  % exlude files
  %-------------
  q.exclude_files = {'ert_main.c'};
  
  % predifned names
  %----------------
  q.PRE_NAME_STRUCT_INPUT              = 'ExternalInputs_';
  q.PRE_NAME_STRUCT_OUTPUT             = 'ExternalOutputs_';
  q.POST_NAME_STRUCT_VARIABLE_INPUT    = '_U';
  q.POST_NAME_STRUCT_VARIABLE_OUTPUT   = '_Y';
  q.POST_NAME_FUNCTION_INIT_CALL       = '_initialize';
  q.POST_NAME_FUNCTION_LOOP_CALL       = '_step';
  q.POST_NAME_FUNCTION_NAME_INTERFACE  = '_interface';
  q.POST_NAME_FUNCTION_NAME_INIT       = '_init';
  q.POST_NAME_FUNCTION_NAME_LOOP       = '_loop';
  q.POST_NAME_FUNCTION_NAME_PARAM      = '_param';
  q.POST_NAME_FUNCTION_NAME_COPY_PARAM = '_copy_param';
  q.ENUM_TARGET_NAME                   = ['E',q.module_name,'_Project'];
  q.CMAKE_FILE_NAME                    = 'CMakeLists.txt';
  
  
  %========================================================================
  %========================================================================
  % build embeded
  %========================================================================
  %========================================================================
  
  
  % prepare Model in simulink
  %--------------------------
  [okay,errtext] = build_embedded_code_source_prepare_model(q);
  if( ~okay )
    error('errr: %s',errtext);
  end
  
  
  % build unique suffix list and target names
  %------------------------------------------
  q.target_names = cell(1,q.n_vehicle_table);
  q.suffix_names = cell(1,q.n_vehicle_table);
  
  for i=1:length(q.vehicle_table)
    
    q.target_names{i} = q.vehicle_table{i}{1};
    q.suffix_names{i} = q.vehicle_table{i}{2};
  end
  unique_list = q.suffix_names; % unique(q.suffix_names); mit Befehl unique kommt alles durcheinander
  n           = length(unique_list);
  
  
  
  

  filelist = {};
  % prepare model, build model and handle source
  %---------------------------------------------
  for i=1:n
    
    % model build c-code
    [okay,errtext] = build_embedded_code_source_build_model(q,unique_list{i});
    if( ~okay )
      error('errr: %s',errtext);
    end
    
    % copy data source (parametr c-file), modify if run_task
    [okay,errtext,paramfilename] = build_embedded_copy_data_source(q,unique_list{i},i);
    if( ~okay )
      error('errr: %s',errtext);
    end
    
    if( ~isempty(paramfilename) )
      filelist = cell_add(filelist,paramfilename);
    end
    
  end
  
  
  % revert Parameter Model in simulink
  %-----------------------------------
  [okay,errtext] = build_embedded_code_source_revert_parameter_model(q);
  if( ~okay )
    error('errr: %s',errtext);
  end
  
  
  
  
  [okay,errtext,filelist] = finish_build_embedded_copy_data_source(q,filelist);
  
    
  % get all other source-files
  %---------------------------
  [okay,errtext,filelist] = build_embedded_code_source_copy_source(q,filelist);
  if( ~okay )
    error('errr: %s',errtext);
  end
  
  % build File with input and output struct as template
  % if exist build  name_template.c
  %----------------------------------------------------
  [okay,errtext,filelistio] = build_embedded_io_code(q);
  if( ~okay )
    error('errr: %s',errtext);
  end
  filelist = cell_add(filelist,filelistio);
  
  % build c-make File and put it into path ../q.target_path
  %----------------------------------------------------
  [okay,errtext] = build_embedded_cmake(q,filelist);
  if( ~okay )
    error('errr: %s',errtext);
  end
  
  % copy filelist to another target path
  if( ~isempty(q.target_path_to_copy) )
    fprintf('--> Start Copy Files to copy_path: %s \n',q.target_path_to_copy);
    [okay,errtext] = copy_filelist_to_path(filelist,q.target_path_to_copy);
    if( ~okay )
      error('errr: %s',errtext);
    end
    fprintf('<-- End  Copy Files to copy_path: %s \n',q.target_path_to_copy);
  end
  
end
%========================================================================
%========================================================================
% functions
%========================================================================
%========================================================================
function [okay,errtext] = build_embedded_code_source_prepare_model(q)
  okay    = 1;
  errtext = '';
  
  fprintf('--> Start Prepare Model\n');
  
  
  % delete slprj-path because of problems when changing PortableWordSizes
  slprj_path = fullfile(q.module_path,'slprj');
  if( exist(slprj_path,'dir') )
    
    path_origin = pwd;
    cd(q.module_path)
    
    [status,result] = dos('rmdir /Q /S slprj');
    if( status )
      warning(result);
    end
    
    cd(path_origin)
  end

  % Set some parameters within in the model, that are necessary for correct built
  % Open system
  open_system(q.module_name,'loadonly');                                
  % Functions that can have multiple callers are moved to shared location
  set_param(q.module_name,'UtilityFuncGeneration','Shared location');
  % The following option moves constant parameters to data file instead of
  % separate file const_params.c
  set_param(q.module_name,'GenerateSharedConstants','Off');
  
  if( q.build_run_task )
   % for compiling in a run task for linux Macro PORTABLE_WORDSIZES is used
   % to switch off check about 64 bit variable
   set_param(q.module_name,'PortableWordSizes','On');
  end    
  % Save system
  save_system(q.module_name);
  % Close system
  close_system(q.module_name);

  fprintf('<-- End Prepare Model\n');
end
function [okay,errtext] = build_embedded_code_source_revert_parameter_model(q)
  okay    = 1;
  errtext = '';
  
  if( q.build_run_task )
    fprintf('--> Start Revert Parameter in Model\n');

    % ReSet some parameters within in the model, 
    % Open system
    open_system(q.module_name,'loadonly');                                
  
     % for compiling in a run task for linux Macro PORTABLE_WORDSIZES is used
     % to switch off check about 64 bit variable
     set_param(q.module_name,'PortableWordSizes','Off');
    % Save system
    save_system(q.module_name);

    fprintf('<-- End Revert Parameter Model\n');
  end    
end
function [okay,errtext] = build_embedded_code_source_build_model(q,suffix)
  okay    = 1;
  errtext = '';
  
  testBerthold = 1.234;
  assignin('base', 'testBerthold', testBerthold);
  
  fprintf('--> Start Build Model (%s:%s)\n',q.module_name,char(suffix));
  
  % Intialize parameter file
  evalin('base',[q.module_name,'_init_',char(suffix)]);
  
  % Build code
  rtwbuild(q.module_name)
    
  fprintf('<-- End Build Model (%s:%s)\n',q.module_name,char(suffix));

end
function [okay,errtext,sfile] = build_embedded_copy_data_source(q,suffix,isuffix)
  okay    = 1;
  errtext = '';
  sfile   = '';
  
  fprintf('--> Start copy parameter-data source (%s:%s)\n',q.module_name,char(suffix));
  
  [okay,errtext,cfilename] = build_embedded_copy_data_source_find_data_c_file(q);
  if( ~okay )
    return;
  end
                    
  sfile = fullfile(q.target_path,[q.module_name,'_data_',char(suffix),'.c']);
      
  % spezifisch für runtask bilden
  % Umbenennen der Parameter und speichern
  if( q.build_run_task )
        
    [q,okay,errtext] = build_embedded_copy_data_source_rename_parname_and_save(q,cfilename,num2str(isuffix));
    if( ~okay )
      return;
    end                
        
  end

  movefile(cfilename,sfile);

  % remove temp dir
  %----------------
  % rmdir(q.temp_path);
  
  fprintf('<-- End copy parameter-data source (%s:%s)\n',q.module_name,char(suffix));
end
function [okay,errtext,cfilename] = build_embedded_copy_data_source_find_data_c_file(q)
  okay    = 0;
  errtext = 'no file found';
  cfilename = '';
  % build temporary output path
  [status,message,~] = mkdir(q.temp_path);
  if( status == 0 )
    errtext = message;
    okay    = 0;
    return
  end
  
  % build zipfilename
  zipfilename = [q.module_name,'.zip'];
  
  
  filenames = unzip(zipfilename,q.temp_path);
  
  nfiles = length(filenames);
  
  for i=1:nfiles
        
    s_file = str_get_pfe_f(filenames{i});
    
    if( strcmpi(s_file.body,[q.module_name,'_data']) )
      cfilename = filenames{i};
      okay = 1;
      errtext = '';
      return;
    end
  end
end

function [okay,errtext,filelist] = finish_build_embedded_copy_data_source(q,filelist)

  okay    = 1;
  errtext = '';
  
  fprintf('--> Start final build data-file \n');
  % get distribution of data by vehicle-ini-file
  % and write to target_path
  %---------------------------------------------
  if( q.build_run_task )
    [okay,errtext,c] = build_embedded_code_get_data_c_file_run_task(q);
  else
    [okay,errtext,c] = build_embedded_code_get_data_c_file(q);
  end
  
  if( ~okay )
    return;
  end
  
  f = fullfile(q.target_path,[q.module_name,'_data.c']);
  okay = write_ascii_file(f,c);
  if( ~okay )
    errtext = sprintf('write_ascii_file(%s,c) did not work',f);
  end
  
  filelist = cell_add(filelist,f);
  
  fprintf('<-- End final build data-file \n');
end
function [okay,errtext,filelist] = build_embedded_code_source_copy_source(q,filelist)
  okay    = 1;
  errtext = '';
  
  fprintf('--> Start Copy all other source\n');
  
  % build temporary output path
  [status,message,~] = mkdir(q.temp_path);
  if( status == 0 )
    errtext = message;
    okay    = 0;
    return
  end
  
  % build zipfilename
  zipfilename = [q.module_name,'.zip'];
  
  
  filenames = unzip(zipfilename,q.temp_path);
  
  nfiles = length(filenames);
  
  % get necessary file list
  filelistsrc = {};
  filelistdst = {};
  for i=1:nfiles
    s_file = str_get_pfe_f(filenames{i});
    %don't copy data-file, but all c- and h-files and not to exclude
    ifound = cell_find_f(q.exclude_files,s_file.filename,'fl');
    if( isempty(ifound) ) % not found
      flag = 1;
    else
      flag = 0;
    end
    
    if(  ~strcmpi(s_file.body,[q.module_name,'_data']) ...
      && flag ...
      && (strcmpi(s_file.ext,'c') || strcmpi(s_file.ext,'h')) ...
      )

      srcfile = fullfile(s_file.dir,s_file.filename);
      filelistsrc = cell_add(filelistsrc,srcfile);
      dstfile = fullfile(q.target_path,s_file.filename);
      filelistdst = cell_add(filelistdst,dstfile);
    end
  end  
  nfiles = length(filelistsrc);

  % copy  files  from temp-path to src-path
  %----------------------------------------
  for i=1:nfiles
        
    s_file = str_get_pfe_f(filelistsrc{i});
    
    %don't copy data-file, but all c- and h-files    
    if(  ~strcmpi(s_file.body,[q.module_name,'_data']) ...
      && (strcmpi(s_file.ext,'c') || strcmpi(s_file.ext,'h')) ...
      )

      movefile(filelistsrc{i},filelistdst{i});
    
    end
    
  end
  
  % search in c-, h-File for functionnames which hav to be changed
  % to get a unique function name
  %----------------------------------------------------------------
  [okay,errtext,filelistnew] = build_embedded_code_source_change_name_in_source(q,filelistdst);
  if( ~okay )
    return
  end

  filelist = cell_add(filelist,filelistnew);
      
  fprintf('<-- End Copy all other source\n');
end
function [okay,errtext,c] = build_embedded_code_get_data_c_file_run_task(q)

  [okay,errtext,cfilename] = build_embedded_copy_data_source_find_data_c_file(q);
  if( ~okay )
    return;
  end

  [ okay,c,~ ] = read_ascii_file(cfilename);
  if( ~okay )
    errtext = sprintf('File <%s> could not be read',cfilename);
    return;
  end
  
  % Now add lines for the other vehicles
  for i = 1:q.n_vehicle_table
      c = cell_add(c,['  #include "',q.module_name,'_data_',char(q.suffix_names{i}),'.c"']);   
  end

end
function [okay,errtext,c] = build_embedded_code_get_data_c_file(q)

  okay = 1;
  errtext = '';
  
  % find relative path of vehicle_type.h
  s = get_abs_rel_path(q.target_path,q.vehicle_type_path,1);
  
  c = {};
  % fill carray
  c = cell_add(c,['// This file replaces the original ', q.module_name,'_data.c']);
  c = cell_add(c,'// The correct parameters are chosen depending on the settings in overall');
  c = cell_add(c,'// setup in vehicle_type.h in project_folder\\platform_sw\\rpecu.');
  c = cell_add(c,'');
  c = cell_add(c,['#include "',s.rel_dir,'/vehicle_type.h"']);
  c = cell_add(c,'');
  c = cell_add(c,['#if (TARGET_VEHICLE == ',char(q.target_names{1}),')']);
  c = cell_add(c,['  #include "',q.module_name,'_data_',char(q.suffix_names{1}),'.c"']);

  % Now add lines for the other vehicles
  for i = 2:q.n_vehicle_table
      c = cell_add(c,['#elif (TARGET_VEHICLE == ',char(q.target_names{i}),')']);
      c = cell_add(c,['  #include "',q.module_name,'_data_',char(q.suffix_names{i}),'.c"']);   
  end

  c = cell_add(c,'#else');
  c = cell_add(c,'');
  c = cell_add(c,['  #error "Target vehicle not supported by Module: ',q.module_name,'"']);
  c = cell_add(c,'');
  c = cell_add(c,'#endif');

  
end
function [okay,errtext,filelist] = build_embedded_code_source_change_name_in_source(q,filelist)

  okay = 1;
  errtext = '';
  
  n = length(filelist);
 
  % find all function names
  %------------------------
  liste = {};              % Liste der Funktinsnamen
  filebodynamelist = {};   % Liste der Files (Rumpf)
  for i=1:n
    
    s_file = str_get_pfe_f(filelist{i});
    if( strcmpi(s_file.ext,'c') )
      
      [ okay,c,~ ] = read_ascii_file(filelist{i});
      if( ~okay )
        errtext = sprintf('File <%s> could not be read',filelist{i});
        return;
      end
      t = cell_str_build_text(c,1);
      l = c_code_find_function_names(t);
      
      if( ~isempty(l) )
        
        liste = cell_add(liste,l);
        % add filename to filebodynamelist
        for j=1:length(l)
          if( str_find_f(l{j},q.module_name,'v') == 0 )
           
            if( isempty(cell_find_f(filebodynamelist,s_file.body,'fl')) )
               filebodynamelist = cell_add(filebodynamelist,s_file.body);
            end
          end
        end
            
      end
    end
  end
  
  % filter out the functions which contains already modul_name
  % l1 old function name
  % l2 new function name
  %-----------------------------------------------------------
  l1 = {};
  l2 = {};
  for i=1:length(liste)
    if( str_find_f(liste{i},q.module_name,'v') == 0 )
      l1 = cell_add(l1,liste{i});
      l2 = cell_add(l2,[q.module_name,'_',liste{i}]);
    end
  end
  
  % look with filebodynames if h-Files which will be changed and 
  % and not in the list, take them
  for i=1:length(filelist)
    
    s_file = str_get_pfe_f(filelist{i});
    if( strcmp(s_file.ext,'h') ) % it is a h-File
      if( ~isempty(cell_find_f(filebodynamelist,s_file.body,'fl')) ) % body of file is detected
        if( isempty(cell_find_f(l1,s_file.body,'fl')) )              % is not in l1 list
          
           l1 = cell_add(l1,s_file.body);
           l2 = cell_add(l2,[q.module_name,'_',s_file.body]);
        end
      end
    end
    
  end  
      
  nl = length(l1);
  
  % find in all files listed function names and change it into
  % modul_name added function names
  for i=1:length(filelist)
    [ okay,c,~ ] = read_ascii_file(filelist{i});
    if( ~okay )
      errtext = sprintf('File <%s> could not be read',filelist{i});
      return;
    end
    t = cell_str_build_text(c,1);
    
    for j=1:nl      
      [t,~] = c_code_change_word(t,l1{j},l2{j});  
    end
        
    c = str_build_cell_text(t);
    okay = write_ascii_file(filelist{i},c);
    if( ~okay )
      errtext = sprintf('File <%s> could not be written',filelist{i});
      return;
    end
  end
  
%   for i=1:length(filelist)
%       
%     s_file = str_get_pfe_f(filelist{i});
%     
%     for j=1:nl
%       if( strcmp(s_file.name,l1{j}) )
%         s_file.name = l2{j};
%         sfile = str_set_pfe_f(s_file);
%         movefile(filelist{i},sfile);
%         filelist{i} = sfile;
%         break;
%       end
%     end
%   end
  
  % rename file name if it is the old function name
  for i=1:length(filebodynamelist)      
    body = filebodynamelist{i};
    for j=1:length(filelist)
     s_file = str_get_pfe_f(filelist{j});
     if( strcmpi(s_file.body,body) )
       s_file.name = [q.module_name,'_',body];
       s_file.body = [q.module_name,'_',body];
       sfile = str_set_pfe_f(s_file);
       movefile(filelist{j},sfile);
       filelist{j} = sfile;
     end
    end
  end
  
end
function [okay,errtext,filelist] = build_embedded_io_code(q)
%   q.PRE_NAME_STRUCT_INPUT            
%   q.PRE_NAME_STRUCT_OUTPUT           
%   q.POST_NAME_STRUCT_VARIABLE_INPUT  
%   q.POST_NAME_STRUCT_VARIABLE_OUTPUT 
%   q.POST_NAME_FUNCTION_INIT_CALL          
%   q.POST_NAME_FUNCTION_LOOP_CALL     
%   q.POST_NAME_FUNCTION_NAME_INTERFACE         
%   q.POST_NAME_FUNCTION_NAME_INIT    
%   q.POST_NAME_FUNCTION_NAME_LOOP  

  fprintf('--> Start build io-files\n');


  interface_file_name = [q.module_name,q.POST_NAME_FUNCTION_NAME_INTERFACE];
  include_file_name   = [q.module_name];
  init_func_name    = [q.module_name,q.POST_NAME_FUNCTION_NAME_INIT];
  init_func_call    = [q.module_name,q.POST_NAME_FUNCTION_INIT_CALL];
  loop_func_name    = [q.module_name,q.POST_NAME_FUNCTION_NAME_LOOP];
  loop_func_call    = [q.module_name,q.POST_NAME_FUNCTION_LOOP_CALL];
  param_func_name   = [q.module_name,q.POST_NAME_FUNCTION_NAME_PARAM];
  param_copy_func_name   = [q.module_name,q.POST_NAME_FUNCTION_NAME_COPY_PARAM];

  okay    = 1;
  errtext = '';
  
  
  filelist = {};
  
  % h-file with struct definintion
  %-------------------------------
  modul_data_h_file = fullfile(q.target_path,[q.module_name,'.h']);
  if( ~exist(modul_data_h_file,'file') )
    errtext = sprintf('build_embedded_io_code: modul_data_h_file: <%s> does not exist',modul_data_h_file);
    okay = 0;
    return
  end

  % get input and out structure
  %----------------------------
  [ okay,c,~ ] = read_ascii_file(modul_data_h_file);
  if( ~okay )
    errtext = sprintf('File <%s> could not be read',modul_data_h_file);
    return;
  end
  t = cell_str_build_text(c,1);

  % input
  structname = [q.PRE_NAME_STRUCT_INPUT,q.module_name];
  varname    = [q.module_name,q.POST_NAME_STRUCT_VARIABLE_INPUT];
  sin = c_code_find_struct(t,structname,varname);      
  % output
  structname = [q.PRE_NAME_STRUCT_OUTPUT,q.module_name];
  varname    = [q.module_name,q.POST_NAME_STRUCT_VARIABLE_OUTPUT];
  sout = c_code_find_struct(t,structname,varname);
  

  if( isempty(sout) )
    errtext = sprintf('build_embedded_io_code: no output varibale found');
    okay = 0;
    return
  end
  
  % build cellaray with code interface c-file
  c = build_embedded_code_get_interface_c_file(q,interface_file_name ...
                                              ,include_file_name ...
                                              ,init_func_name ...
                                              ,init_func_call ...
                                              ,loop_func_name ...
                                              ,loop_func_call ...
                                              ,sin,sout ...
                                              ,q.build_run_task,q.target_names ...
                                              ,param_func_name,param_copy_func_name ...
                                              );
  % interface c-file       
  if( q.intface_type == q.C_FILE_TYPE)
    filename = fullfile(q.target_path,[interface_file_name,'.c']);
  else
    filename = fullfile(q.target_path,[interface_file_name,'.cpp']);
  end
  filelist = cell_add(filelist,filename);
  
  % if exist change to template
  if( exist(filename,'file') )
    if( q.intface_type == q.C_FILE_TYPE)
      filename = fullfile(q.target_path,[interface_file_name,'_template.c']);
    else
      filename = fullfile(q.target_path,[interface_file_name,'_template.cpp']);
    end
    filelist = cell_add(filelist,filename);
  end
                                            
  okay = write_ascii_file(filename,c);
  if( ~okay )
    errtext = sprintf('write_ascii_file(%s,c) did not work',filename);
  end

  % interface h-file                                            
  c = build_embedded_code_get_interface_h_file(q,interface_file_name ...
                                              ,init_func_name ...
                                              ,loop_func_name ...
                                              ,param_func_name ...
                                              ,param_copy_func_name ...
                                              );
    
  % interface h-file                                            
  filename = fullfile(q.target_path,[interface_file_name,'.h']);
  filelist = cell_add(filelist,filename);

  % if exist change to
  if( exist(filename,'file') )
    filename = fullfile(q.target_path,[interface_file_name,'_template.h']);
    filelist = cell_add(filelist,filename);
  end
                                            
  okay = write_ascii_file(filename,c);
  if( ~okay )
    errtext = sprintf('write_ascii_file(%s,c) did not work',filename);
  end
  
  % add param_copy_func file
  %--------------------------
  if( q.build_run_task )
    % if run_task build parameter copy file
    % param copy c-file                                 
    c = build_embedded_code_get_parameter_copy_c_file(q,param_copy_func_name);
    %                                            
    filename = fullfile(q.target_path,[param_copy_func_name,'.c']);
    filelist = cell_add(filelist,filename);

                                            
    okay = write_ascii_file(filename,c);
    if( ~okay )
      errtext = sprintf('write_ascii_file(%s,c) did not work',filename);
    end

    % param copy h-file 
    c = build_embedded_code_get_parameter_copy_h_file(q,param_copy_func_name);
    %                                            
    filename = fullfile(q.target_path,[param_copy_func_name,'.h']);
    filelist = cell_add(filelist,filename);

                                            
    okay = write_ascii_file(filename,c);
    if( ~okay )
      errtext = sprintf('write_ascii_file(%s,c) did not work',filename);
    end
  end
  
  fprintf('<-- End build io-files\n');
end
function c = build_embedded_code_get_interface_c_file(q,interface_file_name,include_file_name ...
                                                     ,init_func_name,init_func_call ...
                                                     ,loop_func_name,loop_func_call ...
                                                     ,sin,sout ...
                                                     ,build_run_task,target_names ...
                                                     ,param_func_name,param_copy_func_name ...
                                                     )
  varmax = 0;
  for i=1:length(sin)
    varmax = max(varmax,length(sin(i).varname));
  end
  for i=1:length(sout)
    varmax = max(varmax,length(sout(i).varname));
  end
  c = {};
  onetab = '  ';
  % fill carray
  c = cell_add(c,['// ',interface_file_name,'.c']);
  c = cell_add(c,'// ');
  c = cell_add(c,'// ');
  c = cell_add(c,'');
  
  if( q.intface_type == q.CPP_FILE_TYPE )
    c = cell_add(c,'#ifdef __cplusplus');
    c = cell_add(c,'extern "C" {');
    c = cell_add(c,'#endif');
    c = cell_add(c,'');
  end
  
  c = cell_add(c,['#include "',include_file_name,'.h"']);
  c = cell_add(c,['#include "',param_copy_func_name,'.h"']);
  
  if( q.intface_type == q.CPP_FILE_TYPE )
    c = cell_add(c,'');
    c = cell_add(c,'#ifdef __cplusplus');
    c = cell_add(c,'}');
    c = cell_add(c,'#endif');
  end
  c = cell_add(c,'');
  c = cell_add(c,['#include "',interface_file_name,'.h"']);
  c = cell_add(c,'');
  % param part (only for run task)
  if( build_run_task )
    c = cell_add(c,['void ',param_func_name,'(void)']);
    c = cell_add(c,'{');
    c = cell_add(c,'');
    c = cell_add(c,'// as an example:');
    c = cell_add(c,[onetab,param_copy_func_name,'(',target_names{1},');']);
    c = cell_add(c,'');
    c = cell_add(c,'}');
  end
  % init part
  c = cell_add(c,['void ',init_func_name,'(void)']);
  c = cell_add(c,'{');
  c = cell_add(c,'');
  c = cell_add(c,[onetab,init_func_call,'();']);
  c = cell_add(c,'');
  c = cell_add(c,'}');

  % loop part
  c = cell_add(c,['void ',loop_func_name,'(void)']);
  c = cell_add(c,['{']);
  c = cell_add(c,'');
  % input
  for i=1:length(sin)
    ctext = str_format(sin(i).varname,varmax,'v','l');
    c = cell_add(c,sprintf('%s%s = (%s)%s;',onetab,ctext{1},sin(i).type,sin(i).varname));
  end
  c = cell_add(c,'');
  c = cell_add(c,[onetab,loop_func_call,'();']);
  c = cell_add(c,'');
  % output
  for i=1:length(sout)
    ctext = str_format(sout(i).varname,varmax,'v','l');
    c = cell_add(c,sprintf('%s%s = %s;',onetab,ctext{1},sout(i).varname));
  end
  c = cell_add(c,'');
  c = cell_add(c,'}');
  
end
function  c = build_embedded_code_get_interface_h_file(q,interface_file_name ...
                                              ,init_func_name ...
                                              ,loop_func_name ...
                                              ,param_func_name ...
                                              ,param_copy_func_name ...
                                              )
  
  tt = upper([interface_file_name,'_h_defined']);
  c = {};
  % fill carray
  c = cell_add(c,['// ',interface_file_name,'.h']);
  c = cell_add(c,'// ');
  c = cell_add(c,'// ');
  c = cell_add(c,'');
  c = cell_add(c,['#ifndef ',tt]);
  c = cell_add(c,['#define ',tt]);
  c = cell_add(c,'');
  
  if( q.intface_type == q.C_FILE_TYPE )
    c = cell_add(c,'#ifdef __cplusplus');
    c = cell_add(c,'extern "C" {');
    c = cell_add(c,'#endif');
    c = cell_add(c,'');
  end
  
  c = cell_add(c,['void ',init_func_name,'(void);']);
  c = cell_add(c,['void ',loop_func_name,'(void);']);
  
  % add param func
  if( q.build_run_task )
    c = cell_add(c,['void ',param_func_name,'(void);']);
  end
  c = cell_add(c,'');
  
  if( q.intface_type == q.C_FILE_TYPE )
    c = cell_add(c,'#ifdef __cplusplus');
    c = cell_add(c,'}');
    c = cell_add(c,'#endif');
  end

  c = cell_add(c,['#endif  // ',tt]);
                                            
end
function c = build_embedded_code_get_parameter_copy_c_file(q,param_copy_func_name)

  c = {};
  % fill carray
  c = cell_add(c,['// ',param_copy_func_name,'.c']);
  c = cell_add(c,'// ');
  c = cell_add(c,'// ');
  c = cell_add(c,'');
  c = cell_add(c,'');
  c = cell_add(c,['#include "',q.module_name,'.h"']);
  c = cell_add(c,['#include "',param_copy_func_name,'.h"']);
  c = cell_add(c,['#include "',q.module_name,q.POST_NAME_FUNCTION_NAME_INTERFACE,'.h"']);
  c = cell_add(c,['#include "string.h"']);
  c = cell_add(c,'');
  c = cell_add(c,'');
  c = cell_add(c,['Parameters_',q.module_name,' ',q.module_name,'_P;']);
  for i=1:q.n_vehicle_table
    c = cell_add(c,['extern Parameters_',q.module_name,' ',q.module_name,'_P',num2str(i),';']);
  end
  c = cell_add(c,'');
  c = cell_add(c,'');
  c = cell_add(c,['void ',param_copy_func_name,'(enum ',q.ENUM_TARGET_NAME,' trgt)']);
  c = cell_add(c,'{');
  c = cell_add(c,['  if(trgt == ',q.target_names{1},')']);
  c = cell_add(c,'   {');
  c = cell_add(c,['     memcpy(&',q.module_name,'_P,&',q.module_name,'_P1,sizeof(Parameters_',q.module_name,'));']);
  c = cell_add(c,'   }');
  
  for i=2:q.n_vehicle_table
  c = cell_add(c,['  else if(trgt == ',q.target_names{i},')']);
  c = cell_add(c,'   {');
  c = cell_add(c,['     memcpy(&',q.module_name,'_P,&',q.module_name,'_P',num2str(i),',sizeof(Parameters_',q.module_name,'));']);
  c = cell_add(c,'   }');
  end  
  
  c = cell_add(c,['  else']);
  c = cell_add(c,'   {');
  c = cell_add(c,['     memcpy(&',q.module_name,'_P,&',q.module_name,'_P1,sizeof(Parameters_',q.module_name,'));']);
  c = cell_add(c,'   }');
  c = cell_add(c,'}');
  
  



end
function c = build_embedded_code_get_parameter_copy_h_file(q,param_copy_func_name)

  tt = upper([param_copy_func_name,'_h_defined']);
  c = {};
  % fill carray
  c = cell_add(c,['// ',param_copy_func_name,'.h']);
  c = cell_add(c,'// ');
  c = cell_add(c,'// ');
  c = cell_add(c,'');
  c = cell_add(c,['#ifndef ',tt]);
  c = cell_add(c,['#define ',tt]);
  c = cell_add(c,'');
  c = cell_add(c,'');
  c = cell_add(c,'');
  % add enum for run_task
    
   c = cell_add(c,['enum ',q.ENUM_TARGET_NAME]);
   c = cell_add(c,'{');
   for i = 1:q.n_vehicle_table
     if( i < q.n_vehicle_table )
      c = cell_add(c,['    ',q.target_names{i},' = ',num2str(i),',']);
     else
       c = cell_add(c,['    ',q.target_names{i},' = ',num2str(i)]);
     end
   end
   c = cell_add(c,['};']);
   c = cell_add(c,''); 
   
  % add param_copy_func
    if( q.intface_type == q.CPP_FILE_TYPE )
      c = cell_add(c,'#ifdef __cplusplus');
      c = cell_add(c,'extern "C" {');
      c = cell_add(c,'#endif');
    end
  
      c = cell_add(c,['void ',param_copy_func_name,'(enum ',q.ENUM_TARGET_NAME,' trgt);']);

    if( q.intface_type == q.CPP_FILE_TYPE )  
      c = cell_add(c,'');
      c = cell_add(c,'#ifdef __cplusplus');
      c = cell_add(c,'}');
      c = cell_add(c,'#endif');
    end
  
  c = cell_add(c,'');
  
  c = cell_add(c,'');
   
  c = cell_add(c,['#endif  // ',tt]);



end
function [okay,errtext] = build_embedded_cmake(q,filelist)

  okay = 1;
  errtext = '';
  
  if( q.build_cmake_file )
  
    fprintf('--> Start build cmake-file\n');
  
    sub_path = get_last_name_from_dir(q.target_path);
    path_upper = get_parent_path(q.target_path,1);


    c = build_embedded_code_get_cmake_file(filelist,q.CMAKE_FILE_NAME,q.module_name,sub_path);

    filename = fullfile(path_upper,q.CMAKE_FILE_NAME);

    okay = write_ascii_file(filename,c);
    if( ~okay )
      errtext = sprintf('write_ascii_file(%s,c) did not work',filename);
    end
    fprintf('<-- End build cmake-file\n');
  else
    fprintf('--> Don''t build cmake-file\n');
  end
    
  

end
function  c = build_embedded_code_get_cmake_file(filelist ...
                                                ,filename ...
                                                ,module_name ...
                                                ,sub_path ...
                                                )
  
  onetab = '  ';
  c = {};
  % fill carray
  
  c = cell_add(c,['# ',filename,' project ',module_name]);
  c = cell_add(c,'# ');
  c = cell_add(c,'# ');
  c = cell_add(c,'');
  c = cell_add(c,['project("',module_name,'")']);
  c = cell_add(c,'');
  c = cell_add(c,'add_library(${PROJECT_NAME} STATIC');
  % file
  for i=1:length(filelist)
    s_file = str_get_pfe_f(filelist{i});
    c      = cell_add(c,sprintf('%s%s/%s;',onetab,sub_path,s_file.filename));
  end
  c = cell_add(c,')');
  c = cell_add(c,'');
  c = cell_add(c,'install(TARGETS ${PROJECT_NAME} DESTINATION ${PROJECT_SOURCE_DIR}/lib)');
  c = cell_add(c,'');
  c = cell_add(c,'install(FILES');
  % h-file
  for i=1:length(filelist)
    s_file = str_get_pfe_f(filelist{i});
    if( strcmp(s_file.ext,'h') )
      c = cell_add(c,sprintf('%s%s/%s;',onetab,sub_path,s_file.filename));
    end
  end
  c = cell_add(c,'DESTINATION ${PROJECT_SOURCE_DIR}/include)');
  c = cell_add(c,'');
  
                                            
end
function [q,okay,errtext] = build_embedded_copy_data_source_rename_parname_and_save(q,filename,add_name)

  errtext = '';
  okay = 1;
  
  % read file
  %----------
  [ okay,c,n ] = read_ascii_file(filename);
  if( ~okay )
    errtext = sprintf('File <%s> could not be read',filename);
    return;
  end
  
  tnew = ''; % new code to save
  
  % find all lines with includes
  %-----------------------------
  for i=1:n
    
    if( str_find_f(c{i},'#include','vs') > 0 )
      tnew = [tnew,c{i},newline];
    end
  end
  % build text from c 
  %------------------
  t = cell_str_build_text(c,1);
  
 
  % find Parameter Variable
  var_name = [q.module_name,'_P'];
  i0    = str_find_word_f(t,1,var_name,'l');
  
  if( i0 )
    
    % change name of Variable
    new_var_name = [var_name,add_name];    
    t = str_replace_by_index(t,i0,length(var_name),new_var_name);
    
    % find new Parameter Variable name
    i0    = str_find_word_f(t,1,new_var_name,'l');
    
    
    % find end of data-structure
    i1 = str_find_index_f(t,i0,'v','};');
    
    % find from their the beginning of line
    i00 = str_find_index_f(t,i0,'r',newline);
    
       
    % add new variable structure to tnew
    if( i00 && i1 )
            
      tnew = [tnew,newline,t(i00+1:i1+1),newline];
    end
    
  end
  
  
  % build cell array from new text
  %------------------------------
  c = str_build_cell_text(tnew);
  
  % write acsii-File
  %-----------------
  okay = write_ascii_file(filename,c);
  if( ~okay )
    errtext = sprintf('File <%s> could not be written',filename);
    return;
  end

end
