function  text_string = str_change_once_f(text_string,text_such,text_ersetz)
%
%function  text_new = str_change_f(text_string,text_such,text_ersetz)
%
% Sucht text_such in text_string und ersetzt mit text_ersetz 
%
% sucht einmal alles durch
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
            text_string{k,j} = str_change_sub(text_string{k,j},text_such{i},text_ersetz{min(n_text_ersetz,i)});
        end
      end
    end
  else

    for i=1:n_text_such
        text_string = str_change_sub(text_string,text_such{i},text_ersetz{min(n_text_ersetz,i)});
    end
  end
end
function  text_new = str_change_sub(text_string,text_such,text_ersetz)

  c_split = str_split(text_string,text_such);
  n = length(c_split);
  if( n > 1 )
    text_new = [c_split{1},text_ersetz];
  
    for i=2:n
      text_new = [text_new,c_split{i}];
      if( i < n )
        text_new = [text_new,text_ersetz];
      end
    end
  else
    text_new = text_string;
  end
end
