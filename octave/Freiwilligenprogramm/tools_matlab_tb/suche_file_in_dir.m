function [flag,fullfilename] = suche_file_in_dir(dirname,filename,searchsubdirs)
%
% [flag,fullfilename] = suche_file_in_dir(dirname,filename,searchsubdirs)
% [flag,fullfilename] = suche_file_in_dir(dirname,filename)
%
% dirname		    char	  Verzeichnisname
% filename      char    Dateiname
% searchsubdirs 0/1     default 1
% z.B. [flag,fullfilename] = suche_file_in_dir('D:\temp','test.dat')
% flag = 0/1
% fullfilename = 'D:\temp\v1\test.dat'
flag         = 0;
fullfilename = '';

if( ~exist('searchsubdirs','var') )
    searchsubdirs = 1;
end

s_file = str_get_pfe_f(filename);

s_files = suche_files_body(dirname,s_file.body,1,searchsubdirs);

for i=1:length(s_files)
  if( strcmpi(s_files(i).ext,s_file.ext) )
    flag         = 1;
    fullfilename = s_file.filename;
    break;
  end
end
