function e = e_data_modify_by_script(e,fullfile_m_script)
%
% e = e_data_modify_by_script(e)
%
% Modify Date by a script: Aufruf e = mod_my_edata(e);
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...

  
  if( ~exist('e','var') )
    [e,f] = e_data_read_mat_save_path();
  else
    f = '';
  end
  
  if( ~exist('fullfile_m_script','var' ) )
    flag_script = 0;
  else
    if( ~exist(fullfile_m_script,'file') )
      flag_script = 0;
    else
      flag_script = 1;
    end
  end
  
  if( ~isempty(e) )
    
    if( ~flag_script )
      s_frage        = ' modify-m-file with e = mod_my_edata(e)';
      s_frage.file_spec='*.m';
      s_frage.file_number=1;
     [okay,c_filenames] = o_abfragen_files_f(s_frage); 

     dir_name = get_path_from_fullfilename(c_filenames{1});
     body_name = get_file_name(c_filenames{1},1);
    else
     dir_name = get_path_from_fullfilename(fullfile_m_script);
     body_name = get_file_name(fullfile_m_script,1);
      
    end
   dir_org = pwd;
   
    if( ~isempty(dir_name) )
      if( ~exist(dir_name,'dir') )
        error('Das Verzeichnis <%s> exisistiert nicht !', dir_name);
      else
        cd(dir_name);
      end
    end
    try
      eval(['e=',body_name,'(e);']);
      fprintf('%s\n',['e=',body_name,'(e);']);
    catch exception
     cd(dir_org);
     throw(exception)
    end
    cd(dir_org);
    
    if( exist(f,'file') )
      eval(['save ''',f,''' e']);
    end
  end
end

