function q = build_vcproj_for_mex_Simulation_collect(q)


  %==========================================================================
  % Pfade anlegen
  %==========================================================================
  q.proj_source_dir = fullfile(q.proj_dir,'src');
  
  build_dir(q.proj_dir,1);
  build_dir(q.proj_source_dir,1);
  
  %==========================================================================
  % source_files_to_copy
  %==========================================================================
  
  % Liste der Files die für die Steuerung der Funktion aus allg/src
  % gebraucht werden
  q.source_files_to_copy_add = build_vcproj_for_mex_sim_source_files_to_copy_add(q);

  q = build_vcproj_for_mex_sim_source_files_to_copy(q);

  %==========================================================================
  % source_files
  %==========================================================================
  % Liste der Files add (= interne festgelegte Files z.B. für vpu)
  q.source_files_add = build_vcproj_for_mex_sim_source_files_add(q);

  q = build_vcproj_for_mex_sim_source_files(q);
  
  %==========================================================================
  % include_dirs
  %==========================================================================
  q.include_dirs_add = build_vcproj_for_mex_sim_include_dirs_add(q);

  q = build_vcproj_for_mex_sim_include_dirs(q);
  
  %==========================================================================
  % preprocess_defs
  %==========================================================================
  q.preprocess_defs_add = build_vcproj_for_mex_sim_preprocess_defs_add(q);

  q = build_vcproj_for_mex_sim_preprocess_defs(q);
  
  %==========================================================================
  % lib_files
  %==========================================================================
  q.lib_files_add = {'libmex.lib' ...
                    ,'libmx.lib' ...
                    ,'libmat.lib' ...
                    };
  q = build_vcproj_for_mex_sim_lib_files(q);
  
  %==========================================================================
  % lib_dirs
  %==========================================================================
  q.lib_dirs_add = {fullfile(q.matlab_dir,'extern\lib\win32\microsoft') ...
                   ,fullfile(q.matlab_dir,'extern\lib\win32\microsoft\msvc60') ...
                   };
  q = build_vcproj_for_mex_sim_lib_dirs(q);
  


