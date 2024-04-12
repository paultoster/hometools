function [okay,message] = copy_file(sfile,tfile,displ)
%
% [okay,message] = copy_file(sfile,tfile,displ)
%

  okay    = 1;
  message = '';

  % Proof source-file
  %------------------
  if( ~exist(sfile,'file') )
    message = sprintf('%s: Source File <%s> was not found',mfilename,sfile);
    okay    = 0;
    return
  end
  
  if( ~exist('displ','var') )
    displ = 0;
  end
  
  if( displ )
    
    fprintf('copy( %s\n    , %s)\n',sfile,tfile)
  end
  
  a = dir(sfile);
  if( a.bytes > 0 )
  
    % Read source-file
    %------------------
    [fid,message] = fopen(sfile,'r');

    if( fid < 0 )
      okay = 0;
      return
    end

    A = fread(fid);

    fclose(fid);

    % Write target-file
    %------------------
    [fid,message] = fopen(tfile,'w');

    if( fid < 0 )
      okay = 0;
      return
    end

    fwrite(fid, A);

    fclose(fid);
  end
end