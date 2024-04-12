% get global variables
i = 1;
filename_string=sprintf('GLOBAL%d_filename',i);
var_size_string=sprintf('GLOBAL%d_var_size',i);
names_string   =sprintf('GLOBAL%d_names',i);
string=sprintf('global %s;',filename_string);
eval(string)
string=sprintf('global %s;',var_size_string);
eval(string)
string=sprintf('global %s;',names_string);
eval(string)
while (exist(var_size_string) == 1)
  if exist(names_string) == 1
    string=sprintf('var_size = %s;',var_size_string);
    eval(string)
    for j=1:var_size(1)
      string=sprintf('names(%d,:) = %s(%d,:);',j,names_string,j);
      eval(string)
      if (i==1)
        string=sprintf('global %s;',names(j,:));
      else
        string=sprintf('global %s_%d;',names(j,:),i);
      end
      eval(string);
    end;
  end
  i = i + 1;
  filename_string=sprintf('GLOBAL%d_filename',i);
  var_size_string=sprintf('GLOBAL%d_var_size',i);
  names_string   =sprintf('GLOBAL%d_names',i);
  string=sprintf('global %s;',filename_string);
  eval(string)
  string=sprintf('global %s;',var_size_string);
  eval(string)
  string=sprintf('global %s;',names_string);
  eval(string)
end
clear i;
clear j;
clear string;
clear names_string;
clear var_size_string;
clear filename_string;
clear names;
clear var_size;
