function index = suche_name_in_struct_f(obj,name)
index = 0;
if( strcmp(class(obj),'struct')) 
    
    c_names = fieldnames(obj);
    
    for i=1:length(c_names)
        
        if( strcmp(c_names{i},name) )
            index = i;
            return
        end
    end
    
    return
elseif( strcmp(class(obj),'cell') )
    
    for i=1:length(obj)
        
        if(  strcmp(class(obj{i}),'char') )
            if( strcmp(obj{i},name) )
                
                index = i;
                return
            end
        else
            error(' Das objekt{i} ist kein character')
        end
    end
else
                
    error(' Das objekt ist keine Struktur oder cellarray')
    return
end
