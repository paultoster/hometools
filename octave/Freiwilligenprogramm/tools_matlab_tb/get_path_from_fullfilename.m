function fpath = get_path_from_fullfilename(fullfilename)
%
% fpath = get_path_from_fullfile(fullfilename)
%
% fullfilename                voller NAme der Datei  z.B. 'D:\abc\gdr\sklsklskl.txt'
%
% fpath                       Pfad                   z.B. 'D:\abc\gdr'

  s_file = str_get_pfe_f(fullfilename);
  
  fpath = s_file.dir;
end