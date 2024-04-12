function [okay,message] = copy_file_pathes_if_newer(spath,tpath,filename,type,ask)
%
% [okay,message] = copy_file_pathes_if_newer(spath,tpath,filename,type)
%
% spath           source- path to copy
% tpath           target-path to copy
% filename        name of file char or celllist
% type            0: if spath, tpath or files in spath is not found (default) no error set
%                 1: return error and okay=0 if sfile not their
%                 2: abort with error if spath, tpath or files in spath is
%                    not found
%                 3: abort with error only if spath, tpath is
%                    not found
% ask             1: ask for copy if source_file is newer

  okay    = 1;
  message = '';

  if( ~exist('type','var') )
    type = 0;
  end
  if( ~exist('ask','var') )
    ask = 0;
  end
  if( ~exist('spath','var') )
    error('Parameter spath not in Parameterlist');
  end
  if( ~exist('tpath','var') )
    error('Parameter tpath not in Parameterlist');
  end
  if( ~exist('filename','var') )
    error('Parameter filename not in Parameterlist');
  end
  if( ~exist(spath,'dir') )
    if( type == 1 )
      message = sprintf('%s: Source Path <%s> was not found',mfilename,spath);
      okay    = 0;
      return
    elseif( type > 1 )
      error('%s: Source Path <%s> was not found',mfilename,spath);
    else
      return
    end
  end
  if( ~exist(tpath,'dir') )
    if( type == 1 )
      message = sprintf('%s: Target Path <%s> was not found',mfilename,tpath);
      okay    = 0;
      return
    elseif( type > 1 )
      error('%s: Target Path <%s> was not found',mfilename,tpath);
    else
      return
    end
  end
  
  if( ischar(filename) )
    filename = {filename};
  end
  for i = 1:length(filename)  
    sfile = fullfile(spath,filename{i});
    tfile = fullfile(tpath,filename{i});
    if( ~exist(sfile,'file') )
      if( type == 1 )
        message = sprintf('%s: Source File <%s> was not found',mfilename,sfile);
        okay    = 0;
        return
      elseif( type == 2 )
        error('%s: Source File <%s> was not found',mfilename,sfile);
      end
    else
      [okay,message] = copy_file_if_newer(sfile,tfile,type,ask);
    end
  end
end