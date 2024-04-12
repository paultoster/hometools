function strout = cell_concatenate_str_cells(cin,verdindung,icellstart)
%
% strout = cell_concatenate_str_cells(cin,verdindung)
% strout = cell_concatenate_str_cells(cin,verdindung,icellstart)
%
% strout = cell_concatenate_str_cells({'abc','def'},'_');
% strout == 'abc_def'
% strout = cell_concatenate_str_cells({'abc',1,'def'},'_');
% strout == 'abc_def'
%
strout = '';

if( ~exist('icellstart','var') )
  icellstart = 1;
end
n      = length(cin);
for i=icellstart:n
  if( ischar(cin{i}) )
    strout = [strout,cin{i}];
    if( i ~= n )
      strout = [strout,verdindung];
    end
  end
end
