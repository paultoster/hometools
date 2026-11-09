
a = 2.5;
b = 0.5;
c = 0.2;

x = [0:0.01:5]';
y = x*0.0;

for i=1:length(x)
  y(i) = sin(a*x(i)+b)+exp(c*x(i));
end

dy = (max(y)-min(y))*0.1;
y  = y + dy * rand(length(x),1);

figure(1)
plot(x,y,'k-')
grid on

d.x = x;
d.y = y;
d.a = a;
d.b = b;
d.c = c;
u.x = 'm';
u.y = 'm';
u.a = '-';
u.b = '-';
u.c = '-';
h   = {};

okay = d_data_save('SinusExpBilder_01',d,u,h,'duh');

