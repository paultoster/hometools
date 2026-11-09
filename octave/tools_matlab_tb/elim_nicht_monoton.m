function [xout,yout] = elim_nicht_monoton(xin,yin,toleranz,steig_flag)
%  
% [xout,yout] = elim_nicht_monoton(xin,yin[,toleranz,steig_flag])
%
% Sucht nicht monotone Stellen in xin und elimiiniert in xin,yin
%
% toleranz      Toleranzangabe default: eps
% steig_flag    Steigend oder fallend default steigend steig_flag = 1
%

[m,n] = size(xin);

if( n > m )
    xin = xin';
    yin = yin';
    m   = n;
    trans_flag_x = 1;
else
    trans_flag_x = 0;
end

[my,ny] = size(yin);

if( m ~= my && m == ny )
    trans_flag_y = 1;
    yin = yin';
    my  = ny;
else
    trans_flag_y = 0;
end

if( my ~= m )
    
    error('xin(m=%i) und yin(m=%i) haben unterschiedliche Längen',m,my)
end

if( ~exist('toleranz','var') )
    
    toleranz = eps;
else
    toleranz = abs(toleranz);
end

if( ~exist('steig_flag','var') )
    
    steig_flag = 1;
end

i = 2;
x0 = xin(1,1);
xout = xin(1,:);
yout = yin(1,:);
while( i <= m )
  
    if( steig_flag )
      if( (xin(i,1)-x0) > toleranz )
        x0 = xin(i,1);
        xout = [xout;xin(i,:)];
        yout = [yout;yin(i,:)];
      end
    else
      if( (x0 - xin(i,1)) > toleranz )
        x0 = xin(i,1);
        xout = [xout;xin(i,:)];
        yout = [yout;yin(i,:)];
      end
    end
    i = i+1;
end
if( trans_flag_x )
    xout = xout';
end
if( trans_flag_y )
    yout = yout';
end