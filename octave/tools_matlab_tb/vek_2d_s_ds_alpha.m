function [sVec,dsVec,alphaVec,xVec,yVec,indexlisteVec] = vek_2d_s_ds_alpha(Xvec,Yvec,S0,delta_s)
%
% [s,ds,alpha]     = vek_2d_s_ds_alpha(Xvec,Yvec[,S0])
% [s,ds,alpha,x,y] = vek_2d_s_ds_alpha(Xvec,Yvec[,S0],delta_s)
% [s,ds,alpha,x,y,indexliste] = vek_2d_s_ds_alpha(Xvec,Yvec[,S0],delta_s)
%
% Xvec = [x0,x1,x2, ...]
% Yvec = [y0,y1,y2, ...]
% S0                     Startwert (default  0.0)
% delta_s                Wenn delta_s gesetzt wird der s-Vektor 
%                        äquidistant gebildet
%

  if( ~exist('S0','var') )
    S0 = 0.0;
  end
  if( ~exist('delta_s','var') )
    flag_delta_s = 0;
    delta_s = 0.0;
  else
    flag_delta_s = 1;
  end

  % in case of cell array with vektors
  if( iscell(Xvec) && iscell(Yvec) )
    
    n = min(length(Xvec),length(Yvec));
    sVec = cell(1,n);
    dsVec = cell(1,n);
    alphaVec = cell(1,n);
    xVec = cell(1,n);
    yVec = cell(1,n);
    indexlisteVec = cell(1,n);
    
    for i=1:n
      
      if( isempty(Xvec{i}) || isempty(Yvec{i}) )
        s = [];
        ds = [];
        alpha = [];
        x     = [];
        y     = [];
        indexliste =  [];
      else
        if( flag_delta_s )
          [s,ds,alpha,x,y,indexliste] = vek_2d_s_ds_alpha_vec(Xvec{i},Yvec{i},S0,delta_s,flag_delta_s);
        else
          x = [];
          y = [];
          indexliste = [];
          [s,ds,alpha] = vek_2d_s_ds_alpha_vec(Xvec{i},Yvec{i},S0,delta_s,flag_delta_s);
        end
          
      end
      sVec{i} = s;
      dsVec{i} = ds;
      alphaVec{i} = alpha;
      
      xVec{i} = x;
      yVec{i} = y;
      indexlisteVec{i} = indexliste;
     
    end
  % in case of vector
  else
    if( flag_delta_s )
      [sVec,dsVec,alphaVec,xVec,yVec,indexlisteVec] = vek_2d_s_ds_alpha_vec(Xvec,Yvec,S0,delta_s,flag_delta_s);
    else
      xVec = [];
      yVec = [];
      indexlisteVec = [];
      [sVec,dsVec,alphaVec,] = vek_2d_s_ds_alpha_vec(Xvec,Yvec,S0,delta_s,flag_delta_s);
    end
  end
end
function [s,ds,alpha,x,y,indexliste] = vek_2d_s_ds_alpha_vec(Xvec,Yvec,S0,delta_s,flag_delta_s)
      
  n = min(length(Xvec),length(Yvec));


  s     = Xvec *0.0;
  ds    = Xvec *0.0;
  alpha = Xvec *0.0;
  indexliste = Xvec*0;

  s(1) = S0;
  indexliste(1) = 1;

  for i = 2:n
    dx         = Xvec(i)-Xvec(i-1);
    dy         = Yvec(i)-Yvec(i-1);
    ds(i-1)    = sqrt((dx)^2+(dy)^2);
    s(i)       = s(i-1) + ds(i-1);
    if( (i == 2) || (ds(i-1) > eps) )
      alpha(i-1) = atan2(dy,dx);
    else
      alpha(i-1) = alpha(i-2);
    end
    indexliste(i) = i;
  end
  if( n > 1 )
    alpha(n) = alpha(n-1);
    ds(n)    = ds(n-1);
  end

  if(  flag_delta_s  )

    sd = [s(1):delta_s:s(n)]';

    ilist  = 1;
    slast  = s(1);

    for i=2:n
      if( s(i)-slast > eps )
        ilist   = [ilist;i]; 
        slast   = s(i);
      end
    end

    xx = Xvec(ilist);
    yy = Yvec(ilist);
    ss = s(ilist);
    dss = ds(ilist);
    aa  = alpha(ilist);

    indexliste     = interp1(ss,ilist,sd,'nearest','extrap');
    x     = interp1(ss,xx,sd,'linear','extrap');
    y     = interp1(ss,yy,sd,'linear','extrap');
    alpha = vek_2d_s_ds_alpha_build_alpha(x,y);
    s     = sd;
    ds    = vek_2d_build_ds(s);
    
  end
end
function yawvec = vek_2d_s_ds_alpha_build_alpha(xvec,yvec)
%
% yawvec = vek_2d_build_theta(xvec,yvec)
% yawvec = vek_2d_build_theta(xvec,yvec,yawvec,i0,i1)
%
% build yaw angle from path
% i0 = 1,2,3, ...
% i1 = 1,2,3, ... n

  n = min(length(xvec),length(yvec));
  yawvec = xvec(1:n)*0.0;
  for i=2:n
    dx = xvec(i)-xvec(i-1);
    dy = yvec(i)-yvec(i-1);

    yawvec(i-1) = atan2(dy,dx);
  end
  yawvec(n) = yawvec(n-1);
  yawvec = vek_2d_theta_reduce_n_vector(yawvec);
end
