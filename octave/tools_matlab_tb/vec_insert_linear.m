function xvec = vec_insert_linear(xvec,index,dPath)
%
% xvec = vec_insert_linear(xvec,index,dPath)
%
% xvec          num      Spaltenvektor
% index         num      index an dem ein Wert generiert wird
% dPath         num      Antel zwischen 0. ... 1. von index zu index+1


 n     = length(xvec);
 xval = xvec(index) + (xvec(index+1)-xvec(index))*dPath;
 if( index > n )
   xvec = [xvec;xval];
 elseif( index <= 1 )
   xvec = [xval;xvec];
 else
   xvec = [xvec(1:index-1);xval;xvec(index:n)];
 end
end  