end
%==========================================================================
% build_vcproj_for_mex_sim_source_files_to_copy_add
%==========================================================================
function source_files_to_copy_add = build_vcproj_for_mex_sim_source_files_to_copy_add(q)

  if( strcmp(q.type,'can_full') )
    source_files_to_copy_add = {{fullfile(q.src_copy_dir,'fkt_VPU_CAN_SIM.c'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'fkt_VPU_CAN_SIM.h'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'mex_VPU_CAN_SIM.cpp'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'Mytypes.h'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'IdentLine.cpp'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'IdentLine.h'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'ReadCanAscii.cpp'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'ReadCanAscii.h'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'sim_VPU_CAN_SIM.cpp'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'sim_VPU_CAN_SIM.h'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'SlfBasic.h'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'stl.h'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'StrHelp.h'),'src'} ...
                                 ,{fullfile(q.src_copy_dir,'can_drv.c'),'vpu'} ... 
                                 };
  elseif( strcmp(q.type,'modul') )
    source_files_to_copy_add = {{fullfile(q.src_copy_dir,'mex_MODUL_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'sim_MODUL_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'sim_MODUL_SIM.h'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'fkt_MODUL_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'fkt_MODUL_SIM.h'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'SlfBasic.h'),'src'} ...
                               };
  elseif( strcmp(q.type,'emodul') )
    source_files_to_copy_add = {{fullfile(q.src_copy_dir,'mex_EMODUL_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'sim_EMODUL_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'sim_EMODUL_SIM.h'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'fkt_EMODUL_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'fkt_EMODUL_SIM.h'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'SlfBasic.h'),'src'} ...
                               };
  elseif( strcmp(q.type,'time_step') )
    source_files_to_copy_add = {{fullfile(q.src_copy_dir,'mex_TIME_STEP_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'sim_TIME_STEP_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'sim_TIME_STEP_SIM.h'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'fkt_TIME_STEP_SIM.cpp'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'fkt_TIME_STEP_SIM.h'),'src'} ...
                               ,{fullfile(q.src_copy_dir,'SlfBasic.h'),'src'} ...
                               };
  else
    source_files_to_copy_add = {};
  end
end
%==========================================================================
% build_vcproj_for_mex_sim_source_files_to_copy
%==========================================================================
function q = build_vcproj_for_mex_sim_source_files_to_copy(q)

  % q.source_files_to_copy_add
  % Filter für visual C vervollständigen
  %--------------------------------------------
  if( ~check_val_in_struct(q,'source_files_to_copy_add','cell',0) )
    q.source_files_to_copy_add = {};
  else
    for i=1:length(q.source_files_to_copy_add)
      if( ischar(q.source_files_to_copy_add{i}) )
        q.source_files_to_copy_add{i} = {q.source_files_to_copy_add{i},q.VC_FILTER_NAME};
      elseif( iscell(q.source_files_to_copy_add{i}) && (length(q.source_files_to_copy_add{i}) == 1) )
        q.source_files_to_copy_add{i} = {q.source_files_to_copy_add{i}{1},q.VC_FILTER_NAME};
      end
    end
  end
  
  % einzelne Liste erstellen
  source_file_to_copy_file = cell(1,length(q.source_file_to_copy));
  for i = 1:length(q.source_file_to_copy)
    source_file_to_copy_file{i} = q.source_file_to_copy{i}{1};
  end
  
  % einzelne Liste erstellen
  source_files_file = cell(1,length(q.source_files));
  for i = 1:length(q.source_files)
    source_files_file{i} = q.source_files{i}{1};
  end
                           
  % q.source_file_to_copy vervollständigen
  for i = 1:length(q.source_files_to_copy_add)
    [ifound,ipos] = cell_find_f(source_file_to_copy_file,q.source_files_to_copy_add{i}{1},'nl');
    if( isempty(ifound) )
      q.source_file_to_copy = cell_add(q.source_file_to_copy,{q.source_files_to_copy_add{i}});
    end
  end
  
  % q.source_file_to_copy kopieren
  for i = 1:length(q.source_file_to_copy)
    
    sfile = q.source_file_to_copy{i}{1};
    tfile = fullfile_change_dir(sfile,q.proj_source_dir);
    
    % Kopieren, wenn Datum neuer oder nicht vorhanden
    if( (str_find_f(tfile,'fkt_') > 0) && exist(tfile,'file') )
      copy_backup(tfile,'_bak');
    end
    [okay,message,copy_flag] = copy_file_if_newer(sfile,tfile,0,1);
    if( ~okay )
      error('%s_error: %s',mfilename,message);
    end
    % Wenn kopiert wurde, dann q.VAR_PROJ_NAME ersetzten
    if( copy_flag )
      t_file = str_get_pfe_f(tfile);
      
      [okay,c,nc] = read_ascii_file(tfile);
      if( ~okay )
        error('%s_error: Datei %s konnte nicht eingelsen werden',mfilename,sfile);
      end
      % Projekt-Namen einsetzen
      c = cell_change(c,q.VAR_PROJ_NAME,q.proj_name);
      write_ascii_file(tfile,c);
    end
    
    % source_file in Liste einsortieren
    [ifound,ipos] = cell_find_f(source_files_file,tfile,'fl');
    if( isempty(ifound) )
      q.source_files = cell_add(q.source_files,{{tfile,q.source_file_to_copy{i}{2}}});
    end
  end
    
end
%==========================================================================
% build_vcproj_for_mex_sim_source_files_add
%==========================================================================
function source_files_add = build_vcproj_for_mex_sim_source_files_add(q)
  
  source_files_add = {};
  
  if( q.use_vpu_code )

    pfilter = 'vpu';
    
    % alle C-Files aus ide/visual 
    spath    = fullfile(q.vpu_dir,'ide\visual');
    c_sub    = s_subpathes_f(spath) ;
    s_files1 = suche_files_ext(c_sub,'c');
    
    for i=1:length(s_files1)
      c = {s_files1(i).fullname,pfilter};
      source_files_add = cell_add(source_files_add,{c});
    end

    % alle restlichen C-Files aus src 
    spath    = fullfile(q.vpu_dir,'src');
    c_sub    = s_subpathes_f(spath) ;
    s_files2 = suche_files_ext(c_sub,'c');
    
    for i=1:length(s_files2)
      
      % Die c-Files in ide/visual haben vorrang
      flag = 1;
      for j=1:length(s_files1)
        if(  strcmpi(s_files2(i).name,s_files1(j).name) )
          flag = 0;
          break;
        end
      end
      
      % Prüfen, ob C-File nicht in source_files von aussen
      if( flag )
        for j=1:length(q.source_files)
          s_file_source = str_get_pfe_f(q.source_files{j}{1});
          if( strcmpi(s_files2(i).name,s_file_source.name)  ...
            && strcmpi(s_files2(i).ext,s_file_source.ext) )
            flag = 0;
            break;
          end
        end
      end
          
        
  
      if( flag )
        c = {s_files2(i).fullname,pfilter};
        source_files_add = cell_add(source_files_add,{c});
      end
    end
  end
end
%==========================================================================
% build_vcproj_for_mex_sim_source_files
%==========================================================================
function q = build_vcproj_for_mex_sim_source_files(q)

  % q.source_file_to_copy bilden, wenn nicht vorhanden
  % und Filter für visual C vervollständigen
  %--------------------------------------------
  if( ~check_val_in_struct(q,'source_files_add','cell',0) )
    q.source_files_add = {};
  else
    for i=1:length(q.source_files_add)
      if( ischar(q.source_files_add{i}) )
        q.source_files_add{i} = {q.source_files_add{i},q.VC_FILTER_NAME};
      elseif( iscell(q.source_files_add{i}) && (length(q.source_files_add{i}) == 1) )
        q.source_files_add{i} = {q.source_files_add{i}{1},q.VC_FILTER_NAME};
      end
    end
  end
  
  % einzelne Liste erstellen
  source_files_file = cell(1,length(q.source_files));
  for i = 1:length(q.source_files)
    source_files_file{i} = q.source_files{i}{1};
  end
  
 % q.source_files vervollständigen
  for i = 1:length(q.source_files_add)
    [ifound,ipos] = cell_find_f(source_files_file,q.source_files_add{i}{1},'fl');
    if( isempty(ifound) )
      if( ~exist(q.source_files_add{i}{1},'file') )
        error('%s_error: Die Datei <%s> sit nicht vorhanden !!!!!!!!!!!!',mfilename,q.source_files_add{i}{1});
      end
      q.source_files = cell_add(q.source_files,{q.source_files_add{i}});
    end
  end
    
end
%==========================================================================
% build_vcproj_for_mex_sim_include_dirs_add
%==========================================================================
function include_dirs_add = build_vcproj_for_mex_sim_include_dirs_add(q)
  if( q.use_vpu_code )
    include_dirs_add = {fullfile(q.matlab_dir,'extern\include') ...
                       ,fullfile(q.vpu_dir,'src\diag') ...
                       ,fullfile(q.vpu_dir,'ide\visual\win32\os') ...
                       ,fullfile(q.vpu_dir,'ide\visual\win32\vpu2xx') ...
                       ,fullfile(q.vpu_dir,'src\os\vpu2xx') ...
                       ,fullfile(q.vpu_dir,'src\os') ...
                       ,fullfile(q.vpu_dir,'src\elc') ...
                       ,fullfile(q.vpu_dir,'src\glob') ...
                       ,fullfile(q.vpu_dir,'src\wrp') ...
                       ,fullfile(q.vpu_dir,'src\wrp\inc_srs') ...
                       ,fullfile(q.vpu_dir,'src\actl') ...
                       ,fullfile(q.vpu_dir,'src\vdata') ...
                       ,fullfile(q.vpu_dir,'inc') ...
                       ,fullfile(q.vpu_dir,'src\sys\vpu210') ...
                       ,fullfile(q.vpu_dir,'src\sys\vpu2xx') ...
                       ,fullfile(q.vpu_dir,'src\sys') ...
                       ,fullfile(q.vpu_dir,'src\os\os_api\vpu2xx') ...
                       ,fullfile(q.vpu_dir,'src\hal') ...
                       ,fullfile(q.vpu_dir,'src\hal\ecal') ...
                       ,fullfile(q.vpu_dir,'src\hal\ecal\eep') ...
                       ,fullfile(q.vpu_dir,'src\hal\ecal\lpversion') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\irq') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\pin') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\ocdio') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\dma') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\ocebi') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\ocdri') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\ocpci') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\ocsci') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\ocadc') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\octim') ...
                       ,fullfile(q.vpu_dir,'src\hal\mcal\reg') ...
                       ,fullfile(q.vpu_dir,'src\hal\halpcb') ...
                       ,fullfile(q.vpu_dir,'src\hal\halevt') ...
                       ,fullfile(q.vpu_dir,'src\hal\halads') ...
                       ,fullfile(q.vpu_dir,'src\xcp') ...
                       ,fullfile(q.vpu_dir,'src\diag\dc_slp9_car') ...
                       ,fullfile(q.vpu_dir,'src\mon') ...
                       ,fullfile(q.vpu_dir,'src\dem') ...
                       ,fullfile(q.vpu_dir,'src\nvm') ...
                       ,fullfile(q.vpu_dir,'src\boot') ...
                       ,fullfile(q.vpu_dir,'src\meas\vpu2xx') ...
                       ,fullfile(q.vpu_dir,'src\fim') ...
                       ,fullfile(q.vpu_dir,'src\ipc\vpu2xx') ...
                       ,fullfile(q.vpu_dir,'src\flsp') ...
                       ,fullfile(q.vpu_dir,'src\flsp\vpu2xx') ...
                       ,fullfile(q.vpu_dir,'src\vdy') ...
                       ,fullfile(q.vpu_dir,'src\rtw') ...
                       };
  else                      
    include_dirs_add = {fullfile(q.matlab_dir,'extern\include')};
  end
