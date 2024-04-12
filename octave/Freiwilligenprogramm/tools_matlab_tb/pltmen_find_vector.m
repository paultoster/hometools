function [name,okay] = pltmen_find_vector( input , input_name, title)


input_class = class(input);
list   ={};
i_list = 0;
okay = 1;
if( strcmp(input_class,'double') )
    [n,m]=size(input);
    if( m == 1 )
        name = sprintf('%s(:,1)',input_name);
        return;
    elseif( n == 1 )
        name = sprintf('%s(1,:)''',input_name);
        return;
    end
    if( n >= m )
        for i=1:m
            i_list=i_list+1;
            list{i_list} = sprintf('%s(:,%i)',input_name,i);
        end
    else
        for i=1:n
            i_list=i_list+1;
            list{i_list} = sprintf('%s(%i,:)',input_name,i);
        end
    end
       
    [i_select,i_okay] = listdlg('PromptString','Suche Vector aus',...
                                'SelectionMode','single', ... 
                                'ListSize',[300,300],...
                                'ListString',list);
    if ~i_okay
        okay = 0;
        return;
    else
           name = list{i_select};
                               
    end
    
elseif( strcmp(input_class,'struct') )
    
    structnames = fieldnames(input);
    
    for j=1:length(structnames)
               
        comand_string=strcat('input_class=class(input.',structnames{j},');');
        eval(char(comand_string));
               
        if strcmp(input_class,'double')
             i_list = i_list+1;
             list{i_list}=sprintf('(double) %s.%s',input_name,structnames{j});
        end
    end
end
name = input_name;
