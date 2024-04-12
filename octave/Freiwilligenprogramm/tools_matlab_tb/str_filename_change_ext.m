function newfilename = str_filename_change_ext(filename,newext)
%
% newfilename = str_filename_change_ext(filename,newext)
%

  s_file = str_get_pfe_f(filename);
  newfilename = fullfile(s_file.dir,[s_file.name,'.',newext]);
end
