function [spath,xpath,ypath,index] = vek_2d_build_s(x,y,n,s0,dsmin)
%
% [spath,xpath,ypath] = vek_2d_build_s(x,y[,n,s0,dsmin])
% 
% Bildet den Weg entlang x(i),y(i) i = 1...n
% start mit s0 und minimaler Abstand dsmin (dsmin = -1,kein min Abstand)
% (default: n = min(length(x),length(y)),s0 = 0, dsmin=0.001)
%
  spath = [];
  xpath = [];
  ypath = [];
  index = 0;
  if( ~exist('dsmin','var') )
    dsmin = 0.001;
  end
  if( ~exist('s0','var') )
    s0 = 0.0;
  end
  if( ~exist('n','var') )
    n = min(length(x),length(y));
  end
  
  if( n > 1 )
    s  = ones(n,1)*s0;
    for i = 2:n
      dx    = x(i)-x(i-1);
      dy    = y(i)-y(i-1);
      ds    = sqrt((dx)^2+(dy)^2);
      s(i)  = s(i-1) + ds;
    end

    spath    = s(1);
    xpath    = x(1);
    ypath    = y(1);
    index    = 1;
    slast    = spath;
    for i=2:n 
      if( s(i)-slast >= dsmin )
        xpath  = [xpath;x(i)];
        ypath  = [ypath;y(i)];
        spath  = [spath;s(i)];
        index  = [index;i];
        slast  = s(i);
      end
    end
  end
end

