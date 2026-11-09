function i0 = vek_2d_go_npoints_back(xvec,yvec,i0,npoints,dsmax)
%
% i0 = vek_2d_go_npoints_back(xvec,yvec,i0,npoints,dsmax)
%
% go n-points back, but maximum dsmax
%

  if( i0 > 1 )
    i1 = max(1,i0-npoints);
    s  = 0.;
    di = 0;
    for i=i0:-1:i1
      if( i == 1 )
        break;
      else
        dx = xvec(i)-xvec(i-1);
        dy = yvec(i)-yvec(i-1);
        s  = s + sqrt(dx*dx+dy*dy);
        
        if( s >= dsmax )
          break;
        end
      end
      di = di + 1;
    end
    i0 = i0 - di;  
  end
end
