function [okay,message] = copy_filelist_to_path(filelist,target_path)
%
% [okay,message] = copy_filelist_to_path(filelist,target_path)
% [okay,message] = copy_filelist_to_path(fullfilename,target_path)
%

  okay    = 1;
  message = '';
  
  % build cell arraya
  if( ischar(filelist) )
    filelist = {filelist};
  end
  
  if( ~exist(target_path,'dir') )
    try
      [success,message,~] = mkdir(target_path);
    catch
      success = 0;
      message = sprintf(' crashed');
    end
    if( ~success )
      error('mkdir(%s):%s',target_path,message);
    end
  end
  
  for i=1:length(filelist)
    
    % Proof source-file
    %------------------
    if( ~exist(filelist{i},'file') )
      message = sprintf('%s: Source File <%s> was not found',mfilename,filelist{i});
      okay    = 0;
      return
    end
    
    % target file
    %------------
    trg_file = change_file_dir(filelist{i},target_path);
    
    % copy
    %-----
    [status,message,~] = copyfile(filelist{i}, trg_file);
    
    if( status == 0)
      okay = 0;
      return;
    end
  end

end