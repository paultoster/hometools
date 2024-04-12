function find_mfile(full_flag)
%
% tool_dir(full_flag)
%
if( nargin == 0 )
    full_flag = 0;
end

p = path;
c_liste = str_split(p,';');

for i=1:length(c_liste)
    
    if( length(findstr(c_liste{i},matlabroot)) == 0 ) %nicht im Matlabpfad
        tool_dir_sub(c_liste{i},full_flag)
    end
end

function tool_dir_sub(path,full_flag)

liste = suche_files_ext(path,'m');

if( length(liste) > 0 )
    fprintf('\n Module in %s:\n====================\n',liste(1).dir);

    for i=1:length(liste)
    
        fprintf(' %s\n',liste(i).name);
    end
end


        