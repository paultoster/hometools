function index = find_trigger(signal,threshold,type)
%
% [found,index] = find_trigger(signal,threshold,type)
% signal              vec mit Signal
% threshold           Schwelle
% type                '>' wert grösser Schwelle
%                     '<' wert kleiner Schwelle
%                     '->' wert durchtritt Schwelle nach oben
%                     '<-'  wert durchtritt Schwelle nach unten
%
% index = 0           nicht gefunden
% index > 0           Triggerindex
%
  index = 0;
  if(  ~strcmp(type,'>') && ~strcmp(type,'<') ...
    && ~strcmp(type,'->') && ~strcmp(type,'<-') )
    error('type muß sein (siehe Hilfe) (''>'',''<'',''->'',''<-'') type=%s',type);
  end
    
  enable_flag = 0;
  if(  strcmp(type,'>') ) % wert grösser Schwelle
      % index suchen
      for j=1:length(signal)        
          if( signal(j) > threshold )
              index = j;
              break;
          end
      end
  elseif( strcmp(type,'<') ) % wert kleiner Schwelle
      % index suchen
      for j=1:length(signal)        
          if( signal(j) < threshold )
              index = j;
              break;
          end
      end
  elseif(  strcmp(type,'->') ) % wert durchtritt Schwelle nach oben
      % index suchen
      for j=1:length(signal)
          if( signal(j) < threshold )
              enable_flag = 1;
          end
          if( signal(j) > threshold & enable_flag )
              index = j;
              break;
          end
      end
  elseif( strcmp(type,'<-') ) % wert durchtritt Schwelle nach unten
      % index suchen
      for j=1:length(signal)        
          if( signal(j) > threshold )
              enable_flag = 1;
          end
          if( (signal(j) < threshold) & enable_flag)
              index = j;
              break;
          end
      end
  end


end

