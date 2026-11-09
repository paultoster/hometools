function [okay,message] = copy_file_same_type(verz,file_spec,pre_name_add,post_name_add,new_path,new_ext)
%
% [okay,message] = copy_file_same_type(path,file_spec,pre_name_add,post_name_add,new_path,new_ext)
%
% z.B. copy_file_same_type(pwd,'*.m','','_abc')
%    => kopiert alle *.m File und fügt an dem Name '_abc' an
% z.B. copy_file_same_type(pwd,'*.m','','','d:\temp')
%    => kopiert alle *.m File in d:\temp
% z.B. copy_file_same_type(pwd,'*.m','','','','dat')
%    => kopiert alle *.m File und setzt extension .dat

  okay    = 1;
  message = '';

  % verz
  %----------
  if( isempty(verz) )
    verz = pwd;
  end
  
  % Proof verz
  %------------------
  if( ~exist(verz,'dir') )
    message = sprintf('%s: Verzeichnis <%s> nicht gefunden',mfilename,verz);
    okay    = 0;
    return
  end
  
  % file_spec
  %----------
  if( ~exist('file_spec','var') )
    file_spec = '*.*';
  end
  
  % pre_name_add
  %-------------
  if( ~exist('pre_name_add','var') )
    pre_name_add = '';
  end
  
  % post_name_add
  %---------------
  if( ~exist('post_name_add','var') )
    post_name_add = '';
  end
  
  % new_path
  %---------------
  if( ~exist('new_path','var') )
    new_path = '';
  end
  
  % new_ext
  %---------------
  if( ~exist('new_ext','var') )
    new_ext = '';
  end
  
  if( isempty(pre_name_add) && isempty(post_name_add) && isempty(new_path) && isempty(new_ext) )
    message = sprintf('%s: nichts zu tuen',mfilename);
    okay    = 0;
    return
  else
    
    s_file = str_get_pfe_f(file_spec);
    
    file_spec = fullfile(verz,[s_file.name,'.',s_file.ext]);
    
    f = dir(file_spec);
    
    for i=1:length(f)
      
      s_file = str_get_pfe_f(f(i).name);
      
      sfile = fullfile(verz,[s_file.name,'.',s_file.ext]);
      
      % tfile
      if( ~isempty(new_ext) )
        ext = str_cut_a_f(new_ext,'.');
      else
        ext = s_file.ext;
      end
      if( ~isempty(new_path) )
        verz = new_path;
      end

      name = [pre_name_add,s_file.name,post_name_add];
      
      tfile = fullfile(verz,[name,'.',ext]);
      
      [okay,message] = copy_file(sfile,tfile,1);
      if( ~okay )
        return
      end
    end
  end
end
