function xvec = vec_insert_at_index(xvec,xval,index)
%
% xvec = vec_insert_at_index(xvec,xval,index)
%
% xvec          num      Spaltenvektor
% xval          num      Wert der einzusortieren ist
% index         num      index an dem einsortiert wirde


 n     = length(xvec);
 if( index > n )
   xvec = [xvec;xval];
 elseif( index <= 1 )
   xvec = [xval;xvec];
 else
   xvec = [xvec(1:index-1);xval;xvec(index:n)];
 end
end  
