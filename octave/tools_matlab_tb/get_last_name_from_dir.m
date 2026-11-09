function name = get_last_name_from_dir(dirname,shift)
%
% name = get_last_mae_from_dir(dirname);
%
% dirname = 'D:\abc\def\gjk'
% name = get_last_mae_from_dir(dirname)
% name 'gjk'
%
% name = get_last_mae_from_dir(dirname,shift);
% dirname = 'D:\abc\def\gjk'
% name = get_last_mae_from_dir(dirname,2)
% name 'abc'

  if( ~exist('shift','var') )
    shift = 0;
  end
  dirname = fullfile(dirname);
  [dirs,n] = str_split(dirname,'\');
  
  n = n - abs(shift);
  if( n < 1 )
    n = 1;
  end
  
  name = dirs{n};
%   idelim = max(strfind(dirname,'\'));
% 
%   if( isempty(idelim) )
%     name = '';
%   else
%     if( idelim == length(dirname) )
%         name = '';
%     else
%         name = dirname(idelim+1:length(dirname));
%     end
%   end

end