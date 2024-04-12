function  [okay] = data_is_struct_vector_format_f(s_data)                      

okay = 0;
                                                
% s_data-Datensatz muß eine Struktur sein und vektoren enthalten
if( isstruct(s_data) )
    c_names = fieldnames(s_data);
    for i=1:length(c_names)
        if( isnumeric(s_data.(c_names{i})) )
            okay = 1;
            break;
        end
    end
end
                       