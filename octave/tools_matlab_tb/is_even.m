function flag = is_even(a)
%
% flag = is_even(a)
%
% flag = 1 floor(floor(abs(a))/2)*2 == floor(abs(a))

a = floor(abs(a));

if( floor(a/2)*2 == a )
  flag = 1;
else
  flag = 0;
end

