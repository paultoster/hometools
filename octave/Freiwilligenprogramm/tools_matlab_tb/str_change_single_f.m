function  text_string = str_change_single_f(text_string,text_such,text_ersetz,regel)
%
%function  text_new = str_change_f(text_string,text_such,text_ersetz,regel)
%
% Sucht text_such in text_string und ersetzt mit text_ersetz wenn text_string alleine steht
% Es wird nach der Regel:
% 'a' alle (default)
% 'v' vorwärts einmal
% 'r' rückwärts einmal
% gesucht.
% text_string kann auch ein cellarray sein, das mehrere Textstücke enthält
% text_such kann auch ein cell-array mit mehreren suchstringssein
% wenn text_ersetz auch cell-strings, dann werden die entsprechende
% position verwendet
%
  if( nargin == 0 )
      text_string = '';

      fprintf('function  text_new = str_change_single_f(text_string,text_such,text_ersetz,regel)\n')
      fprintf('\n')
      fprintf(' text_string  (char,cell)    zu änderenden Text\n')
      fprintf(' text_such    (char,cell)    zu suchender Text\n')
      fprintf(' text_ersatz  (char)    zu ersetzender Text\n')
      fprintf(' regel        (char)    regel ''a'' alle (default) ''v'' vorwärts einaml ''r'' rückwarts einmal\n')
      fprintf('\n')
      fprintf(' text_new     (char)    zurückgegebener Text \n')
      return
  end

  if( nargin == 3 )

      regel = 'a';
  end

  if( ischar(text_such) )
      text_such = {text_such};
  end
  n_text_such = length(text_such);
  
  if( ischar(text_ersetz) )
      text_ersetz = {text_ersetz};
  end
  n_text_ersetz = length(text_ersetz);

  if( iscell(text_string) )
    cell_flag = 1;
    [n_cells,m_cells] = size(text_string);
  else
    cell_flag = 0;
  end

  if( cell_flag )

    for k=1:n_cells
      for j=1:m_cells
        for i=1:n_text_such
            text_string{k,j} = str_change_sub(text_string{k,j},text_such{i},text_ersetz{min(n_text_ersetz,i)},regel);
        end
      end
    end
  else

    for i=1:n_text_such
        text_string = str_change_sub(text_string,text_such{i},text_ersetz{min(n_text_ersetz,i)},regel);
    end
  end
end
function  text_new = str_change_sub(text_string,text_such,text_ersetz,regel)

  go_on = 1;
  while( go_on )

      ivec = strfind(text_string,text_such);
      l1 = length(text_string);
      l2 = length(text_such);
      l3 = length(text_ersetz);
      % Prüfen, ob dieser String alleine steht
      nivec = [];
      for i = 1:length(ivec)
        ii = ivec(i);
        %nachbar hinten
        i0 = ii+l2;
        i1 = i0+l2-1;
        % nachbat vorne
        ii0 = ii-l2;
        ii1 = ii-1;
        a = 2;
        % Vergleich vorne
        if( (ii0 < 1) || ~strcmp(text_string(ii0:ii1),text_such) )
          a = a-1;
        end
        if( (i1 > l1) || ~strcmp(text_string(i0:i1),text_such) )
          a = a-1;
        end
        if( a == 0 )
          nivec = [nivec,ii];
        end 
      end  
      ivec = nivec;
    % nichts gefunden
    if( isempty(ivec) )
          text_new = text_string;
          break;
    end

    % String Suchen vorwärts
    if( (regel(1) == 'v') | (regel(1) == 'V') )
          ielim = min(ivec);
          go_on = 0;

    elseif( (regel(1) == 'r') | (regel(1) == 'R') )
          ielim = max(ivec);
          go_on = 0;
    else
          ielim = min(ivec);
          go_on = 1;
    end

    if( ielim == 1 )
          text_new = [text_ersetz,text_string(ielim+l2:l1)];
      elseif( ielim+l2 > l1 )
          text_new = [text_string(1:ielim-1),text_ersetz];
      else
          text_new = [text_string(1:ielim-1),text_ersetz,text_string(ielim+l2:l1)];
      end

      if( go_on )
          text_string = text_new;
      end
  end
end
