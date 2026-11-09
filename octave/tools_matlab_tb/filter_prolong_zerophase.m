function [yfilt,ypfilt] = filter_prolong_zerophase(t,y,t_filt,type)
%
% [yfilt,ypfilt] = filter_prolong_zerophase(t,y,t_filt,type)
%
% Filter mit zweifach gespiegelter Verlängerung am Anfang und Ende, um
% ein guten Anfang und Ende bei zero-phase-Verschiebung zu haben
%
% t      Zeit, bzw. unabhängige Variable
% y      Funktionswert
% t_filt Zeitkonstante
% type   0: pt1-Filter
%        1: butterworth
%
% yfilt   gefilterter Wert
% ypfilt  abgeleiteter Filterwert

  if( ~exist('type','var') )
    type = 0;
  end
  n       = min(length(t),length(y));
  t       = t(1:n);
  y       = y(1:n);
 
  [tpro,ypro,i0,i1] = filter_prolong_zerophase_erweit(t,y,n,round(n/2));
  % Filter
  if( type ) % butterworth
    ypro_f = butter2_filter(tpro,ypro,t_filt,1);
  else
    ypro_f = pt1_filter_zp(tpro,ypro,t_filt);
  end
  % Ableiten
  [yppro_f2, yppro_f] = diff_pt1_zp(tpro,ypro_f,t_filt);
  
  yfilt   = ypro_f(i0:i1);
  ypfilt  = yppro_f(i0:i1);
end
function [sout,vout,i0,i1] = filter_prolong_zerophase_erweit(s,v,n,ne)

  % Vorderes Stück ne spiegeln
  st1 = s(1)-(s(2:ne)-s(1));
  vt1 = v(1)-(v(2:ne)-v(1));
  nt1 = length(st1);
  % Hinteres Stück spiegeln
  st2 = s(n)-(s(n-ne+1:n-1)-s(n));
  vt2 = v(n)-(v(n-ne+1:n-1)-v(n));
  
  sout = [umsortieren(st1);s;umsortieren(st2)];
  vout = [umsortieren(vt1);v;umsortieren(vt2)];
  
  i0   = nt1 + 1;
  i1   = nt1 + n;
  
end
