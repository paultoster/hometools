function dydt = einspurmodell_COG_linear(t,y,p,d)
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
dydt(1) =  p.a11/vVeh * y(1) + (p.a12/vVeh/vVeh-1.0) * y(2) + p.b1/vVeh * deltaStWhl;
% yawpp
dydt(2) = p.a21      * y(1) + p.a22/vVeh            * y(2) + p.b2      * deltaStWhl;

