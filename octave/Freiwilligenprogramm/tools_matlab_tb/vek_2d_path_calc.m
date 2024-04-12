function [x,y,s,alpha,kappa,dx,ddx,dy,ddy] = vek_2d_path_calc(xvec,yvec,varargin)
%
% [x,y,s,alpha,kappa,dx,ddx,dy,ddy] = vek_2d_path_calc(xPath,yPath,'iord',7)
% [x,y,s,alpha,kappa] = vek_2d_path_calc(xPath,yPath,'iord',7)
% [x,y,s,alpha,kappa] = vek_2d_path_calc(xPath,yPath,'dsmin',0.01)
%
% Pfad berechnung mit Polynom nter Ordnung
%
% xPath,yPath      vorggebene Punkte
% 'iord'           Ordnung des Polynoms n > iord
%                  default (min(5,n-1))
% 'dsmin'          kleinster Abstand, der betrachtet werden soll
%                  kleinere Abstände zwischen den Punkten wird ignoriert
%                  (default 0.001)
% 'scalc'          Vektor des Weges, wenn agegeben, dann wird damit
%                  x,y,alpha und kappa berechnet
% 'bound0'         Randbedingung Startwert  1: x0,y0 muss übereinstimmen
%                                          10: xp0,yp0 muss übereinstimmen
%                                         100: xpp0,ypp0 muss übereinstimmen 
%                                        1000: xpp0=ypp0=0
%                  (default: bound0=1)
% 'bound1'         Randbedingung Endwert    1: x1,y1 muss übereinstimmen
%                                          10: xp1,yp1 muss übereinstimmen
%                                         100: xpp1,ypp1 muss übereinstimmen
%                                        1000: xpp1=ypp1=0
%                  (default: bound1=1)

  %##########################################################################
    n = min(length(xvec),length(yvec));

    if( n < 2 )
      error('length(xPath),length(yPath) < 2')
    end

  %##########################################################################
    iord  = min(5,n-1);
    dsmin = 0.001;
    scalc = [];
    bound0 = 1;
    bound1 = 1;

    i = 1;
    while( i+1 <= length(varargin) )

      switch lower(varargin{i})
        case 'iord'
          iord = varargin{i+1};
        case 'dsmin'
          dsmin = varargin{i+1};
        case 'scalc'
          scalc = varargin{i+1};
        case 'bound0'
          bound0 = varargin{i+1};
        case 'bound1'
          bound1 = varargin{i+1};
        otherwise
          tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
          error(tdum) %#ok<*SPERR>

      end
      i = i+2;
    end
  %##########################################################################


  %
  % sPath bilden
  %
  [spath,xpath,ypath] = vek_2d_build_s(xvec,yvec,n,0.0,dsmin);
  n    = length(spath);
  [dspath,dxpath,dypath] = vek_2d_build_ds(spath,xpath,ypath,n);
  
  
  %
  % Randbedingung
  %
  xbound0 = [];
  ybound0 = [];
  xbound1 = [];
  ybound1 = [];
  
  if( get_digit(bound0,1) )
    xbound0 = [xbound0,xpath(1)];
    ybound0 = [ybound0,ypath(1)];
  end
  if( get_digit(bound0,2) )
    dxds0 = dxpath(1)/not_zero(dspath(1));
    dyds0 = dypath(1)/not_zero(dspath(1));
    xbound0 = [xbound0,dxds0];
    ybound0 = [ybound0,dyds0];
  end
  if( get_digit(bound0,3) )
    if( get_digit(bound0,4) )
      ddxdds0 =  0.0;
      ddydds0 =  0.0;
    else
      ddxdds0 = (dxpath(2)/not_zero(dspath(2))-dxpath(1)/not_zero(dspath(1))) ...
              / (0.5*(dspath(2)+dspath(1)));
      ddydds0 = (dypath(2)/not_zero(dspath(2))-dypath(1)/not_zero(dspath(1))) ...
              / (0.5*(dspath(2)+dspath(1)));
    end
    xbound0 = [xbound0,ddxdds0];
    ybound0 = [ybound0,ddydds0];
  end
  if( get_digit(bound1,1) )
    xbound1 = [xbound1,xpath(n)];
    ybound1 = [ybound1,ypath(n)];
  end
  if( get_digit(bound1,2) )
    dxds1 = dxpath(n)/not_zero(dspath(n));
    dyds1 = dypath(n)/not_zero(dspath(n));
    xbound1 = [xbound1,dxds1];
    ybound1 = [ybound1,dyds1];
  end
  
  if( get_digit(bound1,3) )
    if( get_digit(bound1,4) )
      ddxdds1 =  0.0;
      ddydds1 =  0.0;
    else
      ddxdds1 = (dxpath(n-1)/not_zero(dspath(n-1))-dxpath(n-2)/not_zero(dspath(n-2))) ...
              / (0.5*(dspath(n-1)+dspath(n-2)));
      ddydds1 = (dypath(n-1)/not_zero(dspath(n-1))-dypath(n-2)/not_zero(dspath(n-2))) ...
              / (0.5*(dspath(n-1)+dspath(n-2)));
    end
    xbound1 = [xbound1,ddxdds1];
    ybound1 = [ybound1,ddydds1];
  end

  %
  % Ordnung
  %
  iord = min(iord,n-1);

  %
  % Polynom
  %
  px = polynom_approx_bound_xy(iord,spath,xpath,xbound0,xbound1);
  py = polynom_approx_bound_xy(iord,spath,ypath,ybound0,ybound1);


  %
  % Auswahl s
  %
  if( isempty(scalc) )
    s = spath;
  else
    s = scalc;
  end

  n     = length(s);
  x     = polyval(px,s);
  y     = polyval(py,s);
  
  dpx    = polyder(px);
  dpy    = polyder(py);
  ddpx   = polyder(dpx);
  ddpy   = polyder(dpy);

  dx     = polyval(dpx,s);
  dy     = polyval(dpy,s);
  ddx    = polyval(ddpx,s);
  ddy    = polyval(ddpy,s);
  
  alpha = atan2(dy,dx);
  zae   = dx .* ddy - ddx .* dy;
  nen   = sqrt((dx .* dx + dy .* dy)).^3;
  kappa = zae ./ not_zero(nen);
  
%   figure(100)
%   plot(s,x,'-k')
%   hold on
%   plot(s,y,'-r')
%   hold off
%   figure(101)
%   plot(s,dx,'-k')
%   hold on
%   plot(s,dy,'-r')
%   hold off
end


  
