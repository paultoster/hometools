function[runflag,index,run_time,newflag] = handle_index_demand(index,run_time,time,ntime,ttext)
%
% [runflag,index,run_time] = handle_index_demand(index,run_time,time,ntime,ttext)
%
% index       aktueller index (wenn null noch nicht initialisiert)
% run_time    aktueller Zeitpunkt zur Betrachtung start time(1)
% time        Zeitvektor
% ntime       dim time
% ttext       zusätzliche Ausgabe (default ttetxt = '')
%
% Ausgabe:
% runflag     = 1 weiter
%             = 0 Ende
% index       aktueller index (wenn null noch nicht initialisiert)
% run_time    aktueller Zeitpunkt zur Betrachtung start time(1)
%
  runflag  = 1;
  newflag  = 0;
  
  if( ~exist('ttext','var') )
    ttext = '';
  end
  if( index )
    fprintf('time(index) = %f(%i)\n',time(index),index)
  end
  fprintf('min/max = %f/%f\n',time(1),time(ntime))
  if( ~isempty(ttext) )
    fprintf('%s\n',ttext);
  end
  option = input('[e(nde),n(ew)][Zeit,+,-]{z.B. 10.2,n2.1,+,n-,e} : ','s');
    
  if( strcmp(option(1),'e') )
    runflag = 0;
  else
    if( strcmp(option(1),'n') )
      newflag = 1;
      option = option(2:end);
    end
      
    if( strcmp(option(1),'+') )
      
      index    = such_index(time,run_time);  
      index    = min(index+1,ntime);  
      run_time = time(index);
    
    elseif( strcmp(option(1),'-') )
      
      index    = such_index(time,run_time);  
      index    = max(index-1,1);  
      run_time = time(index);
      
    else
      try
        t        = str2double(option);
        index    = such_index(time,t);
        run_time = time(index);
      catch
        run_time = time(1);
      end
    end
  end
end
