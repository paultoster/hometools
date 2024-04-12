function flag = is_vecinfield(d,sig_name)
%
% flag = is_vecinfield(d,sig_name)
%
% d         struct   with vectors
% sig_name  char     Name of Vector
%
% flag = 1  exist and is not empty
%      = 0  otherwise
  flag = 0;
  if( isstruct(d) && ischar(sig_name) && isfield(d,sig_name) && ~isempty(d.(sig_name)) )
    flag = 1;
  end

end

