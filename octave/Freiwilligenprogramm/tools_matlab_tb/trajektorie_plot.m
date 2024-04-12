function trajektorie_plot(d)
%
%
%
ifig = find_free_ifig(1);
p_figure(ifig,1);
subplot(3,1,2)
plot(d.time,d.vel*3.6,'k')
grid on
xlabel('time [s]')
ylabel('vel [kmh]')
subplot(3,1,1)
plot(d.time,d.acc,'k')
grid on
xlabel('time [s]')
ylabel('acc [m/s/s]')
subplot(3,1,3)
plot(d.time,d.s,'k')
grid on
xlabel('time [s]')
ylabel('s [m]')

ifig = find_free_ifig(ifig);
p_figure(ifig,1);
subplot(3,1,1)
plot(d.time,d.x,'k')
grid on
xlabel('time [s]')
ylabel('x [m]')
subplot(3,1,2)
plot(d.time,d.y,'k')
grid on
xlabel('time [s]')
ylabel('y [m]')
subplot(3,1,3)
plot(d.time,d.s,'k')
grid on
xlabel('time [s]')
ylabel('s [m]')

ifig = find_free_ifig(ifig);
p_figure(ifig,1);
subplot(3,1,1)
plot(d.time,d.kappap,'k')
grid on
xlabel('time [s]')
ylabel('kappap [1/m/s]')
subplot(3,1,2)
plot(d.time,d.kappa,'k')
grid on
xlabel('time [s]')
ylabel('kappa [1/m]')
subplot(3,1,3)
plot(d.time,d.theta*180/pi,'k')
grid on
xlabel('time [s]')
ylabel('theta [deg]')

ifig = find_free_ifig(ifig);
p_figure(ifig,0);
plot(d.x,d.y,'k')
grid on
xlabel('x [m]')
ylabel('y [m]')

ifig = find_free_ifig(ifig);
p_figure(ifig,0);
plot(d.time,d.vel.*d.vel.*d.kappa,'k')
title('Querbeschleunigung ay')
grid on
xlabel('time [s]')
ylabel('ay [m/s/s]')

figmen
zaf('set_silent')

