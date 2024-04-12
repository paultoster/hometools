function [xi,yi,dPath,iact] = vek_2d_intersection_with_dir(xvec,yvec,x0,y0,calpha0,salpha0,iact)
%
% [xi,yi,dPath,iact] = vek_2d_intersection_with_dir(xvec,yvec,x0,y0,calpha0,salpha0,iact)
%
% Calc Intersection-Point on xvec,yvec
%
% xvec,yvec     Vektor with 2d-coordinates of Trajectory
% x0,y0         actual point (Odometrie)
% calpha0       direction of actual point to find on Trajectory
% salpha0
% iact          (default: 1)
%               Aktueller Punkt aus letzten Berechnung
%               -1: bedeutet, das der nächste Punkt gesucht wird und 10
%               Punkte davor gegangen wird
%
% xi,yi         Point og interection on xvec,yvec linear
% dPath         portion of intersection defined to s(i+1)-s(i)
% iact
%

  if( ~exist('calpha0','var') )
    calpha0 = 1.0;
  end
  if( ~exist('salpha0','var') )
    salpha0 = 0.0;
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
  
  icount = 0;
  nvec   = min(length(xvec),min(yvec));
  dir    = 0;
  dxAct  = 0.;
  dyAct  = 0.;

  if( nvec > 1 )
  
    i0 = min(i0,nvec-1);
    i1 = i0 + 1;
    while( icount <= nvec )
    
      icount = icount + 1;
      dxAct    =  xvec(i0)-xvec(i1);
      dyAct    =  yvec(i0)-yvec(i1);
    
      % directed crossing on  Path 
      dPath = calpha0 * (yvec(i0)-ysuch);
      dPath = dPath - (salpha0 * (xvec(i0)-xsuch));
      dPath = dPath / not_zero(calpha0 * dyAct - salpha0 * dxAct);

      if( dPath  > (1.0) )
      
        if( (i0) >= nvec-2 ) % Path end 
        
          i0 = nvec-2;
          break;
        
        else
        
          dPath = 1.0;
          if( dir == -1 ) % if last direction was backward, then finish          
            break;
          end
          dir = +1;
          i1 = i0 + 1;
          i0 = i0 + 1;

        end
      
      elseif( dPath < (0.0) )
      
        if(  (i0) == 0 ) % Path begin
        

          break;
        
        else
        
          dPath = (TD)0.0;
          if( dir == +1 ) % if last direction was forward, then finish
          
            break;
          end
          dir = -1;
          i0  = i0 - 1;
          i1  = i1 - 1;
        end
      
      else
      
        break; % found 
      end
    end     

    xi      = xvec(i0) - dPath * dxAct;
    yi      = yvec(i0) - dPath * dyAct;
  
  else
  
    xi = -1.0;
    yi = -1.0;
  end
  
  iact   = i0;
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
