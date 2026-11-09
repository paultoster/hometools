function [t,vel] = calc_dvec_2_vec(ctvel,dt,t0,vel0)
%
% [t,vel] = calc_dvec_2_vec(ctvel,dt,t0,vel0)
%
%   ctvel = {{dx1,y1,type},...}; Vorgabe mit deltas und 
%                                type = 'lin'    linear auf y1
%                                       'step'   step-Fkt polynom 4. Ord auf y1
%                                       'const'  y1 wird nach dx1 gesetzt
%   ctvel = {{dx1,dy/dt,type,dx1anstieg},...}; Vorgabe mit deltas und 
%                                type = 'gradc'  mit konstanter Ableitung dy/dt bilden
%                                                    dabei wird mit dx1anteig
%                                                    auf den gradienten linear
%                                                    hochgerampt (dx1anteig <
%                                                    dx1)
%                                       
%   Beispiel
%   ctvel = {{04,30.0,'lin'} ...
%         ,{10,30.0,'lin'} ...
%         ,{06,0.0,'step'} ...
%         ,{2,0.0,'const'} ...
%         ,{2,2.0,'gradc',0.2} ...
%         };
%
%   dt                           Schrittweite der Ausgabe
%   t0,vel0                        Startwerte der Vektore
%   Ausgabe
%   t,vel                          Ausgabe vektoren
%

  n = length(ctvel)+1;
  
  % Auflösen
  tt     = zeros(n,1);
  vv     = zeros(n,1);
  dtt    = zeros(n,1);
  ctypes = cell(1,n);
  
  tt(1)     = t0;
  vv(1)     = vel0;
  ctypes{1} = '';
  dtt(1)    = 0.;
  for i=2:n
    cc        = ctvel{i-1};
    tt(i)     = tt(i-1)+cc{1};
    vv(i)     = cc{2};
    ctypes{i} = cc{3};
    if( strcmp(ctypes{i},'gradc') && length(cc) > 3 )
        dtt(i) = cc{4};
    else
        dtt(i) = 0.;
    end
  end 
    
  % Ausgabe t-Vektor Start
  t = t0;
  vel = vel0;
  grad0 = 0.;
  vvlast = vv(1);
  for i=2:n
    ttt = [tt(i-1):dt:tt(i)]';
    nttt = length(ttt);
    
    if( strcmpi(ctypes{i},'lin') )
      
      grad0 = (vv(i)-vvlast)/(tt(i)-tt(i-1));
      vvv = vvlast + grad0*(ttt-tt(i-1));
    elseif( strcmpi(ctypes{i},'const') )
      
      vvv = ttt*0.0+vv(i);
      vvv(nttt) = vvv(nttt)+(vv(i)-vvlast);
      grad0 = 0.;
    elseif( strcmpi(ctypes{i},'step') )
    
      vvv = step_function(ttt,tt(i-1),tt(i),vvlast,vv(i));

      grad0 = (vvv(nttt)-vvv(nttt-1))/(ttt(nttt)-ttt(nttt-1));
      
    elseif( strcmpi(ctypes{i},'gradc') )
      vvv(1) = vvlast;
      for j=2:nttt
        deltattt = ttt(j)-ttt(1);
        if( deltattt < dtt(i) )
          grad = vv(i)*deltattt/dtt(i) + grad0;
        else
          grad = vv(i) + grad0;
        end
        deltattt = ttt(j)-ttt(j-1);
        vvv(j) = vvv(j-1) + grad * deltattt;
      end
      grad0 = grad;
    else
      error('%s_error: type: <%s> ist nicht implementiert',mfilename,ctypes{i});
    end
    vvlast = vvv(nttt);
    t      = [t;ttt(2:nttt)];
    vel      = [vel;vvv(2:nttt)];
    
    if( nargout == 1 )
      Ss.time = t;
      Ss.vel  = vel;
      
      t = Ss;
    end
  end
  
  