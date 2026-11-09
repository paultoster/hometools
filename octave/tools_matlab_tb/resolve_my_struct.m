if( exist('my_struct','var') )
    if( strcmp(class(my_struct),'struct') )
        my_fieldnames=fieldnames(my_struct);
        for my_i=1:length(my_fieldnames)
            
            my_command=strcat(my_fieldnames(my_i),'=','my_struct.',my_fieldnames(my_i),';');
            eval(char(my_command));
        end
        clear my_struct my_command my_fieldnames my_i
    else
        fprintf('!!! Variable my_struct_var is not a structure\n')
     fprintf('    set:\n    my_struct = xyz_struct;\n')
        fprintf('    xyz_struct is the structure to resolve') 
    end
else
    fprintf('!!! my_struct_var does not exist\n')
    fprintf('    set:\n    my_struct = xyz_struct;\n')
    fprintf('    xyz_struct is the structure to resolve') 
end