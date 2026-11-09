function curves(g,G,b,B,gamma,Delta,redQ_tr,s_tr,pred,pname,infoWedge) 
%
% CURVES() plots trust region ball, taboo surface, wedge boundary,
% objective model contours and and More'-Sorensen step (as an arrow)
% for 2D problems.
%

xmin = -Delta; 
xmax =  Delta;

ymin = -Delta;
ymax =  Delta;

N = 100;
clf
axis square

[X, Y] = meshgrid(xmin : (xmax - xmin)/N : xmax, ymin : (ymax - ymin)/N : ymax);
% Taboo surface
T = 1/2*( B(1,1)*X.^2 + B(2,2)*Y.^2 ) + B(1,2)*X.*Y + b(1)*X + b(2)*Y;
% Trust region ball
C = X.^2 + Y.^2;
% Wedge
W = abs(T) - gamma*sqrt(C).*sqrt( 1 + 1/2*C );
% objective model
Q = g(1)*X + g(2)*Y + 1/2*( G(1,1)*X.^2 + G(2,2)*Y.^2 ) + G(1,2)*X.*Y;

xlabel('x_1'); ylabel('x_2'); 
if (infoWedge == 2) | (infoWedge == 3)
   WedgeIs = 'Active';
else
   WedgeIs = 'Inactive';
end
title([pname, '     \gamma = ', num2str(gamma), ' - Wedge: ', WedgeIs])
hold on
contour(X, Y, T, [0, 0], '-k')               % taboo surface in black
contour(X, Y, C, [Delta^2, Delta^2], '-g')   % trust region ball in green
contour(X, Y, W, [0, 0], '-r')               % wedge boundary in red
%contour(X, Y, Q, 0:(-redQ_tr)/3:(-redQ_tr), ':k')  % model obj in black
arrow([0;0], s_tr)                           % More'-Sorensen step
hold off



