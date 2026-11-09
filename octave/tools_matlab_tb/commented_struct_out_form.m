function  okay = commented_struct_out_form(par,cpar,s_a,plot_flag)
%
% Parameterausgabe
% par 		struct		Parameterstruktur
%                   z.B. par.a = 12;   Singletyp 
%                        par.b_x = [1,2,3], par.b_y = [19,38,25]; Vektor
%                        par.c = 'test'; text
%                        par.d_x = [1,2]; par.d_y = [1,2,3]; par.d_z = [0,0;100,200;200;400]; matrix
% cpar	  struct    Beschreibungsstruktur mit den gleichen Namen wie in par, hier wird der Parameter in einem cellarray beschrieben
%                   Einzelwert:         {'single','Einheit','Beschreibung'}
%                   Text                {'string','','Beschreibung'}         
%                   Tabelle  x-Achse:   {'tabx','Einheit','Beschreibung'}
%                            y-Achse:   {'taby','Einheit','Beschreibung','Name von tabx'}
%                   Matrix   x-Achse:   {'matx','Einheit','Beschreibung'}
%                            y-Achse:   {'maty','Einheit','Beschreibung'}
%                            z-Achse:   {'matz','Einheit','Beschreibung','Name von tabx','Name von taby'}
%                   z.B. cpar.a   = {'single','kg','Masse'};
%                        cpar.b_x = {'tabx','-','Gang'};
%                        cpar.b_y = {'taby','-','Übersetzung','b_x'};
%                        cpar.c   = {'string','','dummy'};
%                        cpar.d_x = {'matx','m','weg'};
%                        cpar.d_y = {'maty','N','kraft'};
%                        cpar.d_z = {'matz','-','wirkungsgrad','d_x','d_y'};
%
% s_a			struct		Struktur die von dem wordModul beim Öffnen der Datei kommt
%                   (siehe ausgabe_aw.m), wenn nicht gesetzt bzw. = 0, dann wird nur geprüft
%                           Wenn s_a.excel_fid gefunden wird, wird in excel
%                           ausgegeben (kein Plot keine Tabelle)
%
%    								z.B. [okay,s_a] = ausgabe_aw('init','name','xyz','path','word',1,,'visible',1);
% plot_flag  double wenn gesetzt, wird  Tabelle und 3-D (matirx) in word geplottet
%                   				

okay = 1;

if( ~exist('s_a','var') )
    s_a = 0;
    s_e = 0;
else
    if( isfield(s_a,'excel_fid') )
        s_e = s_a;
        icole = 2;
        irowe = 0;
        s_a = 0;
    else
        s_e = 0;
    end        
end
if( ~exist('plot_flag','var') )
    plot_flag = 0;
end

% Gruppen suchen
group_names = cpar_get_groups(cpar);

if( ~isempty(group_names) && isstruct(s_e) )
        irowe = irowe+1;
        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole-1,'row',irowe,'val','Gruppe');
        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole,'row',irowe,'val','Name');
        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole+1,'row',irowe,'val','Wert');
        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole+2,'row',irowe,'val','Einheit');
        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole+3,'row',irowe,'val','Kommentar');
