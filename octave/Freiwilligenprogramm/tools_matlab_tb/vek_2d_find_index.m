function [index,d] = vek_2d_find_index(svec,sval,index)
%
% [index,d] = vek_2d_find_index(svec,sval)
% [index,d] = vek_2d_find_index(svec,sval,index_start)
%
% search sval on svec
% with start_index
%
% index       actual Index
% d           portion on svce(index) und svec(index+1)
%

  if( ~exist('index','var') )
    index = 1;
  end
  n = length(svec);
  
  if( n < 2 )
    error('svec zu kurz (n< 2)' );
  end
  val = suche_index(svec,sval,'===','v',eps,index);
  
  index = floor(val);
  d     = val-index;
  
  while( index >= n )
    
    index = index-1;
    d     = d + 1.0;
  end


end