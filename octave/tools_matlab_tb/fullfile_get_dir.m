function dirname = fullfile_get_dir(fullfilename,nup)
%
% dirname = fullfile_get_dir(fullfilename)
% dirname = fullfile_get_dir(fullfilename,nup)
%
% Liest directory aus Filename aus
%
% nup   Anzahl der Ebenen hoch zu gehen
%
  if( ~exist('nup','var') )
    nup = 0;
  end
  s_file = str_get_pfe_f(fullfilename);
  dirname = s_file.dir; 
  
  if( nup )
    cname    = str_split(dirname,'\');
    n        = length(cname);
    for i=n:-1:1
      if( ~isempty(cname{i}) )
        cname = cell_delete(cname,i+1,n);
        break;
      end
    end
    n        = length(cname);
    if( nup > n )
      dirname = cname{1};
    else
      dirname = '';
      for i=1:n-nup
        dirname = fullfile(dirname,cname{i});
      end
    end
  end

end