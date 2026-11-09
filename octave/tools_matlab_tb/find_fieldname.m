function fieldpos = find_fieldname(st,fieldname)
%
%
fieldpos = 0;

if( strcmp(class(st),'struct') & strcmp(class(fieldname),'char') )
    a=fieldnames(st);
    for i=1:length(a)
        if( strcmp(a(i),fieldname) )
            fieldpos=i;
            break;
        end
    end
end

