function str = str_cut_a_wspace(str)
%
% str = str_cut_a_wspace(str)
%
% Schneide alle Whitespace (' ',\t,\n) am Anfang ab

  ivec = isstrprop(str,'wspace');
  n    = length(ivec);

  if( ivec(1) == 0 ) % no whitespcae
    return
  else
    i = 2;
    while( i <= n )

      if( ivec(i) == 0 )
        break;
      end
      i = i+1;
    end
    if( i > n )
      str = '';
    else
      str = str(i:end);
    end
  end
end
