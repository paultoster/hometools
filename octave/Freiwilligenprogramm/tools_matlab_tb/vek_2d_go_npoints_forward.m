function i0 = vek_2d_go_npoints_forward(xvec,yvec,i0,npoints,dsmax)
%
% i0 = vek_2d_go_npoints_forward(xvec,yvec,i0,npoints,dsmax)
%
% go n-points back, but maximum dsmax
%

  n = min(length(xvec),length(yvec));
  i1 = min(n,i0+npoints);
  s  = 0.;
  di = 0;
  for i=i0:1:i1
    if( i == i1 )
      break;
    else
      dx = xvec(i+1)-xvec(i);
      dy = yvec(i+1)-yvec(i);
      s  = s + sqrt(dx*dx+dy*dy);

      if( s >= dsmax )
        break;
      end
    end
    di = di + 1;
  end
  i0 = i0 + di;  
end
