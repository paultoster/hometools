%==========================================================================
function [yvec,ypvec,yppvec] = BSplineCalcVec(obj,xvec)
%
% yvec = BSplineCalc(obj,xvec)
% [yvec,ypvec,yppvec] = BSplineCalc(obj,xvec)
%
% calculate spline with xvec
%
% obj          structure from BSplineDef(d,dx,xvec,yvec)
% xvec         x-Vector Input
% yvec         y-Vector Output
% ypvec        yp-Vector Output 1. derivation dy/dx
% yppvec       ypp-Vector Output 2. derivation d2y/dx2
%
 n      = length(xvec);
 yvec   = xvec * 0.0;
 ypvec  = xvec * 0.0;
 yppvec = xvec * 0.0;
 for i=1:n
   [yvec(i),ypvec(i),yppvec(i)] = BSplineCalc(obj,xvec(i));
 end
end
