function c = str_build_cell_text(tt)
%
% c = str_build_cell_text(text)
%
% bilde aus Text mit Auffinden von '\n' in cellarray mit strings
%
% t           text mit '\n'
% c           cellarrayy mit strings
%

  c = {};
  
  delim = sprintf('\n');
  
  ivec = strfind(tt,delim);

  istart = 1;
  for i=1:length(ivec)
    iend = max(istart,ivec(i)-1);
    t = tt(istart:iend);
    c = cell_add(c,t);
    istart = ivec(i)+1;
  end
  n = length(tt);
  if( istart < n )
    c = cell_add(c,tt(istart:n));
  end
    
end