end
%==========================================================================
% build_vcproj_for_mex_sim_include_dirs
%==========================================================================
function q = build_vcproj_for_mex_sim_include_dirs(q)

  % include_dirs bilden, wenn nicht vorhanden
  if( ~check_val_in_struct(q,'include_dirs','cell',0) )
    q.include_dirs = {};
  end
  
  % q.include_dirs mit add vervollständigen
  for i = 1:length(q.include_dirs_add)
    [ifound,ipos] = cell_find_f(q.include_dirs,q.include_dirs_add{i},'fl');
    if( isempty(ifound) )
      q.include_dirs = cell_add(q.include_dirs,q.include_dirs_add{i});
    end
  end
  
  % Build include_dirs
  for i=1:length(q.source_files)
    s_file =str_get_pfe_f(q.source_files{i}{1});
    [ifound,ipos] = cell_find_f(q.include_dirs,s_file.dir,'fl');
    if( isempty(ifound) )
      q.include_dirs = cell_add(q.include_dirs,s_file.dir);
    end
  end
    
end
%==========================================================================
% build_vcproj_for_mex_sim_preprocess_defs_add
%==========================================================================
function preprocess_defs_add = build_vcproj_for_mex_sim_preprocess_defs_add(q)
  if( q.use_vpu_code )
     preprocess_defs_add = {'WIN32' ...
                           ,'_APPL=1' ...
                           ,'MK_MASTER_MCU=1' ...
                           ,'HITACHI=1' ...
                           ,'CFG_MEAS_NOT_METHAN=1' ...
                           ,'SRS120_BRANCH=1' ...
                           };
  else
    preprocess_defs_add = {};
  end
  if( strcmp(q.type,'can_full') )
   
    preprocess_defs_add = cell_add(preprocess_defs_add,'CAN_SIM_CFG');

  elseif( strcmp(q.type,'modul') )
 
    preprocess_defs_add = cell_add(preprocess_defs_add,'SIM_CFG');
    
  elseif( strcmp(q.type,'emodul') )
 
    preprocess_defs_add = cell_add(preprocess_defs_add,'SIM_CFG');
    
  else
    preprocess_defs_add = {};
  end
