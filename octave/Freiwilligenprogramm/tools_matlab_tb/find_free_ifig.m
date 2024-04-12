function ifig = find_free_ifig(ifigstart)
%
% ifig = find_free_ifig(ifigstart)
% ifig = find_free_ifig
%
% Sucht den n�chsten freien figure-Nummer
 if( ~exist('ifigstart','var') )
   ifigstart = 1;
 end
 ifig = ifigstart;
 while( ifig < 1e39 )
   if( ~isfigure(ifig) )
     return
   else
     ifig = ifig +1;
   end
 end
end