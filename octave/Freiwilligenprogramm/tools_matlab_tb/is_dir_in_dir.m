function flag = is_dir_in_dir(base_dir,search_dir)
%
% flag = is_dir_in_dir(base_dir,search_dir)
%
% is search dir in base dir 
%
% base_dir   = 'D:\abc\def'
% search_dir = 'D:\abc\def\gjh'  => flag = 1
% search_dir = 'D:\abc'          => flag = 0
%
%
  
  base_dir   = fullfile(base_dir);
  search_dir = fullfile(search_dir);
  
  if( isempty(strfind(lower(search_dir), lower(base_dir))) )
    flag = 0;
  else
    flag = 1;
  end
end
