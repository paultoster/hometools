%        pltmen_find_vector_function
%        finds Vector from input (matrix, cell or structure)
%        input : input        variable
%                input_name   name of variable
%                title        title  to show
%        output : name        name of vector from variable
%                 okay        == 1 if okay
function [name,okay] = pltmen_find_vector_function( input , input_name, title)


input_class = class(input);
list   ={};
okay = 1;
if( strcmp(input_class,'double') )
        [n,m]=size(input);
        if( n == 0 )
            fprintf('??? The variable %s (double) has no value',input_name);
            name = '';
            okay = 0;
            return;
        elseif( m == 1 )
            name = sprintf('%s(:,1)',input_name);
            return;
        elseif( n == 1 )
            name = sprintf('%s(1,:)''',input_name);
            return;
        end
        i_list = 0;
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
       
        [i_select,i_okay] = listdlg('PromptString',title,...
                                    'SelectionMode','single', ... 
                                    'ListSize',[300,300],...
                                    'ListString',list);
        if ~i_okay
            okay = 0;
        else
            name = list{i_select};
        end
        return;

elseif( strcmp(input_class,'cell') )
        
        nvec    = size(input);
        ngesamt = prod(nvec);
        if( ngesamt == 0 )
            fprintf('??? The variable %s (cell) has no values',input_name);
            name = '';
            okay = 0;
            return;
        end
        
        for i=1:ngesamt
            list{i} = sprintf('%s{',input_name);
        end
        i_ebene = 0;
        list = pltmen_vector_func1(list,i_ebene,nvec,ngesamt);
        for i=1:ngesamt
            list{i} = sprintf('%s}',list{i});
        end
             
        if( ngesamt == 1 )
            i_selsect = 1;
            i_okay    = 1;
        else
            [i_select,i_okay] = listdlg('PromptString',title,...
                                        'SelectionMode','single', ... 
                                        'ListSize',[300,300],...
                                        'ListString',list);
        end
        if ~i_okay
            okay = 0;
            return;
        else
            input_name = list{i_select};
        end
            
                
        
        i1=findstr(input_name,'{');
        i2=findstr(input_name,'}');
        command = sprintf('[name,okay] = pltmen_find_vector_function(input%s,input_name,title);', ...
                          input_name(i1:i2));
        eval(char(command));            
elseif( strcmp(input_class,'struct') & (prod(size(input)) > 1) )

        nvec    = size(input);
        ngesamt = prod(nvec);
        
        for i=1:ngesamt
            list{i} = sprintf('%s(',input_name);
        end
        i_ebene = 0;
        list = pltmen_vector_func1(list,i_ebene,nvec,ngesamt);
        for i=1:ngesamt
            list{i} = sprintf('%s)',list{i});
        end
             
        [i_select,i_okay] = listdlg('PromptString',title,...
                                    'SelectionMode','single', ... 
                                    'ListSize',[300,300],...
                                    'ListString',list);
        if ~i_okay
            okay = 0;
            return;
        else
            input_name = list{i_select};
        end
            
                
        
        i1=findstr(input_name,'(');
        i2=findstr(input_name,')');
        command = sprintf('[name,okay] = pltmen_find_vector_function(input%s,input_name,title);', ...
                          input_name(i1:i2));
        eval(char(command));            
        
elseif( strcmp(input_class,'struct') )

        struct_names = fieldnames(input);
        i_list = 0;
        list={};
        for i=1:length(struct_names)

            command = sprintf('input_class_1 = class(input.%s);',char(struct_names{i}) );
            eval(char(command));            
            
            if( strcmp(input_class_1,'double') )
                i_list = i_list+1;
                list{i_list} = sprintf('(double) %s.%s',input_name,char(struct_names{i}));
            elseif( strcmp(input_class_1,'cell') )
                i_list = i_list+1;
                list{i_list} = sprintf('(cell  ) %s.%s',input_name,char(struct_names{i}));
            elseif( strcmp(input_class_1,'struct') )
                i_list = i_list+1;
                list{i_list} = sprintf('(struct) %s.%s',input_name,char(struct_names{i}));                
            end
        end
        
        if( i_list == 0 )
            fprintf('??? Structure %s has no data (double,cell,struct)\n',input_name);
            i_okay = 0;
        elseif( i_list == 1 )
            i_select = 1;
            i_okay   = 1;
        else
            [i_select,i_okay] = listdlg('PromptString',title,...
                                        'SelectionMode','single', ... 
                                        'ListSize',[300,300],...
                                        'ListString',list);
        end
        if ~i_okay
            okay = 0;
            return;
        else
            input_name = list{i_select};
        end
            
                
        input_name = input_name(10:length(input_name));
        i1=max(findstr(input_name,'.'));
        i2=length(input_name);
        command = sprintf('[name,okay] = pltmen_find_vector_function(input%s,input_name,title);', ...
                          input_name(i1:i2));
        eval(char(command));            
        

end

function list = pltmen_vector_func1(list,i_ebene,nvec,ngesamt)

i_ebene = i_ebene + 1;
if( i_ebene > length(nvec) )
    return;
end

k=0;
for i=1:nvec(i_ebene)
    for j=1:ngesamt/nvec(i_ebene)
        k = k+1
        list{k} = sprintf('%s%i',list{k},i);
        if( i_ebene < length(nvec) )
          list{k} = sprintf('%s,',list{k});
        end
    end
end
list = pltmen_vector_func1(list,i_ebene,nvec,ngesamt);
return;