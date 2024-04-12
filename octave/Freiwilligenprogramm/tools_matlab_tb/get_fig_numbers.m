function numvec = get_fig_numbers
%
% get a vector from all figure numbers
% get_fig_numbers
%

  a = get(0,'Children');
  n = length(a);
  if( n == 0 )
    numvec = [];
  elseif( isa(a,'numeric') )
    numvec = a;
  elseif( isa(a,'matlab.ui.Figure') ) % ab Version 2012b
    
    numvec = [];
    for i=1:n
      if( isnumeric(a(i).Number) )
        numvec = [numvec;a(i).Number];
      end
    end
  else
    error('%s: class from get(0,''Children'') notspecified',mfilename);
  end