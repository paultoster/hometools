% calc_vel_anteile_f()
%input:
% vel      Geschwindigkeitsvektor
% acc      Beschleunigungsvektor
% vel_min  minimale Geschwindigkeit für Standzeit
% acc_min  minimale Beschleunigung für Konstantfahrt
%output:
% santeil Standzeit anteil
% kanteil Konstantfahrt anteil
% banteil Beschleunigungsanteil
% vanteil Verzögerungsanteil
% ranteil Rueckwerstfahrt anteil
%
function [santeil,kanteil,banteil,vanteil,ranteil]     = calc_vel_anteile_f(vel,acc,vel_min,acc_min)

n = length(vel);

if( vel_min < 0 )
    vel_min = vel_min * -1.0;
end
if( acc_min < 0 )
    acc_min = acc_min * -1.0;
end

irueck = 0;
istand = 0;
ikonst = 0;
ibeschl = 0;
iverz = 0;

for i=1:n
    if( vel(i) <= -vel_min )
        irueck = irueck + 1;
    elseif( vel(i) < vel_min )
        istand = istand + 1;
    else
        if( abs(acc(i)) < acc_min )
            ikonst = ikonst + 1;
        elseif( acc(i) >= acc_min )
            ibeschl = ibeschl + 1;
        else
            iverz   = iverz + 1;
        end
    end
end


santeil = istand / n;
kanteil = ikonst / n;
banteil = ibeschl / n;
vanteil = iverz / n;
ranteil = irueck / n;
