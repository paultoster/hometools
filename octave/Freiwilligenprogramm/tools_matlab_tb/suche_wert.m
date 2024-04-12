function y0 = suche_wert(x,y,x0,Methode)
Version = 1.0;
% 17.01.01 TBert 1. Version aus Matrixx

if nargin == 0,
   fprintf('---------------------------------------------------\n')
   fprintf('| (Version %5.3f)\n',Version)
   fprintf('| y0 = suche_wert(x,y,x0)\n')
   fprintf('| y0 = suche_wert(x,y,x0,wie)\n')
   fprintf('| \n')   
   fprintf('| Sucht Wert von y=f(x) mit Interpolation\n')
   fprintf('| (x muß monoton steigend sein)\n')
   fprintf('| mit der Methode = ''nearest'' ''linear'' ''spline'' ''cubic''\n')
   fprintf('|                  (default=''linear'')\n')
   fprintf('---------------------------------------------------\n')
   return    
elseif nargin > 0 & nargin < 3,
   fprintf('---------------------------------------------------\n')
   fprintf('| y0 = suche_wert(x,y,x0)\n')
   fprintf('| y0 = suche_wert(x,y,x0,wie)\n')
   fprintf('| Zu wenige Argumente\n')
   error('---------------------------------------------------\n')
elseif nargin == 3
   Methode = 'linear';
end

if ~strcmp(Methode,'nearest') & ~strcmp(Methode,'linear') & ~strcmp(Methode,'spline') & ~strcmp(Methode,'cubic') ,
%    
   Methode = 'linear'
end


if ~ist_monoton_steigend(x)
   error('x ist nicht monoton steigend')
end

y0 = interp1(x,y,x0,Methode);

      