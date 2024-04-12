function alpha = vek_2d_winkel(Xg0,Yg0,Xg1,Yg1)
%
% alpha = vek_2d_winkel(Xg0,Yg0,Xg1,Yg1)
%
% Winkel zwischen Gerade G0 und G1, G0 auf G1 gedreht
%
% Xg0 = [xg0_0;xg0_1];
% Yg0 = [yg0_0;yg0_1];
% Xg1 = [xg1_0;xg1_1];
% Yg1 = [yg1_0;yg1_1];
%

% Vergleich Richungsvektor
e0 = vek_2d_EinheitsvektorP(Xg0,Yg0);
e1 = vek_2d_EinheitsvektorP(Xg1,Yg1);

alpha = atan2(e1(2),e1(1)) - atan2(e0(2),e0(1));

if( alpha > pi )
  alpha = alpha - 2*pi;
elseif( alpha < -pi )
  alpha = alpha + 2*pi;
end



