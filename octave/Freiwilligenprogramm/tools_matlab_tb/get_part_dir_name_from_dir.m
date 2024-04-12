function dirnamepart = get_part_dir_name_from_dir(dirname,firstpart,lastpart)
%
% dirnamepart = get_part_dir_name_from_dir(dirname,firstpart,lastpart)
% dirnamepart = get_part_dir_name_from_dir(dirname,firstpart,deltatolastpart)
%
% get from dirname seperated with '\' the part from first to last
% or with deltatolastpart < 0 get relativ to last e.g. -1 is prelast
% e.g.
%
% dirnamepart = get_part_dir_name_from_dir('D:\abc\def\gjk',1,3)  => dirnamepart = 'D:\abc\def'
% dirnamepart = get_part_dir_name_from_dir('D:\abc\def\gjk',1,-1) => dirnamepart = 'D:\abc\def'
%

  dirname = fullfile(dirname);
  [dirs,n] = str_split(dirname,'\');
  
  % start
  i0 = firstpart;
  if( i0 < 1 )
    i0 = 1;
  elseif( i0 > n )
    i0 = n;
  end
  if( lastpart > 0 )
    i1 = lastpart;
    if( i1 > n )
      i1 = n;
    elseif( i1 < i0 )
      i1 = i0;
    end
  else
    i1 = n + lastpart;
    if( i1 < i0 )
      i1 = i0;
    end
  end
  
  
  dirnamepart = dirs{i0};
  for i=i0+1:i1
    dirnamepart = str_add(dirnamepart,'\');
    dirnamepart = str_add(dirnamepart,dirs{i});
  end

end