function [xvec,index] = vec_insert_value(xvec,xval,ascend)
%
% [xvec,index] = vec_insert_value(xvec,xval,ascend)
%
% xvec          num      Spaltenvektor
% xval          num      Wert der einzusortieren ist
% ascend        0/1      1: aufsteigend (default)
%                        0: absteigend

 if( ~exist('ascend','var') )
   ascend = 1;
 end
 if( ascend )
  ii = suche_index(xvec,xval,'>','v',eps,1);
  if( iscell(ii) )
    for i=1:length(ii) 
      index = ii{i};
      x     = xval(i);
      n     = length(xvec);
      if( index == 0 )
        xvec  = [xvec;x];
        index = n+1;
      elseif( index == 1 )
        xvec = [x;xvec(index:n)];
      else
        xvec = [xvec(1:index-1);x;xvec(index:n)];
      end
    end
  else
    index = ii;
    n     = length(xvec);
    if( index == 0 )
      xvec  = [xvec;xval];
      index = n+1;
    elseif( index == 1 )
      xvec = [xval;xvec(index:n)];
    else
      xvec = [xvec(1:index-1);xval;xvec(index:n)];
    end
  end
 else
  ii = suche_index(xvec,xval,'<=','v',eps,1);
  if( iscell(ii) )
    di = 0;
    for i=1:length(ii) 
      index = ii{i}+di;
      x     = xval(ii);
      n     = length(xvec);
      if( index == 0 )
        xvec  = [x;xvec];
        di = 0;
      elseif( index == n )
        xvec  = [xvec(index:n);x];
        di = di + 1;
      else
        xvec  = [xvec(1:index);x;xvec(index+1:n)];
        di = di + 1;
      end  
    end
  else
    index = ii;
    n     = length(xvec);
    if( index == 0 )
      xvec  = [xval;xvec];
      index = 1;
    elseif( index == n )
      xvec  = [xvec(index:n);xval];
      index = index + 1;
    else
      xvec  = [xvec(1:index);xval;xvec(index+1:n)];
      index = index + 1;
    end  
  end
 end
end 
 