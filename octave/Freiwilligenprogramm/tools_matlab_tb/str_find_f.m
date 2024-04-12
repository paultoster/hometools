function  ifound = str_find_f(text_string,text_such,regel)
%
%  ifound = str_find_f(text_string,text_such,regel)
%
% Sucht text_such in text_string nach der Regel:
% 'vs' vorw�rts suchen
% 'rs' r�ckwerts suchen
% 'vn' vorw�rts suchen bis nicht mehr auftritt
% 'rn' r�ckwerts sucjen bis nicht mehr auftritt
%
% Gibt die gesuchte Stelle zur�ck
% wenn nicht gefunden, dann 0 zur�ckgegeben

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
        
    % vorw�rts suchen
    elseif( (regel(1) == 'v' || regel(1) == 'V') )
        ifound = min(i);
        
    % r�ckw�rts suchen
    else
        ifound = max(i);
    end
    return;

% Suchen wenn string nicht auftritt
else
    
    % vorw�rts
    if( (regel(1) == 'v' || regel(1) == 'V') )
        
        % gr�sste gefunden <stelle + L�nge des such-strings
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
        
    % r�ckw�rts
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

        
    
    
    