function [xout,yout,sout,alphaout,coout,c1out,errflag] = path_calc_smooth_path(xin,yin,delta_s_min)
%
% [xout,yout] = path_calc_smooth_path(xin,yin,delta_s_min)
%
% legt einen neuen Path an mit gleicher Punktszahl, aber minimum distanz
% , indem die nächsten Punkte delta_s im Abstand
% sind, letzter Punkt wird übernommen, wenn abstand größer 0.01 (1 cm)
% ist
  alphaout = [];
  coout = [];
  n     = min(length(xin),length(yin));
  ss     = 0;
  s1     = 0;
  x1     = xin(1);
  xx     = x1;
  y1     = yin(1);
  yy     = y1;
  n1     = 1;

  errflag = 1;
  for i=1:n-1      
    dx       = xin(i+1)-xx;
    dy       = yin(i+1)-yy;
    ds       = sqrt(dx*dx+dy*dy);
    if( ds > 0.001 )
      errflag = 0;
      n1  = n1 + 1;
      ss  = ss+ds;
      xx  = xin(i+1);
      yy  = yin(i+1);
      s1  = [s1;ss];
      x1  = [x1;xx];
      y1  = [y1;yy];
    end
  end
  if( errflag )
    warning('path_calc_smooth_path: Keine unterschiedlichen Punkte gefunden ds < 0.001')
    xout     = xin;
    yout     = yin;
    sout     = xin*0.0;
    alphaout = xin*0.0;
    coout    = xin *0.0;
    c1out    = xin * 0.0;
  else
    delta_s = max(delta_s_min,ss/(n-1));
  
    fprintf('path_calc_smooth_path: delta_s = %f\n',delta_s); 

    sout = [s1(1):delta_s:s1(n1)]';
    nout = length(sout);

    if( s1(n1)-sout(nout) > 0.01 )
      sout = [sout;s1(n1)];
      nout = length(sout);
    end
  
    xout = x1;
    yout = y1;
  
  
    if( nargout > 3 )
      [sout,alphaout,coout,c1out] = path_calc_aplha_kappa(xout,yout);
    end
  end
  
end