function  okay = data_is_marc_aft_format_f(data)                      

okay = 0;
if( isstruct(data) )
    
    cnames = fieldnames(data);
    name   = cnames{1};
    if( isstruct(data.(name)) && ...
        isfield(data.(name),'GlobalInfo') && ...
        isfield(data.(name),'Signal') && ...
        isstruct(data.(name).GlobalInfo) && ...
        isstruct(data.(name).Signal)  )
   
        okay = 1;
    end
end
                       