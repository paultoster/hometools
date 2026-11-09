function  fullfilename = str_set_pfe_f(s_file)
%
% function  fullfilename = str_set_pfe_f(s_file)
%
% Sucht aus struktur s_file (siehe str_get_pfe_f) Fullfilename
% Input
% s_file.dir                    % directory
% s_file.name                   % Body
% s_file.ext                    % Extension
% Beispiel
% 
% s_file.dir  = 'd:\test\';
% s_file.name = 'abc';
% s_file.ext  = 'fig';
% fullfilename = str_set_pfe_f(s_file);
% fullfilename: 'd:\test\abc.fig'

  if( ~isfield(s_file,'name') )
    if( ~isfield(s_file,'body') )
      error('%s_error: no body-name in s_file (s_file.name)');
    else
      s_file.name = s_file.body;
    end
  end
  fullfilename = s_file.name;
  
  if( isfield(s_file,'ext') )
    extname = s_file.ext;
    while(~isempty(extname) && (extname(1) == '.') )
      if( length(extname) > 1 )
        extname = extname(2:end);
      else
        extname = '';
      end
    end     
  else
    extname = '';
  end
  if( ~isempty(extname) )
    fullfilename = [fullfilename,'.',extname];
  end
  
  if( isfield(s_file,'dir') )
    fullfilename = fullfile(s_file.dir,fullfilename);
  end
end