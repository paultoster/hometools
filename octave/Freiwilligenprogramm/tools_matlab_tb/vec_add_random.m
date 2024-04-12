function vec = vec_add_random( vec,type,delta_random )
%
%   vecout = vec_add_random( vecin,type,delta_random )
%
%   Add random value on Vector vecin => vecout
%
%   type = 1              add delta = +delta_random,0.0,-delta_random to vector
%                         with starting delta = 0.0, first point
%                         undisturbed
%
   n = length(vec);
   
   if( type == 1 )
     for i=2:n
       vec(i) = vec(i) + (2.-randi(3,1))*delta_random;     
     end
   else
     for i=2:n
       vec(i) = vec(i) + (2.-randi(3,1))*delta_random;     
     end
   end

end

