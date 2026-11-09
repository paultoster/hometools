function [s,alpha,kappa,dkappa,time] = path_calc_aplha_kappa(x,y,TypeOfCurvePreCalc,dscalc,dsmin,out_dscalc,tvec)
%
% [s,alpha,kappa,dkappa,time] = path_calc_aplha_kappa(x,y,TypeOfCurvePreCalc,dscalc,dsmin,out_dscalc,tvec)
% [s,alpha,kappa,dkappa]      = path_calc_aplha_kappa(x,y,TypeOfCurvePreCalc)
%
% Precalculation of Path y = f(x) n-Points
%
% TypeOfCurvePreCalc = 0   :   curvature at knot (default 0 )
% TypeOfCurvePreCalc = 1   :   curvature between knot
% TypeOfCurvePreCalc > 1   :   curvature by estimatin radius with
%                              n = TypeOfCurvePreCalc points
% dscalc           calculate alpha and kappa with s in dscalc distance
%                  (default = 0.0)
% dsmin            limit of distance from two next points (default 0.01 )
% out_dscalc       = 1 => Output in dscalc difference in distance (default 0 )
%                         does not fit with x,y
% tvec             der dazu gehörige Zeitvektor 
%
% s                displacement from path fom knot to knot
% alpha            gradient atan(dy/dx) at knot
% kappa            curvature at knot
% dkappa           derivation
% time             dazughörige Zeit wenn tvec vorgegeben
%
  time  = 0;
  if( ~exist('TypeOfCurvePreCalc','var') )
    TypeOfCurvePreCalc = 0;
  end

  if( ~exist('dscalc','var') )
    dscalc = 0.0;
  end
  if( dscalc > 1e-10 )
    if(TypeOfCurvePreCalc > 1)
      recalc = 3;           % Krümmung aus n = TypeOfCurvePreCalc Punkten mit Radius mit größerem Abstand schätzen
    else
      recalc = 1;           % Krümmung aus delta(Alpha)/ds mit größerem Abstand
    end
  elseif( TypeOfCurvePreCalc > 1 )
    recalc = 2;           % Krümmung aus n = TypeOfCurvePreCalc Punkten mit Radius schätzen
  else
    recalc = 0;           % Krümmung aus delta(Alpha)/ds mit gegebenen Punkten Schätzen
  end
 
  if( ~exist('dsmin','var') )
    dsmin = 0.01;
  end
  
  if( ~exist('out_dscalc','var') )
    out_dscalc = 0;
  end
  
  if( ~exist('tvec','var') )
    tvec_flag = 0;
  else
    tvec_flag = 1;
  end

  n     = min(length(x),length(y));

  [s,ds,alpha] = vek_2d_s_ds_alpha(x,y,0.0);
  
  dds = max(s)-min(s);
  
  if( dds <= dsmin )
    alpha = s*0.0;
    kappa = s*0.0;
    dkappa = s*0.0;
    if( tvec_flag )
     time = s*0.0;
    end
    return;
  end
  
  % Nach dslim aussortieren
  slim     = 0.0;
  xlim     = x(1);
  ylim     = y(1);
  slast    = slim;
  alphalim = alpha(1);
  if( tvec_flag )
   timelim  = tvec(1);
  end
  for i=2:n
    if( s(i)-slast > dsmin )
      xlim  = [xlim;x(i)];
      ylim  = [ylim;y(i)];
      slim  = [slim;s(i)];
      alphalim  = [alphalim;alpha(i)];
      if( tvec_flag )
        timelim   = [timelim;tvec(i)];
      end
      slast = s(i);
    end
  end
  dslim    = [diff(slim);ds(n)];
  nlim     = length(dslim);
  if( nlim > 3 )

    if( recalc == 0 )
      kappalim  = path_calc_kappa(alphalim,dslim,nlim,TypeOfCurvePreCalc);
      dkappalim = kappalim*0.0;
      for i=1:nlim-1
        dkappalim(i) = (kappalim(i+1)-kappalim(i))/dslim(i);
      end
      dkappalim(nlim) = dkappalim(max(1,nlim-1));
      
      smod                 = slim;
      nmod                 = length(smod);
      alphamod             = alphalim;
      dsmod                = [diff(smod);0.0];
      kappamod             = kappalim;
      dkappamod            = dkappalim;
      if( tvec_flag )
        timemod            = timelim;
      end
      
    elseif( recalc == 1 )

      smod                 = (slim(1):dscalc:slim(nlim))';
      nmod                 = length(smod);
      smod                 = [smod;smod(nmod)+dscalc];
      
      alphamod             = interp1(slim,alphalim,smod,'linear','extrap');
      if( tvec_flag )
        timemod            = interp1(slim,timelim,smod,'linear','extrap');
      end
      dsmod                = smod*0.0+dscalc;
      kappamod             = path_calc_kappa(alphamod,dsmod,nmod,TypeOfCurvePreCalc);
      dkappamod            = [diff(kappamod);0.0];
      [kappalim,dkappalim] = spline_akima( smod,kappamod,slim );
      
      nmod                 = nmod - 1;
      smod                 = smod(1:nmod);
      alphamod             = alphamod(1:nmod);
      if( tvec_flag )
        timemod            = timemod(1:nmod);
      end
      dsmod                = dsmod(1:nmod);
      kappamod             = kappamod(1:nmod);
      dkappamod            = dkappamod(1:nmod);
            
    elseif( recalc == 2 )
      kappalim  = path_calc_kappa_radius_estimation(xlim,ylim,nlim,TypeOfCurvePreCalc);
      dkappalim = kappalim*0.0;
      for i=1:nlim-1
        dkappalim(i) = (kappalim(i+1)-kappalim(i))/dslim(i);
      end
      dkappalim(nlim) = dkappalim(nlim-1);
      
      smod                 = slim;
      nmod                 = length(smod);
      alphamod             = alphalim;
      if( tvec_flag )
        timemod            = interp1(slim,timelim,smod,'linear','extrap');
      end

      dsmod                = [diff(smod);0.0];
      kappamod             = kappalim;
      dkappamod            = dkappalim;
    else
      smod                 = (slim(1):dscalc:slim(nlim))';
      nmod                 = length(smod);
      alphamod             = interp1(slim,alphalim,smod,'linear','extrap');
      if( tvec_flag )
        timemod            = interp1(slim,timelim,smod,'linear','extrap');
      end
      xmod                 = interp1(slim,xlim,smod,'linear','extrap');
      ymod                 = interp1(slim,ylim,smod,'linear','extrap');
      kappamod             = path_calc_kappa_radius_estimation(xmod,ymod,nmod,TypeOfCurvePreCalc);
      [kappalim,dkappalim] = spline_akima( smod,kappamod,slim );
    end
    if( out_dscalc )
      s      = smod;
      alpha  = alphamod;
      kappa  = kappamod;
      dkappa = dkappamod;
      if( tvec_flag )
        time   = timemod;
      end
    else
      kappa  = interp1(slim,kappalim,s,'linear','extrap');
      dkappa = interp1(slim,dkappalim,s,'linear','extrap');
      alpha  = interp1(slim,alphalim,s,'linear','extrap');
      if( tvec_flag )
        time   = interp1(slim,timelim,s,'linear','extrap');
      end
    end
  else
    if( out_dscalc )
      s      = 0.;
      alpha  = 0.;
      kappa  = 0.;
      dkappa = 0.;
    else
      kappa  = s*0.0;
      dkappa = s*0.0;
      alpha  = s*0.0;
    end
  end
end
