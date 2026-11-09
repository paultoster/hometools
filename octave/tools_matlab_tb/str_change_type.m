function  text_string = str_change_type(text_string,type)
%
% text_string = str_change_type(text_string,type)
%
% type = 0      searchtext = '_'  changetext = ' ' default
% type = 1      searchtext = '-'  changetext = '_'
% type = 2      searchtext = ','  changetext = '_'
% type = 3      searchtext = '.'  changetext = '_'
%
% 
% search for searchtext and replace with changetext
%

  if( ~exist('type','var') )
    type = 0;
  end

  switch(type)
    case 0
      text_string = str_change_f(text_string,'_',' ','a');
    case 1
      text_string = str_change_f(text_string,'-','_','a');
    case 2
      text_string = str_change_f(text_string,',','_','a');
    case 3
      text_string = str_change_f(text_string,'.','_','a');
    otherwise
      text_string = str_change_f(text_string,'.','_','a');
      
  end
  
end