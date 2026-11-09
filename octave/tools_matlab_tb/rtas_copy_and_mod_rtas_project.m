function [okay,errtext] = rtas_copy_and_mod_rtas_project(q)
%
% [okay,errtext] = copy_and_mod_rtas_project(q)
%
% q.rtas_mod_src_dir              = 'D:\VPU_HAF\rtas';          % Source: rtas-dir mit den Modellen
% q.rtas_mod_trg_dir              = 'D:\VPU\rtas';              % Target: rtas-dir mit den Modellen
% q.rtas_app_src_dir              = 'D:\VPU_HAF\rtas';          % Source: rtas-dir mit dem Projekt (app-Dir)
% q.rtas_app_trg_dir              = 'D:\VPU\rtas';              % Target: rtas-dir mit dem Projekt (app-Dir)
% q.vpu_src_dir                   = 'D:\VPU_HAF\VPU4_CG_IQF';   % Source: vpu-dir 
% q.vpu_trg_dir                   = 'D:\VPU\VPU4_CG_IQF';       % Target: vpu-dir
%               
% q.rtas_ssw_platform             = 'vpu-cg';     % "PAM Platform name" in ssw-Manager
% q.rtas_project_name             = 'vpu4';       % Platform-Application-Manager: "Project name"
% q.rtas_modul                    = {'iqf'};      % Linkname im Platform-Application-Manager für RTAS-Modul (Linked RTAS-Modules)
% 
% q.copy_vpu                      = 0;            % Soll VPU-Verzeichnis kopiert werden
% q.copy_mod                      = 1;            % Sollen Modelle kopiert werden
% q.copy_app                      = 1;            % Soll das Projekt kopiert werden und die Pfade an das target angepasst werden
%

  okay    = 1;
  errtext = '';
  %==========================================================================
  % Model-Dir
  %----------------
  if( ~check_val_in_struct(q,'rtas_mod_src_dir','char',1) )
    error('input q.rtas_mod_src_dir nicht gesetzt (see help %s)',mfilename);
  end
  if( ~exist(q.rtas_mod_src_dir,'dir') )
    error('%s: input q.rtas_mod_src_dir=''%s'' wrong (see help %s)',mfilename,q.rtas_mod_src_dir);
  end
  if( ~check_val_in_struct(q,'rtas_mod_trg_dir','char',1) )
    error('input q.rtas_mod_trg_dir nicht gesetzt (see help %s)',mfilename);
  end

  %==========================================================================
  % app-Dir (project)
  %------------------
  if( ~check_val_in_struct(q,'rtas_app_src_dir','char',1) )
    error('input q.rtas_app_src_dir nicht gesetzt (see help %s)',mfilename);
  end
  if( ~exist(q.rtas_app_src_dir,'dir') )
    error('%s: input q.rtas_app_src_dir=''%s'' wrong (see help %s)',mfilename,q.rtas_app_src_dir);
  end
  if( ~check_val_in_struct(q,'rtas_app_trg_dir','char',1) )
    error('input q.rtas_app_trg_dir nicht gesetzt (see help %s)',mfilename);
  end
  
  %==========================================================================
  % vpu-Dir
  %--------
  if( ~check_val_in_struct(q,'vpu_src_dir','char',1) )
    error('input q.vpu_src_dir nicht gesetzt (see help %s)',mfilename);
  end
  if( ~exist(q.vpu_src_dir,'dir') )
    error('%s: input q.vpu_src_dir=''%s'' wrong (see help %s)',mfilename,q.vpu_src_dir);
  end
  if( ~check_val_in_struct(q,'vpu_trg_dir','char',1) )
    error('input q.vpu_trg_dir nicht gesetzt (see help %s)',mfilename);
  end
  
  % RTAS-SSW environment
  %-------------------------------------------------------------------
  % q.rtas_ssw_platform     char    yes       RTAS-SSW-Platform bisher nur vpu defaut:'vpu-cg';
  if( ~check_val_in_struct(q,'rtas_ssw_platform','char',1) )
    q.rtas_ssw_platform = 'vpu-cg';
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
  
   % q.copy_vpu                      = 0;            % Soll VPU-Verzeichnis kopiert werden
  if( ~check_val_in_struct(q,'copy_vpu','num',1) )
      q.copy_vpu = 0;
  end
  % q.copy_mod                      = 1;            % Sollen Modelle kopiert werden
  if( ~check_val_in_struct(q,'copy_mod','num',1) )
      q.copy_mod = 0;
  end
  % q.copy_app                      = 1;            % Soll das Projekt kopiert werden und die Pfade an das target angepasst werden
  if( ~check_val_in_struct(q,'copy_app','num',1) )
      q.copy_app = 0;
  end
  
  
  % Project-dir
  %=======================
  q.rtas_proj_src_dir = fullfile(q.rtas_app_src_dir,'app',q.rtas_ssw_platform,'prj',q.rtas_project_name);
  if( ~exist(q.rtas_proj_src_dir,'dir') )
    error('%s: Project-Dir q.rtas_proj_src_dir=''%s'' wrong (see help %s)',mfilename,q.rtas_proj_src_dir);
  end
  q.rtas_proj_trg_dir = fullfile(q.rtas_app_trg_dir,'app',q.rtas_ssw_platform,'prj',q.rtas_project_name);
  
  [okay,message] = check_and_create_dir(q.rtas_proj_trg_dir);
  if( ~okay )
    error('%s: %s',mfilename,message);
  end
  
  % Zu ersstzender Text
  %===========================
  find_text   = {q.rtas_proj_src_dir,q.rtas_mod_src_dir,q.vpu_src_dir};
  ersatz_text = {q.rtas_proj_trg_dir,q.rtas_mod_trg_dir,q.vpu_trg_dir};
    
  
  % Kopieren des Projekts (aus app)
  if( q.copy_app )
      
      [file_list,n_file_list] = suche_files_f(q.rtas_proj_src_dir,'*',1,0);
      
      for i=1:n_file_list
          
          src_file = file_list(i).full_name;
          trg_file = fullfile_change_dir(src_file,q.rtas_proj_trg_dir,q.rtas_proj_src_dir);
          
          t_ext    = file_list(i).ext;
          
          ifound = cell_find_f({'map','lcf','txt','prj','rml','mak','c','h'},t_ext,'f');
          
          [okay,message] = check_and_create_dir(fullfile_get_dir(trg_file));
          if( ~okay )
            error('%s: %s',mfilename,message);
          end
          
          if( isempty(ifound) ) % nicht gefunden nur kopieren
            [okay,mess] =  copy_file(src_file,trg_file);
            if( ~okay )
              error('%s: %s',mfilename,mess);
            end
          else
            [okay,mess] = change_text_in_new_file(src_file,trg_file,find_text,ersatz_text,1);
            if( ~okay )
              error('%s: %s',mfilename,mess);
            end
          end
      end
  end

  % Kopieren des model-idrs
  if( q.copy_mod )

    for j=1:length(q.rtas_modul)
      
      src_dir = fullfile(q.rtas_mod_src_dir,'mod',q.rtas_modul{j});
      trg_dir = fullfile(q.rtas_mod_trg_dir,'mod',q.rtas_modul{j});
      
      [file_list,n_file_list] = suche_files_f(src_dir,'*',1,0);
      
      for i=1:n_file_list
          
          src_file = file_list(i).full_name;
          trg_file = fullfile_change_dir(src_file,trg_dir,src_dir);
          [okay,message] = check_and_create_dir(fullfile_get_dir(trg_file));
          if( ~okay )
            error('%s: %s',mfilename,message);
          end
          copy_file(src_file,trg_file);
      end
    end
  end
  
  % Kopieren des vpu-dirs
  if( q.copy_vpu )
      
      [file_list,n_file_list] = suche_files_f(q.vpu_src_dir,'*',1,0);
      
      for i=1:n_file_list
          
          src_file = file_list(i).full_name;
          trg_file = fullfile_change_dir(src_file,q.vpu_trg_dir,q.vpu_src_dir);
          
          t_ext    = file_list(i).ext;
          
          ifound = cell_find_f({'map','lcf','txt','prj','rml','rmll','mak','data','sswh','descr''c','h'},t_ext,'f');
          
          i0     = str_find_f(fullfile_get_dir(src_file),'.rtas_asap_ssw');
          
          [okay,message] = check_and_create_dir(fullfile_get_dir(trg_file));
          if( ~okay )
            error('%s: %s',mfilename,message);
          end
          
          if( ~isempty(ifound) && i0 > 0 ) % nicht gefunden nur kopieren
            [okay,mess] = change_text_in_new_file(src_file,trg_file,find_text,ersatz_text,1);
            if( ~okay )
              error('%s: %s',mfilename,mess);
            end
          else
            [okay,mess] =  copy_file(src_file,trg_file);
            if( ~okay )
              error('%s: %s',mfilename,mess);
            end
          end
      end
  end
end
