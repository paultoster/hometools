function  text_string = str_change_f(text_string,text_such,text_ersetz,regel)
%
%function  text_new = str_change_f(text_string,text_such,text_ersetz,regel)
%
% Sucht text_such in text_string und ersetzt mit text_ersetz nach der Regel:
% text_string kann auch ein cellarray sein, das mehrere Textstuecke enthaelt
% text_such kann auch ein cell-array mit mehreren suchstringssein
% wenn text_ersetz auch cell-strings, dann werden die entsprechende
% position verwendet
%
% 'a' alle (default)
% 'v' vorwaerts einmal
% 'r' rueckwaerts einmal
% 'ai','vi','ri' independend Gross- Kleinbuchstabe also egal
  if( nargin == 0 )
      text_string = '';

      fprintf('function  text_new = str_change_f(text_string,text_such,text_ersetz,regel)\n')
      fprintf('\n')
      fprintf(' text_string  (char,cell)    zu aenderenden Text\n')
      fprintf(' text_such    (char,cell)    zu suchender Text\n')
      fprintf(' text_ersatz  (char)    zu ersetzender Text\n')
      fprintf(' regel        (char)    regel ''a'' alle (default) ''v'' vorwaerts einaml ''r'' rueckwarts einmal\n')
      fprintf('                        regel ''ai'',''vi'',''ri'' unabhaenging vo Gross-Klein-Schreiben\n')
      fprintf('\n')
      fprintf(' text_new     (char)    zurueckgegebener Text \n')
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
  while( go_on  )
     
    l1 = length(text_string);
    l2 = length(text_such);
    % l3 = length(text_ersetz);
    if( (length(regel) == 2) && (regel(2) == 'i' || regel(2) == 'I') )
      i = [];
      n = max(0,l1-l2+1);
      for ii=1:n
        if( strcmpi(text_string(ii:l2-1+ii),text_such) )
            i = [i,ii];
        end
      end
    else
      i = strfind(text_string,text_such);
    end
    % nichts gefunden
    if( isempty(i) )
          text_new = text_string;
          break;
    end

    % String Suchen vorwaerts
    if( (regel(1) == 'v') || (regel(1) == 'V') )
          ielim = min(i);
          go_on = 0;

    elseif( (regel(1) == 'r') || (regel(1) == 'R') )
          ielim = max(i);
          go_on = 0;
    else
          ielim = min(i);
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
