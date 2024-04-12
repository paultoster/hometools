function  ifound = str_find_f(text_string,text_such,regel)
%
%  ifound = str_find_f(text_string,text_such,regel)
%
% Sucht text_such in text_string nach der Regel:
% 'vs' vorwärts suchen
% 'rs' rückwerts suchen
% 'vn' vorwärts suchen bis nicht mehr auftritt
% 'rn' rückwerts sucjen bis nicht mehr auftritt
%
% Gibt die gesuchte Stelle zurück
% wenn nicht gefunden, dann 0 zurückgegeben

if( ~exist('regel','var' ) )
    regel = 'vs';
elseif( isempty(regel) )
    regel = 'vs';
elseif( length(regel) == 1 )
  if(  (regel(1) ~= 'v') && (regel(1) ~= 'V') ...
    && (regel(1) ~= 'r') && (regel(1) ~= 'R') ...
    )
    regel = 'v';
  end
  regel = [regel;'s'];
else
  if(  (regel(1) ~= 'v') && (regel(1) ~= 'V') ...
    && (regel(1) ~= 'r') && (regel(1) ~= 'R') ...
    )
    regel(1) = 'v';
  end
  if(  (regel(2) ~= 's') && (regel(2) ~= 'S') ...
    && (regel(2) ~= 'n') && (regel(2) ~= 'N') ...
    )
    regel(2) = 's';
  end
end

if( iscell(text_string) )
  text_string = text_string{1};
end
if( iscell(text_such) )
  text_such = text_such{1};
end

i = strfind(text_string,text_such);
    
% String Suchen
if( (regel(2) == 's' || regel(2) == 'S') )
        
    % nichts gefunden
    if length(i) == 0
        ifound = 0;
        
    % vorwärts suchen
    elseif( (regel(1) == 'v' || regel(1) == 'V') )
        ifound = min(i);
        
    % rückwärts suchen
    else
        ifound = max(i);
    end
    return;

% Suchen wenn string nicht auftritt
else
    
    % vorwärts
    if( (regel(1) == 'v' || regel(1) == 'V') )
        
        % grösste gefunden <stelle + Länge des such-strings
        ifound = 0;
        for ic=1:length(text_string)
            found_flag = 0;
            for ii=1:length(i)
                if( ic == i(ii) )
                    found_flag = 1;
                    break;
                end
            end
            if( ~found_flag )
                ifound = ic;
                break;
            end
        end
        
    % rückwärts
    else
        
        ifound = 0;
        for ic=length(text_string):-1:1
            found_flag = 0;
            for ii=length(i):-1:1
                if( ic == i(ii) )
                    found_flag = 1;
                    break;
                end
            end
            if( ~found_flag )
                ifound = ic;
                break;
            end
        end

    end
end

        
    
    
    