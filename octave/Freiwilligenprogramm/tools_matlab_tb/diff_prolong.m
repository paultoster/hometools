function xdiff = diff_prolong(x)
%
% xdiff = diff_prolong(x)
%
% makes diff(x) and prolong with one value at end

  [n,m] = size(x);
  xdiff = diff(x);
  [nd,md] = size(xdiff);

  if( n > nd )
    for i=1:md
      xdiff(n,i) = xdiff(nd,i);
    end
    nd = nd+1;
  end
  if( m > md )
    for i=1:nd
      xdiff(i,m) = xdiff(i,md);
    end
    md = md+1;
  end
end  
  
  
