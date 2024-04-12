function cc = cell_copy(c,i0,i1)
%
% cc = cell_copy(c,i0,i1)
%
% c   cellarray
% i0  first index
% last index to copy

  cc = cell(1,i1-i0+1);
  icc = 0;
  for i=i0:i1
    icc = icc+1;
    cc{icc} = c{i};
  end
end