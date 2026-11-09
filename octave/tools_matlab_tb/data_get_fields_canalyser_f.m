% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function  [okay,d,u,h] = data_get_fields_canalyser_f(s_can)

okay = 1;
d = [];
u = [];
h = {};

% Globale struktur prüfen
if( ~data_is_canalyser_format_f(s_can(1)) )
    okay = 0;
    return
end

% Werte aus s_data.d auswählen
% Feldnamen bestimmen
c_names = fieldnames(s_can(1));

% empty-Vektoren bereinigen
for ic = 1:length(c_names)
    if( strcmp(c_names{ic},'AVL_STEA_DV') )
      a = 1;
    end
    
    if( ~isempty(s_can(1).(c_names{ic})) )
        s_can1.(c_names{ic}) = s_can(1).(c_names{ic});
    end
end
s_can   = s_can1;
c_names = fieldnames(s_can);

% Anzahl der Feldnamen prüfen
clen = length(c_names);
if( clen == 0 )
    okay = 0;
    return
end

% Zeitvektor bilden
t0 = 1e30;
t1 = 0;
dt = 1e30;
for ic = 1:clen
    
    if( isnumeric(s_can(1).(c_names{ic})) && is_monoton_steigend(s_can(1).(c_names{ic})(:,1)) )
        
        [n,m] = size(s_can(1).(c_names{ic}));
        ddd = mean(diff(s_can(1).(c_names{ic})(:,1)));
        if( ddd < 0.0049 )
          fprintf('%s: %f\n',c_names{ic},ddd);
        end
        if( m == 2 )
            
            t0 = min(t0,min(s_can(1).(c_names{ic})(:,1)));
            t1 = max(t1,max(s_can(1).(c_names{ic})(:,1)));
            dt = min(dt,mean(diff(s_can(1).(c_names{ic})(:,1))));
            
            
            if( isempty(t0) )
                t0 = 0.0;
            end
        end
    end
    
end
if( dt == 1e30 )
    okay = 0;
    return
end

d.time = [t0:dt:t1]';
u.time = 's';

%Struktur mit äquidistanten Abtastungswerte linear interlpoliert bilden

for ic = 1:clen

    if( isnumeric(s_can(1).(c_names{ic})) )
        
        [n,m] = size(s_can(1).(c_names{ic}));
        if( m == 2 )
            if( is_monoton_steigend(s_can(1).(c_names{ic})(:,1)) )
                if( length(s_can(1).(c_names{ic})(:,1)) > 1 )
%                  d.(c_names{ic}) = mex_interpolation(s_can(1).(c_names{ic})(:,1),double(s_can(1).(c_names{ic})(:,2)),d.time,1,1,-1.0);
                    d.(c_names{ic}) = interp1(s_can(1).(c_names{ic})(:,1), ...
                                          s_can(1).(c_names{ic})(:,2), ...
                                          d.time,'linear','extrap');
                else
                    d.(c_names{ic}) = d.time*0.0;
                end
                u.(c_names{ic}) = '';
            else
                warning('Zeitsignal des can-Signals <%s> ist nicht monoton steigend',c_names{ic});
            end
        end
    end
end



h{1} = [datestr(now),' read-canalyser-data'];


                       
