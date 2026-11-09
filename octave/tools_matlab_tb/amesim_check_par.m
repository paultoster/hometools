function [flag,index] = amesim_check_par(model,par_file,parname)
%
% flag = amesim_check_par(model,par_file,parname)
%
flag = 0;
index = 0;
if( exist([par_file,'.mat'],'file') )
    load(par_file);   
else
    fprintf(2,'Parameterdatei: %s nicht vorhanden',par_file)
    return
end

for i=1:length(cliste)
    if( strcmp(cliste(i).matname,parname) )
        flag = 1;
        index = i;
        break;
    end
end
