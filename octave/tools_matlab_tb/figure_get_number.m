function number = figure_get_number(fig)
%
% number = figure_get_number(fig)
%
% figm        figure - number or struct (ab R2004b) z.B. mit fig = figure()
%             or fig = plot() etc.    
  number = 0;
  if( isobject(fig) ) % ab R2014b 8.4.0
    while( ~cell_find_f(properties(fig),'Number') )
      if( cell_find_f(properties(fig),'Parent') )
        fig = fig.Parent;
      else
        break;
      end
    end
    if( cell_find_f(properties(fig),'Number') )
      number = fig.Number;
    end
  else % bis R2014b 8.3.0
    number  = fig;
  end
end

