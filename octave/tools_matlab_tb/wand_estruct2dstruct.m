function [okay,d]  = wand_estruct2dstruct(e,dt,zero_flag,c_signame,lin_liste)
%
% [okay,d]  = wand_estruct2dstruct(e,dt,zero_flag,c_signame,lin_liste)
%
% e         struct        Struktur mit Vector-Daten e.Name.time und 
%                         e.Name.vec
% dt        double        Zeitschritt
% zero_flag double        Soll Zeit von Null beginnen
% c_signame cell          Liste mit Signalname
% lin_liste double vector Liste mit Linearisierungsflag =1 linearisieren 

  d = struct;

  c_name = fieldnames(e);
  n      = length(c_name);

  if( ~exist('c_signame','var') )
    c_signame = c_name;
  end
  if( ~exist('lin_liste','var') )
    lin_liste = ones(length(c_signame),1);
  end
  
  nliste = min(length(c_signame),min(lin_liste));
  
  % ANfangszeit t0
  t0 = 1e300;
  for i=1:n
    t0 = min(t0,e.(c_name{i}).time(1));
  end
  % Endzeit t1
  t1 = 0;
  for i=1:n
    t1 = max(t1,max(e.(c_name{i}).time));
  end

  d.time = t0:dt:t1';
  u.time = 's';
  for i=1:n
    
    % Einheit
    u.(c_name{i})  = e.(c_name{i}).unit;
    
    lin   = 0;
    for j=1:nliste
      if( c_name{i} == c_signame{j} )
        lin = lin_liste(j);
        reak;
      end
    end
    
    if( lin )  
      d.(c_name{i}) = interp1(e.(c_name{i}).time,e.(c_name{i}).vec,d.time,'linear');
    else
      d.(c_name{i}) = interp1_const(e.(c_name{i}).time,e.(c_name{i}).vec,d.time);
    end
    
    
  
  
  
  
  
end

