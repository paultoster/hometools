function y = vektor_cut(x,i0,i1)
%-------------------------------
% y = vektor_cut(x,i0,i1)
%-------------------------------
if( i0 > i1 )
    dum = i0;
    i0  = i1;
    i1  = i0;
end

[n,m] = size(x);

if( m > n )
    trans_flag = 1;
    x = x';
    dum = n;
    n   = m;
    m   = dum;
else
    trans_flag = 0;
end

icount = 0;
y = [];
for irow = 1:n
        
    if( irow < i0 || irow > i1 )
    
        for icol = 1:m
        
            icount = icount + 1;
            y(icount,icol) = x(irow,icol);
        end
    end
end

if( trans_flag )
  y = y';
end
             
        
        