function remove_path(pp)
%
% remove_path(pp)
%
% removes path from set path, if exist
%
  p = path;
  c =  str_split(p,';');
  flag = 0;
  for i=1:length(c)
    if( strcmpi(c{i},pp) )
      flag = 1;
      break;
    end
  end

  if( flag )
    rmpath(pp);
  end
end