end
% Schleife über Gruppe
for i=1:length(group_names)
    
    % Titel ausgeben für die Gruppe
    if( isstruct(s_a) )
        [okay,s_a] = ausgabe_aw('newline',s_a);
        [okay,s_a] = ausgabe_aw('title',s_a ...
                               ,'text',group_names{i} ...
                               ,'pos','right' ...
                               ,'uline','-' ...
                               );
    elseif( isstruct(s_e) )
        irowe = irowe+1;
        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole-1,'row',irowe,'val',group_names{i});
    end

    % Parameter suchen
    par_names = cpar_search_par_from_group(cpar,group_names{i});
    %Schleife über Parameter
    for j=1:length(par_names)
        
        % Prüfen
        if( ~isfield(par,par_names{j}) )
            tdum = sprintf('Parameter <%s> aus der Gruppe <%s> ist nicht in par-Struktur zu finden',par_names{j},group_names{i});            
            error(tdum)
        end
        
        comm_par = cpar.(par_names{j});
        
        % Ausgeben
        switch( comm_par{1} )
            case {'single','string','text'}
                
            
                % Prüfen
                if( length(comm_par) < 4 )
                    for k=1:length(comm_par)
                        switch( k )
                            case 1 
                                fprintf('\ntype   = %s\n',comm_par{k});
                            case 2 
                                fprintf('unit   = %s\n',comm_par{k});
                            case 3 
                                fprintf('gruppe = %s\n',comm_par{k});
                        end
                    end
                    tdum = sprintf('Parameter <cpar.%s> aus der Gruppe <%s> ist nicht korrekt ausgefüllt mit {''type'',''unit'',''gruppe'',''comment''}',par_names{j},group_names{i});            
                    error(tdum)
                end

                if( strcmp(comm_par{1},'single') )
                    
                    if( ~strcmp(class(par.(par_names{j})),'double') )
                        tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist nicht type: single (siehe <cpar.%s>)',par_names{j},group_names{i},par_names{j});            
                        error(tdum)
                    end
                        
                    % Ausgabe Einzelwert
                    if( isstruct(s_a) )
                        [okay,s_a] = ausgabe_aw('res',  s_a ...
                                               ,'com',  comm_par{4} ...
                                               ,'unit', comm_par{2} ...
                                               ,'val',  par.(par_names{j}) ...
                                               );
                    elseif( isstruct(s_e) )
                        irowe = irowe+1;
                        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole,'row',irowe,'val',par_names{j});
                        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole+1,'row',irowe,'val',par.(par_names{j}));
                        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole+2,'row',irowe,'val',comm_par{2});
                        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole+3,'row',irowe,'val',comm_par{4});
                    end
                else
                    if( ~strcmp(class(par.(par_names{j})),'char') )
                        tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist nicht type: string (siehe <cpar.%s>)',par_names{j},group_names{i},par_names{j});            
                        error(tdum)
                    end
                    % Ausgabe Einzelwert
                    if( isstruct(s_a) )
                        [okay,s_a] = ausgabe_aw('string',  s_a ...
                                               ,'com',     comm_par{4} ...
                                               ,'tval',    par.(par_names{j}) ...
                                               );
                    elseif( isstruct(s_e) )
                        irowe = irowe+1;
                        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole,'row',irowe,'val',par_names{j});
                        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole+1,'row',irowe,'val',par.(par_names{j}));
                        %[okay,s_e] = ausgabe_excel('val',s_e,'col',icole+2,'row',irowe,'val',comm_par{2});
                        [okay,s_e] = ausgabe_excel('val',s_e,'col',icole+3,'row',irowe,'val',comm_par{4});
                    end
                end
                
            case 'taby'
                
                % taby Prüfen
                if( length(comm_par) < 5 )
                    for k=1:length(comm_par)
                        switch( k )
                            case 1 
                                fprintf('\ntype   = %s\n',comm_par{k});
                            case 2 
                                fprintf('unit   = %s\n',comm_par{k});
                            case 3 
                                fprintf('gruppe = %s\n',comm_par{k});
                            case 4 
                                fprintf('comment = %s\n',comm_par{k});
                        end
                    end
                    tdum = sprintf('Parameter <cpar.%s> aus der Gruppe <%s> ist nicht korrekt ausgefüllt mit {''type'',''unit'',''gruppe'',''comment'',''tabx_link''}',par_names{j},group_names{i});            
                    error(tdum)
                end
                
                if( strcmp(class(par.(par_names{j})),'double') || strcmp(class(par.(par_names{j})),'logical') )
                else
                    tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist nicht type: taby (siehe <cpar.%s>)',par_names{j},group_names{i},par_names{j});            
                    error(tdum)
                end
                if( length(par.(par_names{j})) == 1  )
                    tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist type: single und nicht type: taby (siehe <cpar.%s>)',par_names{j},group_names{i},par_names{j});            
                    error(tdum)
                end
                
                % tabx suchen
                name_x    = comm_par{5};
                flag = 0;
                for k=1:length(par_names)
                    if( strcmp(name_x,par_names{k}) )
                        flag = 1;
                        break
                    end
                end
                if( flag == 0 )
                    tdum = sprintf('Gruppe <%s>: taby-Parameter <par.%s> hat keinen tabx-Parameter <par.%s> bzw. <cpar.%s> (siehe <cpar.%s>)',group_names{i},par_names{j},name_x,name_x,par_names{j});            
                    error(tdum)
                end
                
                comm_parx = cpar.(name_x);
                % tabx prüfen
                if( length(comm_parx) < 4 )
                    for k=1:length(comm_parx)
                        switch( k )
                            case 1 
                                fprintf('\ntype   = %s\n',comm_parx{k});
                            case 2 
                                fprintf('unit   = %s\n',comm_parx{k});
                            case 3 
                                fprintf('gruppe = %s\n',comm_parx{k});
                        end
                    end
                    tdum = sprintf('Parameter <cpar.%s> aus der Gruppe <%s> ist nicht korrekt ausgefüllt mit {''type'',''unit'',''gruppe'',''comment''}',name_x,group_names{i});            
                    error(tdum)
                end
                
                if( ~strcmp(class(par.(name_x)),'double') )
                    tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist nicht type: taby (siehe <cpar.%s>)',name_x,group_names{i},name_x);            
                    error(tdum)
                end
                if( length(par.(name_x)) == 1  )
                    tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist type: single und nicht type: taby (siehe <cpar.%s>)',name_x,group_names{i},name_x);            
                    error(tdum)
                end
                if( length(par.(name_x)) ~= length(par.(par_names{j})) )
                    tdum = sprintf('Länge(%i) tabx-Parameter <par.%s> aus der Gruppe <%s> ist ungleich Länge(%i) taby-Parameter  <par.%s> ',length(par.(name_x)),name_x,group_names{i},length(par_names{j}),par_names{j});            
                    error(tdum)
                end
                
                if( plot_flag )
                		okay = par_tab_out(name_x,par_names{j},par.(name_x),par.(par_names{j}),cpar.(name_x),cpar.(par_names{j}),s_a);
                end
                
            case 'matz'

                % matz Prüfen
                comm_matz = comm_par;
                name_matz = par_names{j};
                par_matz  = par.(par_names{j});
                
                % Länge von comment
                if( length(comm_matz) < 6 )
                    for k=1:length(comm_matz)
                        switch( k )
                            case 1 
                                fprintf('\ntype   = %s\n',comm_matz{k});
                            case 2 
                                fprintf('unit   = %s\n',comm_matz{k});
                            case 3 
                                fprintf('gruppe = %s\n',comm_matz{k});
                            case 4 
                                fprintf('comment = %s\n',comm_matz{k});
                            case 5 
                                fprintf('name_matx = %s\n',comm_matz{k});
                        end
                    end
                    tdum = sprintf('Parameter <cpar.%s> aus der Gruppe <%s> ist nicht korrekt ausgefüllt mit {''type'',''unit'',''gruppe'',''comment'',''name_matx'',''name_maty''}',name_matz,group_names{i});            
                    error(tdum)
                end
                % Type
                if( ~strcmp(class(par_matz),'double') )
                    tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist nicht type: matz (siehe <cpar.%s>)',name_matz,group_names{i},par_names{j});            
                    error(tdum)
                end
                
                % matx suchen
                name_matx    = comm_par{5};
                flag = 0;
                for k=1:length(par_names)
                    if( strcmp(name_matx,par_names{k}) )
                        flag = 1;
                        break
                    end
                end
                if( flag == 0 )
                    tdum = sprintf('Gruppe <%s>: matz-Parameter <par.%s> hat keinen matx-Parameter <par.%s> bzw. <cpar.%s> (siehe <cpar.%s>)',group_names{i},name_matz,name_matx,name_matx,name_matz);            
                    error(tdum)
                end                
                comm_matx = cpar.(name_matx);
                par_matx  = par.(name_matx);
                
                % matx prüfen
                if( length(comm_matx) < 4 )
                    for k=1:length(comm_matx)
                        switch( k )
                            case 1 
                                fprintf('\ntype   = %s\n',comm_matx{k});
                            case 2 
                                fprintf('unit   = %s\n',comm_matx{k});
                            case 3 
                                fprintf('gruppe = %s\n',comm_matx{k});
                        end
                    end
                    tdum = sprintf('Parameter <cpar.%s> aus der Gruppe <%s> ist nicht korrekt ausgefüllt mit {''type'',''unit'',''gruppe'',''comment''}',name_matx,group_names{i});            
                    error(tdum)
                end
                
                if( ~strcmp(class(par.(name_matx)),'double') )
                    tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist nicht type: taby (siehe <cpar.%s>)',name_matx,group_names{i},name_matx);            
                    error(tdum)
                end


                % maty suchen
                name_maty    = comm_par{6};
                flag = 0;
                for k=1:length(par_names)
                    if( strcmp(name_maty,par_names{k}) )
                        flag = 1;
                        break
                    end
                end
                if( flag == 0 )
                    tdum = sprintf('Gruppe <%s>: matz-Parameter <par.%s> hat keinen maty-Parameter <par.%s> bzw. <cpar.%s> (siehe <cpar.%s>)',group_names{i},name_matz,name_maty,name_maty,name_matz);            
                    error(tdum)
                end                
                comm_maty = cpar.(name_maty);
                par_maty  = par.(name_maty);
                
                % maty prüfen
                if( length(comm_maty) < 4 )
                    for k=1:length(comm_maty)
                        switch( k )
                            case 1 
                                fprintf('\ntype   = %s\n',comm_maty{k});
                            case 2 
                                fprintf('unit   = %s\n',comm_maty{k});
                            case 3 
                                fprintf('gruppe = %s\n',comm_maty{k});
                        end
                    end
                    tdum = sprintf('Parameter <cpar.%s> aus der Gruppe <%s> ist nicht korrekt ausgefüllt mit {''type'',''unit'',''gruppe'',''comment''}',name_maty,group_names{i});            
                    error(tdum)
                end
                
                if( ~strcmp(class(par.(name_maty)),'double') )
                    tdum = sprintf('Parameter <par.%s> aus der Gruppe <%s> ist nicht type: taby (siehe <cpar.%s>)',name_maty,group_names{i},name_maty);            
                    error(tdum)
                end

                [n,m] = size(par.(name_matz));
                if( length(par.(name_matx)) ~= n )
                    tdum = sprintf('Länge(%i) matx-Parameter <par.%s> aus der Gruppe <%s> ist ungleich Länge(%i) matz-Parameter  <par.%s> ',length(par.(name_matx)),name_matx,group_names{i},n,name_matz);            
                    error(tdum)
                end
                [n,m] = size(par.(name_matz));
                if( length(par.(name_maty)) ~= m )
                    tdum = sprintf('Länge(%i) maty-Parameter <par.%s> aus der Gruppe <%s> ist ungleich Länge(%i) matz-Parameter  <par.%s> ',length(par.(name_maty)),name_maty,group_names{i},n,name_matz);            
                    error(tdum)
                end
                
                if( plot_flag )
                		okay = par_mat_out(name_matx,comm_matx,par.(name_matx),name_maty,comm_maty,par.(name_maty),name_matz,comm_matz,par.(name_matz),s_a);
                end 
            otherwise
                if( ~strcmp(comm_par{1},'tabx') & ~strcmp(comm_par{1},'matx') & ~strcmp(comm_par{1},'maty') )
                    tdum = sprintf('%s: Parameter <%s> aus der Gruppe <%s> hat falschen type <%s>',mfilename,par_names{j},group_names{i},comm_par{1});
                    error(tdum)
                end
        end            
    end
