function ret = struct_set_global(struct_var)
%
%
ret = 0;

if( strcmp(class(struct_var),'struct') )
    global STRUCT_VAR_GLOBAL
    STRUCT_VAR_GLOBAL = struct_var
else
    fprintf('!!! Variable is not a structure')
    ret = 1;
end

