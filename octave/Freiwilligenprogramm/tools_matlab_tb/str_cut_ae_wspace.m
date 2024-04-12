function str = str_cut_ae_wspace(str)
%
% str = str_cut_ae_wspace(str)
%
% Schneide alle Whitespace (' ',\t,\n) am Anfang und Ende ab

  ivec = isstrprop(str,'wspace');
  n    = length(ivec);
  
  i = 1;
  while( i <= n )

    if( ivec(i) == 0 ) % no whitespcae
      break;
    end
    i = i + 1;
  end
  
  if( i > n )
    str = '';
  else
    istart = i;
    
    i = n;
    while( i >= istart )
      if( ivec(i) == 0 ) % no whitespcae
        break;
      end
      i = i - 1;
    end
    if( i < istart )
      iend = istart;
    else
      iend = i;
    end
      
    str = str(istart:iend);
    
  end
end
