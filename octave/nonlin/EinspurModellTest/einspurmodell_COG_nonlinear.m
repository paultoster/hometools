function dydt = einspurmodell_COG_nonlinear(t,y,p,d)
% 
% beta = y(1);
% yawp = y(2);

deltaStWhl = interp1(d.time,d.deltaStWhl,t,'linear','extrap');
deltaR     = deltaStWhl / p.isteer;
cdeltaR    = cos(deltaR);

vVeh  = max(2.77,interp1(d.time,d.vVeh,t,'linear','extrap'));
sbeta = sin(y(1));
cbeta = cos(y(1));

alphaFA = deltaR - atan2(vVeh*sbeta+p.lfFzg*y(2),vVeh*cbeta);
alphaRA = -atan2(p.lrFzg*y(2)-vVeh*sbeta,vVeh*cbeta);

nen    = not_zero(p.mFzg*vVeh*cbeta);

dydt = y*0.0;
% betap
dydt(1) = ( cdeltaR*p.CyFA*alphaFA+p.CyRA*alphaRA ) /nen - y(2);
% yawpp
dydt(2) = ( cdeltaR*p.lfFzg*p.CyFA*alphaFA - p.lrFzg*p.CyRA*alphaRA )/p.JzFzg;

