function f_x = deadtime_filter(t,x,t_deadtime)
%
% f_x = deadtime_filter(t,x,t_deadtime)
%
    if( nargin == 0 )
        fprintf('\nfunction f_x = deadtime_filter(t,x,t_deadtime)');
        fprintf('\n\nDeadTime-Filter');
        f_x = [];
        return
    end

    delta_t = mean(diff(t));
    n       = length(t);
    f_x     = t*0;
    s = deadtime_filter_init(t_deadtime,delta_t,x(1),x(1));

    for i=1:n
      [f_x(i),s] = deadtime_filter_update(s,x(i));
    end

end
function s = deadtime_filter_init(t_deadtime,delta_t,xe,xa)
    s.order   = floor(t_deadtime/not_zero(delta_t));
    s.xe      = ones(s.order+1,1)*xe;
    s.xa      = ones(s.order+1,1)*xa;
    s.b       = zeros(s.order+1,1);
    s.a       = zeros(s.order+1,1);

    s.b(s.order+1) = 1.0;
    s.a(1)         = 1.0;
    s.nb           = s.order;
    s.na           = 0;

end
function [f_x,s] = deadtime_filter_update(s,xin)
  % Zustandsgroessen nach rechts shiften */
  % aktueller Zeitpunkt ist in x[0] abgelegt */

  for i = s.nb+1:-1:2
    s.xe(i) = s.xe(i - 1);
  end
  for i = s.na+1:-1:2
    s.xa(i) = s.xa(i - 1);
  end
  s.xe(1) = xin;                       % aktueller Messwert */

  % neuen Filterausgang berechnen */

  sb = 0.0;                            % Initialisierung */
  sa = 0.0;

  for i=1:1:s.nb+1
    sb = sb + s.b(i) * s.xe(i);
  end
  for i=2:1:s.na+1
    sa = sa + s.a(i) * s.xa(i);
  end
  s.xa(1) = sb - sa;
  f_x = s.xa(1);
end