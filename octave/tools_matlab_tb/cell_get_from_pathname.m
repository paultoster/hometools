function cellliste = cell_get_from_pathname(pathname)
%
% cellliste = cell_get_from_pathname(pathname)

  if( ~exist('pathname','var') )
    pathname = pwd;
  end
  pathname = str_change_f(pathname,'\','/');
  cellliste = str_split(pathname,'/');
end