end
%=====================================================
%=====================================================
% {type,unit,group,comment,link}
function cgroups = cpar_get_groups(cpar)

    
    c_names = fieldnames(cpar);
    cgroups = {};
    ngroups = 0;
    for i = 1:length(c_names)
        c_vec = cpar.(c_names{i});
        if( length(cpar.(c_names{i})) < 3 )
            tdum = sprintf('Parameter <cpar.%s> ist nicht richtig ausgefüllt Kontrolliere cpar',c_names{i});
            c_vec
            error(tdum)
        end
        
        
        found_flag = 0;
        for j=1:ngroups
            if( strcmp(c_vec{3},cgroups{j}) )
                found_flag = 1;
                break
            end
        end
        if( ~found_flag )
            ngroups = ngroups+1;
            cgroups{ngroups} = c_vec{3};
        end
    end
%=====================================================
%=====================================================
% {type,unit,group,comment,link}
function  cpars =  cpar_search_par_from_group(cpar,group);

    c_names = fieldnames(cpar);
    cpars = {};
    npars = 0;
    for i = 1:length(c_names)
        c_vec = cpar.(c_names{i});
        if( length(cpar.(c_names{i})) < 3 )
            tdum = sprintf('%s: Parameter <%s> ist nicht richtig ausgefüllt(2)',mfilename,c_names{i});
            c_vec
            error(tdum)
        end
        
        if( strcmp(group,c_vec{3}) )
            npars = npars+1;
            cpars{npars} = c_names{i};
        end
    end

