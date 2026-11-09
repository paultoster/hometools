function iflag = str_is_lower(t)
%
% iflag = str_is_lower(t)
%
% iflag = str_is_lower('AbcDef')
% iflag = [0,1,1,0,1,1]'
% iflag = str_is_upper('a')
% iflag = 1
% iflag = str_is_upper('1')
% iflag = 0
%
  n = length(t);
  iflag = zeros(n,1);
  for i=1:n
    if( isletter(t(i)) )
      a = double(t(i));
      if( (a > 96) && (a < 123) )
        iflag(i) = 1;
      end
    end
  end
end
