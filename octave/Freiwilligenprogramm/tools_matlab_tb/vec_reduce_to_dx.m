function vecdx = vec_reduce_to_dx(vec,dx)
%
% vecdx = vec_reduce_to_dx(vec,dx)
%
% reduziert Vektor auf Mindestabstand dx 
% Vektor aufsteigend
%
 [n,m] = size(vec);
 if( n >= m )
   flagRow = 1;
 else
   flagRow = 0;
 end
 vold  = vec(1);
 vecdx = vec(1);
 if( flagRow )
   for i=2:length(vec) 
     if( vec(i) >= vold+dx )
       vecdx = [vecdx;vec(i)];
       vold  = vec(i);
     end
   end
 else
   for i=2:length(vec) 
     if( vec(i) >= vold+dx )
       vecdx = [vecdx,vec(i)];
     end
   end
 end
end
   
   