%=====================================================
%=====================================================
% {type,unit,group,comment,link}
function okay = par_tab_out(namex,namey,tabx,taby,ctabx,ctaby,s_a)
    
    h = p_figure(-1,2);
    
    plot(tabx,taby,'Color',[0,0,0],'LineWidth',2)
    grid on
    xlabel(str_change_f([namex,' [',ctabx{2},']'],'_',' '));
    ylabel(str_change_f([namey,' [',ctaby{2},']'],'_',' '));
    
    if( isstruct(s_a) )    
        [okay,s_a] = ausgabe_aw('figure',s_a,'handle',h,'newline',1);
    end
    
    close(h)
    if( isstruct(s_a) )
        [okay,s_a] = ausgabe_aw('title',s_a,'text',['tabx: ',namex,'[',ctabx{2},'] ',ctabx{4}],'newline',1,'uline','');
        [okay,s_a] = ausgabe_aw('title',s_a,'text',['taby: ',namey,'[',ctaby{2},'] ',ctaby{4}],'newline',0,'uline','');
        [okay,s_a] = ausgabe_aw('newline',s_a);
    end
%=====================================================
%=====================================================
% {type,unit,group,comment,link}
function okay = par_mat_out(namex,cmatx,matx,namey,cmaty,maty,namez,cmatz,matz,s_a)

    h = p_figure(-1,2);
    
    [xi,yi] = meshgrid(matx,maty);
    mesh(xi,yi,matz')

    xlabel(str_change_f([namex,' [',cmatx{2},']'],'_',' '));
    ylabel(str_change_f([namey,' [',cmaty{2},']'],'_',' '));
    zlabel(str_change_f([namez,' [',cmatz{2},']'],'_',' '));
    if( isstruct(s_a) )    
        [okay,s_a] = ausgabe_aw('figure',s_a,'handle',h,'newline',1);
    end
    
    close(h)
    if( isstruct(s_a) )    
        [okay,s_a] = ausgabe_aw('title',s_a,'text',['matx: ',namex,'[',cmatx{2},'] ',cmatx{4}],'newline',1,'uline','');
        [okay,s_a] = ausgabe_aw('title',s_a,'text',['maty: ',namey,'[',cmaty{2},'] ',cmaty{4}],'newline',0,'uline','');
        [okay,s_a] = ausgabe_aw('title',s_a,'text',['matz: ',namez,'[',cmatz{2},'] ',cmatz{4}],'newline',0,'uline','');
        [okay,s_a] = ausgabe_aw('newline',s_a);
    end
    


    


