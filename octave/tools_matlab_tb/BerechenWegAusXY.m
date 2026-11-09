function s = BerechenWegAusXY(x,y)

 [n,m] = size(x);
 if( m > n )
   trans_flag = 1;
   x = x';
   n = m;
 else
   trans_flag = 0;
 end
 [n1,m1] = size(x);
 if( m1 > n1 )
   %transy_flag = 1;
   y = y';
   n1 = m1;
% else
%   transy_flag = 0;
 end
 n = min(n1,n);
  
 s = zeros(n,m);
 
 for j=1:m
   for i=2:n
     s(i,j) = s(i-1,j) + sqrt((x(i,j)-x(i-1,j))^2+(y(i,j)-y(i-1,j))^2);
   end
 end
 
 if( trans_flag )
   s = s';
 end
    
end