function amesim_set_par(model,par_file,parname,val)
%
% amesim_set_par(model,varname,val)
%
if( exist([par_file,'.mat'],'file') )
    load(par_file);   
else
    % error('Parfile muﬂ mit amesim_modify_parlist.m erszeugt werden')
    okay = amesim_modify_parlist(par_file,model);
    if( ~okay )
        error(' Fehler in amesim_modify_parlist() ')
    end
end
[flag,index] = amesim_check_par(model,par_file,parname);
if( ~flag )
    error('Parametername: %s konnte nicht in par_file: %s gefunden werden',parname,[par_file,'.mat']);
end
[par,val_ver] = amegetp(model,cliste(index).fullname);
if( isempty(par) )
    error('Parameter kann nicht gesetzt werden model: <%s>,par: <%s>',model, varname);
end
ameputp(model,cliste(index).fullname,num2str(val));

[par,val_ver] = amegetp(model,cliste(index).fullname);

fprintf('amesim_set_par: model: <%s>,par: <%s>\n' ...
       , cliste(index).model, cliste(index).par);
fprintf('                Wert: set<%g> get<%s' ...
       , val, val_ver);
fprintf('               (fullname:<%s>)\n' ...
       ,  cliste(index).fullname);

