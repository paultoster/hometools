function [xpmin,xpmax] = scale_limits_for_plot(xmin,xmax,delta)
%
% [xpmin,xpmax] = scale_limits_for_plot(xmin,xmax,delta)
%
% Skaliert für xlim,ylim die obere  untere Schwelle
% xmin      Minimumwert
% xmax      Maximumwert
% [delta]     delta-Schritweite inder geplottet werden soll
%             Wenn wehgelassen wird delta berechnet auf nächste
%             10er-Wert
% 
% xpmax     Skalierter Maximumwert
% xpmin      Skalierter Minimuwert
%
if( xmax < xmin )
    d    = xmax;
    xmax = xmin;
    xmin = d;
end

if( ~exist('delta','var') )
    delta = 10^fix(log10(max(xmax-xmin,1e-300)));
end

xpmax = ceil(xmax/delta)*delta;
xpmin = floor(xmin/delta)*delta;

if( xpmax == xpmin )
    
    xpmax = xpmax + delta/2;
    xpmin = xpmin - delta/2;
end
