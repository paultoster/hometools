function c = find_integer_in_string(str)
%
% c = find_integer_in_string(str)
%
% sucht integerwerte in string
%
% str = '123sfd123hehe' => carray = {123,123};
%
  c = {};
  n = length(str);

  such_flag = 1;
  tval = '';
  for i=1:n

    if( isstrprop(str(i), 'digit') )
      if( such_flag )
        tval = str(i);
        such_flag = 0;
      else
        tval = [tval,str(i)];
      end
    else
      if( length(tval) )
        c = cell_add(c,str2num(tval));
        tval = '';
      end
      such_flag = 1;
    end
  end
  if( length(tval) )
   c = cell_add(c,str2num(tval));
  end
end