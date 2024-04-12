function subdir = get_subdirs_from_dir(base_dir,search_dir)
%
% subdir = get_subdirs_from_dir(base_dir,search_dir)
%
% is search dir in base dir 
%
% base_dir   = 'D:\abc\def'
% search_dir = 'D:\abc\def\gjh'  => subdir = gjh
% search_dir = 'D:\abc'          => subdir = ''
%
%
  
  base_dir   = fullfile(base_dir);
  search_dir = fullfile(search_dir);
  
  i0 = strfind(lower(search_dir), lower(base_dir));
  if( isempty(i0) || (length(base_dir) == length(search_dir)) )
    subdir = '';
  else
    subdir = search_dir(i0+length(base_dir):end);
    while( length(subdir) && (subdir(1) == '\') )
      subdir = subdir(2:end);
    end
  end
end
