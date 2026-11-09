function [xi,yi,dPath,alphai,iact,dist,dyaw] = vek_2d_intersection(xvec,yvec,x0,y0,alpha0,typ,iact)
%
% [xi,yi,dPath,alphai,iact] = vek_2d_intersection(xvec,yvec,x0,y0,alpha0,typ,iact)
% [xi,yi,dPath,alphai,iact,dist,dyaw] = vek_2d_intersection(xvec,yvec,x0,y0,alpha0,typ,iact)
%
% Calc Intersection-Point on xvec,yvec
%
% xvec,yvec     Vektor with 2d-coordinates of Trajectory
% x0,y0,alpha0  actual point (Odometrie)
% typ           (default: 1)
%               0: rectangle to direction alpha0 
%               1: rectangle t0 xvec,yvec
% iact          (default: 1)
%               Aktueller Punkt aus letzten Berechnung
%               -1: bedeutet, das der nächste Punkt gesucht wird und 10
%               Punkte davor gegangen wird
%
% xi,yi         Point og interection on xvec,yvec linear
% dPath         portion of intersection defined to s(i+1)-s(i)
% alphai        direction of vector xvec,yvec
% dist          distance from xi/yi - x0/y0 absolute
% dyaw          deviation alphai - alpha0
%
  if( ~exist('alpha0','var') )
    alpha0 = 0.0;
  end
  if( ~exist('typ','var') )
    typ = 1;
  end
  if( ~exist('iact','var') )
    iact = 1;
  end
  n = min(length(xvec),length(yvec));
  
  if( abs(iact-1.) < 0.5 )
    i0 = vek_2d_intersection_nearest_point(xvec,yvec,n,x0,y0);
    if( i0 > 10 ) 
      i0 = i0 - 9;
    else
      i0 = 1;
    end
    i0 = min(n,i0);
    i1 = min(n,i0+1);
  else
    i0 = min(n,iact);
    i1 = min(n,iact+1);
  end
  if( (i0 == i1) && (i0>1) ),i0 = i0-1;end
  
  if( typ == 0 )
    salpha = sin(alpha0);
    calpha = cos(alpha0);
    cbeta  = -salpha;
    sbeta  = calpha;     
  end
  icount = 0;
  flag   = 1;
  dirr   = 0;
  while( (icount < n) && flag )
  
    icount = icount + 1;
    dx     = xvec(i1)-xvec(i0);
    dy     = yvec(i1)-yvec(i0);
    if( typ == 1)
      ds    = dx*dx+dy*dy;
      dPath = ((x0-xvec(i0))*dx + (y0-yvec(i0))*dy)/not_zero(ds);
    else
      ds    = sbeta * dx - cbeta * dy;
      dPath = (cbeta * (yvec(i0) - y0) - sbeta * (xvec(i0) - x0 ))/not_zero(ds);
    end      
    
    if( dPath > 1.0 )
      if( i1 == n )
%        dPath = 1.0;
        flag  = 0;
      else
        if( dirr < -0.5 )
          dPath = 1.0;
          flag  = 0;
        else
          dirr = 1;
          i0   = i0 + 1;
          i1   = i1 + 1;
        end
      end
    elseif( dPath < 0.0 )
      if( i0 == 1 )
%        dPath = 0.0;
        flag  = 0;
      else
        if( dirr > 0.5 )
          dPath = 0.0;
          flag  = 0;
        else
          dirr = -1;
          i0 = i0-1;
          i1 = i1-1;
        end
      end
    else
      flag = 0;
    end
    
  end
  
  iact   = i0;
  xi     = xvec(i0) + dPath * dx;
  yi     = yvec(i0) + dPath * dy;
  alphai = atan2(yvec(i1)-yvec(i0),xvec(i1)-xvec(i0));
  
  dx     = (xi-x0);
  dy     = (yi-y0);
  dist   = sqrt(dx*dx+dy*dy);
  dyaw   = alphai - alpha0;
  
  if( typ == 1 )   
    a = cross([dx;dy;0],[cos(alphai);sin(alphai);0]);
    if( a(3) < 0.0 ) 
      dist = -dist;
    end
  else
    a = cross([dx;dy;0],[cos(alpha0);sin(alpha0);0]);
    if( a(3) < 0.0 ) 
      dist = -dist;
    end
  end
  
end
function i0 = vek_2d_intersection_nearest_point(xvec,yvec,n,x0,y0)

  delta = 1e10;
  i0    = 1;
  for i=1:n
    dx = xvec(i)-x0;
    dy = yvec(i)-y0;
    d  = dx*dx+dy*dy;
    if( d < delta )
      i0 = i;
      delta = d;
    end
  end
end
