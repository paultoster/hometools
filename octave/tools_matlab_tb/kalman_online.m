function s = kalman_online(s,u,z)
%
% s = kalman_online(s,u,x)
%

% Time-Update (Prädiktion)
s.xm = s.A * s.x + s.B * u;
s.Pm = s.A * s.P *s.A' + s.Q;

% Measurement-Update (Korrektur)
% Berechnung Kalman-Verstärkung
M = (s.H * s.Pm) * s.H' + s.R;

if( det(M) < 1e-10 )
  error('zu invertierende MAtrix s.H * s.Pm * s.H'' kann nicht invertiert werden det == 0 ')
end

s.K = (s.Pm * s.H') * inv(M);
% Korrektur Zustände
s.x = s.xm + s.K*(z - s.H * s.xm);
% Korrektur Kovarianzmatrix
s.P = (s.I - s.K * s.H) * s.Pm;


