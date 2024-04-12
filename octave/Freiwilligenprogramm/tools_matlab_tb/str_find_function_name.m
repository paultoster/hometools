function ifound = str_find_function_name(tt,tfunc)
%
% ifound = str_find_function_name(tt,tfunc)
% Sucht tfunc als Funktionsname in Text tt
% z.B. usage('bla'), aber nicht print_usage()
%
% ifound = [] nicht gefunden
% ifound = [i1,i2, ...] gefundene Stellen

ifound = [];
i0      = str_find_f(tt,tfunc,'vs');
i0start = 0;

while( i0 > 0 )
  count = 0;
  if( i0 == 1 ) % Steht am Anfang
    count = count + 1;
  elseif( ~isletter(tt(i0-1)) )
    if( tt(i0-1) ~= '_' )
      count = count+1;
    end
  end
  i1 = i0+length(tfunc)-1; 
  if( i1 == length(tt) ) %steht am Ende
    count =count + 1;
  elseif( ~isletter(tt(i1+1)) )
    if( tt(i1+1) ~= '_' )
      count = count+1;
    end
  end
  if( count == 2 )
    ifound = [ifound,i0+i0start];
  end
  i0start = i0start+i1;
  n = length(tt);
  if( i1 < n);
    tt = tt(i1+1:n);
  else
    tt = '';
  end
  i0 = str_find_f(tt,tfunc,'vs');
end

  
  