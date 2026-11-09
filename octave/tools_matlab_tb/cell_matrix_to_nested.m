function cout = cell_matrix_to_nested(cin)
%
% cout = cell_matrix_to_nested(cin)
%
% changes a matrix cell to nested cell arrays
%
% a=cell(2,2);
% a{1,1} = 'a';
% a{1,2} = 'b';
% a{2,1} = 'c';
% a{2,2} = 'd';

  if( ~iscell(cin) )
    error('Input is not a cell array');
  end


[m,n] = size(cin);

if( n == 1 )
  cout = cin;
else
  cout = {};
  for i=1:m
    cc = {};
    for j=1:n
      cc = cell_add(cc,cin{i,j});
    end
    cout = cell_add(cout,cc,1);
  end
end
      