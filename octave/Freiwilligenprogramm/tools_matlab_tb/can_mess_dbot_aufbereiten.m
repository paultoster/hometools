function dbot = can_mess_dbot_aufbereiten(pbot)
%
% Wandelt CAN-Messungen, die in pbot vorliegen in dSpae-Struktur mit
% äquvidistanter Abtastung
%
% dbot.X.Name='time'        char     Name des X-vektors
%       .Type=4
%       .Data               double  Zeitvektor über alle Zeiten und
%                                   minimaler Abtastung
%       .Unit='s'
%dbot.Y(i).Name             char    Botschaftsname_Signalname
%         .Type=5
%         .Data             double  Vektor
%         .Unit             char    Einheit, sofern da
%dbot.Comment              cell     cell-Array mit Kommentar 

npbot = length(pbot);

% Zeitvektor bestimmen:
%======================
time0 = min(pbot(1).time);
time1 = max(pbot(1).time);

for ipbot=2:npbot
    
    time0 = min(min(pbot(ipbot).time),time0);
    time1 = max(max(pbot(ipbot).time),time1);
end
dt    = time1-time0;
time00 = time0;
time11 = time1;
for ipbot=1:npbot
    
    time0 = max(min(pbot(ipbot).time),time0);
    time1 = min(max(pbot(ipbot).time),time1);
    
    dt    = min(mean(diff(pbot(ipbot).time)),dt);
    
end
if( time1 <= time0 || (time1-time0) < 0.1*(time11-time00) )
    time0 = time00;
    time1 = time11;
end

dt = max(dt,1e-10);

time = [time0:dt:time1]';

dbot.X.Name = 'time';
dbot.X.Type = 4;
dbot.X.Data = time;
dbot.X.Unit = 's';

%Signale erstellen
%=================
is = 0;
for ipbot=1:npbot
    
    % Zeitvektor korrigieren, wenn nötig
    dtmean = mean(diff(pbot(ipbot).time));
    for iv = 2:length(pbot(ipbot).time)
    
        if( pbot(ipbot).time(iv) - pbot(ipbot).time(iv-1) < dtmean/10 )
        
            pbot(ipbot).time(iv) = pbot(ipbot).time(iv-1)+dtmean/10;
        end
    end
    
    nsig = length(pbot(ipbot).sig);

    for isig=1:nsig
       
        is = is+1;
        
        % Name
        if( length(pbot(ipbot).name) == 0 )
            Name = [pbot(ipbot).identhex,'_',pbot(ipbot).sig(isig).name];
        else
            Name = [pbot(ipbot).name,'_',pbot(ipbot).sig(isig).name];
        end
        Name = str_change_f(Name,'__','_','a');
        dbot.Y(is).Name = Name;
        % Type
        dbot.Y(is).Type = 5;
        % Unit
        dbot.Y(is).Unit = pbot(ipbot).sig(isig).einheit;
        
        % Werte
        if( length(pbot(ipbot).time) > 1 )
            dbot.Y(is).Data = interp1(pbot(ipbot).time,pbot(ipbot).sig(isig).vec,time,'linear');
        else
            dbot.Y(is).Data = time*0;
            for it = 1:length(time)
                if( time(it) >= pbot(ipbot).time(1) )
                    dbot.Y(is).Data(it) = pbot(ipbot).sig(isig).vec(1);
                end
            end
        end
    end
end



