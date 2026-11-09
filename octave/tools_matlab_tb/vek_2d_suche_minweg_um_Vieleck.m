function [X,Y] = vek_2d_suche_minweg_um_Vieleck(Xg,Yg,Xv,Yv)
%
% [X,Y] = vek_2d_suche_minweg_um_Vieleck(Xg,Yg,Xv,Yv)
%
%  Xg = xg0,xg1, Yg = yg0,yg1   Geradenstück
%
%  Xv = x1,x2,x3,...  Yv = y1,y2,y3,... Vieleck
%

  % Ende des Vieleckes prüfen
  tol = 10*eps;
  nv = min(length(Xv),length(Yv));
  XV = Xv(1);
  YV = Yv(1);
  for i=2:nv
    if( vek_2d_length([Xv(i-1);Xv(i)],[Yv(i-1);Yv(i)]) > tol )
      XV = [XV;Xv(i)];
      YV = [YV;Yv(i)];
    end
  end
  nv = length(XV);
  if( vek_2d_length([XV(1);XV(nv)],[YV(1);YV(nv)]) > tol )
    XV = [XV;Xv(1)];
    YV = [YV;Yv(1)];
    nv = nv + 1;
  end


  % Drehrichung beachten > 0
  xm = mean(XV(1:nv-1));
  ym = mean(YV(1:nv-1));

  alpha = 0;
  for i=2:nv
    alpha = alpha + vek_2d_winkel([xm,XV(i-1)],[ym,YV(i-1)],[xm,XV(i)],[ym,YV(i)]);
  end

  if( alpha < 0.0 )
     XV=umsortieren(XV);
     YV=umsortieren(YV);
  end  

  % Suche den nächsten Schnittpunkt
  [flag,xe,ye,imin,dmin] = vek_2d_suche_minweg_um_Vieleck_Schnittpunkte(Xg,Yg,XV,YV,nv);

  s = sum(flag);
  if( s == 0 ) % kein Schnittpunkt, d.h usprüngliche Gerade
    X = Xg;
    Y = Yg;
  elseif( is_odd(s) )
    error('vek_2d_suche_minweg_um_Vieleck: Keine Lösung möglich');
  else
    if( imin == nv-1 )
      ipos = 1;
    else
      ipos = imin+1;
    end
    [dpos,Xpos,Ypos] = vek_2d_suche_minweg_um_Vieleck_dir(1,Xg(2),Yg(2),XV,YV,nv,ipos,tol);

    if( imin == 1 )
      ineg = nv-1;
    else
      ineg = imin;
    end
    [dneg,Xneg,Yneg] = vek_2d_suche_minweg_um_Vieleck_dir(0,Xg(2),Yg(2),XV,YV,nv,ineg,tol);

    % Zusammen gesetzt mit kürzeren
    if( dpos < dneg )
      X = [Xg(1);Xpos];
      Y = [Yg(1);Ypos];
    else
      X = [Xg(1);Xneg];
      Y = [Yg(1);Yneg];
    end
  end
end
function [flag,xe,ye,imin,dmin] = vek_2d_suche_minweg_um_Vieleck_Schnittpunkte(Xg,Yg,XV,YV,nv)
  % welche Seite wird gekreuzt
  flag = zeros(nv,1);
  xe   = zeros(nv,1);
  ye   = zeros(nv,1);
  imin = -1;
  dmin = 1/eps;
  for i=1:nv-1
    [flag(i),xe(i),ye(i)] = vek_2d_geraden_kreuzen(3,Xg,Yg,[XV(i),XV(i+1)],[YV(i),YV(i+1)]);
     if( flag(i) )
       a = vek_2d_length([Xg(1),XV(i)],[Yg(1),YV(i)]);
       b = vek_2d_length([Xg(1),XV(i+1)],[Yg(1),YV(i+1)]);
       if( b < a )
         if( b < dmin )
           imin = i+1;
           dmin = b;
         end
       else
         if( a < dmin )
           imin = i;
           dmin = a;
         end
       end
     end
  end
  if( imin == nv ), imin = 1;end;
end
function [ddir,Xdir,Ydir] = vek_2d_suche_minweg_um_Vieleck_dir(flag_pos,xe,ye,XV,YV,nv,idir,tol)
%
% positiv von XV(ipos),YV(idir) umd das Vieleck auf xe,ye zu
  Xdir = XV(idir);
  Ydir = YV(idir);
  ndir = 1;
  flag = 1;
  
  icount = 0;
  
  while( flag )
    icount = icount + 1;
    % nächste Gerade:
    Xg = [Xdir(ndir);xe];
    Yg = [Ydir(ndir);ye];
    [flag1,xs,ys,imin,dmin] = vek_2d_suche_minweg_um_Vieleck_Schnittpunkte(Xg,Yg,XV,YV,nv);
    if( (imin < 0) || (abs(dmin) < tol) || icount >= nv-1) % Kein schnittpunkt, bzw. abbruch
      Xdir = [Xdir;xe];
      Ydir = [Ydir;ye];
      ndir = ndir+1;
      flag = 0;
    else % esgibt einen Schnittpunkt
      if( flag_pos )
        if( idir >= nv-1 )
          idir = 1;
        else
          idir = idir + 1;
        end
      else
        if( idir == 1 )
          idir = nv-1;
        else
          idir = idir - 1;
        end
      end
      Xdir = [Xdir;XV(idir)];
      Ydir = [Ydir;YV(idir)];
      ndir = ndir+1;
    end
    
  end

  ddir = vek_2d_length(Xdir,Ydir);
end


