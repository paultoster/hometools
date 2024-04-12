function [indexAct,dPathAct,xTrajAct,yTrajAct] = vek_2d_finde_traj_punkt(xTraj,yTraj,indexAct,type,x0,y0,yaw)
%
% [indexAct,dPath] = vek_2d_finde_traj_punkt(xTraj,yTraj,indexAct,type,x0,y0,yaw)
%
% Finde Position auf Trajektorie
%
% xTraj,yTraj   m,m       Vektor mit n Trajektorienpunkte
% indexAct                    Actuelle Position von letzter Berechnung
%                         init mit indexAct = 0;
% x0,y0,yaw     m,m,rad   Position, zu der senkrechte Schnittpunkt gefunden
%                         werden soll 
% type                    0: senkrecht zu Pfad
%                         1: senkrecht zu Richtung yaw
%

  if( ~exist('yaw','var') )
    yaw = 0.;
  end
  syaw = sin(yaw);
  cyaw = cos(yaw);
  % senkrecht dazu
  cbeta = -syaw;
  sbeta = cyaw;

  n = min(length(xTraj),length(yTraj));
  icount = 0;
  if( indexAct < 1 ),indexAct = 1;end
  if( indexAct > n-1 ),indexAct = n-1;end
  dir=0;
  while( icount <= n )
    icount = icount + 1;
    dxAct    =  xTraj(indexAct+1)-xTraj(indexAct);
    dyAct    =  yTraj(indexAct+1)-yTraj(indexAct);

    if( type == 0 )
      % Rectangle Path */
      dPathAct =  (x0 - xTraj(indexAct))*dxAct + (y0 - yTraj(indexAct))*dyAct;
      dPathAct = dPathAct / not_zero((dxAct*dxAct+dyAct*dyAct));
    else
      % Rectangle Vehicle */
      dPathAct =  cbeta * (yTraj(indexAct) - y0) - sbeta * (xTraj(indexAct)- x0 );
      dPathAct = dPathAct / not_zero(sbeta * dxAct - cbeta * dyAct);
    end

    if( dPathAct  > 1.0 )

      if( indexAct >= n-1 ) % Path end 

        indexAct = n-1;
        break;

      else
        dPathAct = 1.0;
        if( dir == -1 ) % if last direction was backward, then finish
          break;
        end
        dir = +1;
        indexAct = indexAct + 1;

      end
    elseif( dPathAct < 0.0 )

      if(  indexAct == 1 ) % Path begin
          break;

      else

        dPathAct = 0.0;
        if( dir == +1 ) % if last direction was forward, then finish
          break;
        end
        dir = -1;
        indexAct = indexAct - 1;
      end

    else
        break; % found */
    end

  end

  xTrajAct      = xTraj(indexAct) + dPathAct * dxAct;
  yTrajAct      = yTraj(indexAct) + dPathAct * dyAct;
end