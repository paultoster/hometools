function iflag = str_is_upper(t)
%
% iflag = str_is_upper(t)
%
% iflag = str_is_upper('AbcDef')
% iflag = [1,0,0,1,0,0]'
% iflag = str_is_upper('A')
% iflag = 1
% iflag = str_is_upper('1')
% iflag = 0
%
  n = length(t);
  iflag = zeros(n,1);
  for i=1:n
    if( isletter(t(i)) )
      a = double(t(i));
      if( (a > 64) && (a < 91) )
        iflag(i) = 1;
      end
    end
  end
end
