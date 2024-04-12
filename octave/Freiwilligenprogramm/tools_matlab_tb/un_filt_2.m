function [x_filt,xp_filt,xpp_filt] = un_filt_2(x_input,g,dt)
%
% [x_filt,xp_filt,xpp_filt] = un_filt_2(x_input,g,dt)
% Filter von Ullrich Neumann mit eineme Polynomenansatz
% Über 0.0 < g < 1.0 wird Gewichtung der Berücksichtigung der Vergangenheit eingestellt

g  = min(0.999,max(0.001,g));
dt = max(1e-10,abs(dt));


a11 = g^2;
a12 = dt*g^2;
a13 = 0.5 * dt^2 * g^2;

a21 = -(g-1)^2/dt;
a22 = -g*(g-2);
a23 = 0.25 * dt * (1+3*g+3*g^2-3*g^3);

a31 = ((-1+g)^3) / dt/dt;
a32 = ((-1+g)^3) / dt;
a33 = 0.5 * (1+3*g-3*g^2+g^3);

b1 = (1-g^3);
b2 = 3/2/dt*((1-g)^2)*(1+g);
b3 = ((1-g)^3)/dt/dt;


x_filt  = x_input*0;
xp_filt = x_input*0;
xpp_filt = x_input*0;

x  = x_input(1);
xp = 0;
xpp = 0;

for i=1:length(x_input)
    
    x0  = x;
    xp0 = xp;
    xpp0 = xpp;
    
    x   = a11*x0 + a12*xp0 + a13*xpp0 + b1*x_input(i);
    xp  = a21*x0 + a22*xp0 + a23*xpp0 + b2*x_input(i);
    xpp = a31*x0 + a32*xp0 + a33*xpp0 + b3*x_input(i);
    

    x_filt(i)   = x;
    xp_filt(i)  = xp;
    xpp_filt(i) = xpp;
        
end