end
%==========================================================================
% build_vcproj_for_mex_sim_preprocess_defs
%==========================================================================
function q = build_vcproj_for_mex_sim_preprocess_defs(q)

  % preprocess_defs bilden, wenn nicht vorhanden
  if( ~check_val_in_struct(q,'preprocess_defs','cell',0) )
    q.preprocess_defs = {};
  end
  
  % q.preprocess_defs vervollständigen
  for i = 1:length(q.preprocess_defs_add)
    [ifound,ipos] = cell_find_f(q.preprocess_defs,q.preprocess_defs_add{i},'fl');
    if( isempty(ifound) )
      q.preprocess_defs = cell_add(q.preprocess_defs,q.preprocess_defs_add{i});
    end
  end
    
end
%==========================================================================
% build_vcproj_for_mex_sim_lib_files
%==========================================================================
function q = build_vcproj_for_mex_sim_lib_files(q)

  % lib_files bilden, wenn nicht vorhanden
  if( ~check_val_in_struct(q,'lib_files','cell',0) )
    q.lib_files = {};
  end
  
  % q.lib_files vervollständigen
  for i = 1:length(q.lib_files_add)
    [ifound,ipos] = cell_find_f(q.lib_files,q.lib_files_add{i},'fl');
    if( isempty(ifound) )
      q.lib_files = cell_add(q.lib_files,q.lib_files_add{i});
    end
  end
  
end
%==========================================================================
% build_vcproj_for_mex_sim_lib_dirs
%==========================================================================
function q = build_vcproj_for_mex_sim_lib_dirs(q)

  % lib_files bilden, wenn nicht vorhanden
  if( ~check_val_in_struct(q,'lib_dirs','cell',0) )
    q.lib_dirs = {};
  end
  
  % q.lib_dirs vervollständigen
  for i = 1:length(q.lib_dirs_add)
    [ifound,ipos] = cell_find_f(q.lib_dirs,q.lib_dirs_add{i},'fl');
    if( isempty(ifound) )
      q.lib_dirs = cell_add(q.lib_dirs,q.lib_dirs_add{i});
    end
  end
  
end

