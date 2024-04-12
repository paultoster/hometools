function [okay,s_e] = commented_struct_out_excel(par,cpar,s_e,iz0)
%
% Ausgabe aller in par(i) enthaltennen daten, die in cpar kommentiert sind
%

% Gruppen suchen
group_names = cpar_get_groups(cpar(1));

% Schleife über Gruppe
for i=1:length(group_names)
    
    % Parameter suchen
    par_names = cpar_search_par_from_group(cpar(1),group_names{i});
    if( length(par_names) > 0 )
        iz0 = iz0+1;
        [okay,s_e] = ausgabe_excel('val',s_e,'col',1,'row',iz0,'val',  group_names{i});
    end
    
    %Schleife über Parameter
    clear c_comment c_value
    n_zeile = 0;
    for j=1:length(par_names)
        
        
        comm_par = cpar.(par_names{j});
        
        
        switch( comm_par{1} )
            case {'single'}

                n_zeile = n_zeile+1;
                c_comment{n_zeile} = [comm_par{4},' ',comm_par{2}];
                
                val = {};
                for k=1:length(par)
                    % Prüfen
                    if( ~isfield(par(k),par_names{j}) )
                        tdum = sprintf('Parameter <%s> aus der Gruppe <%s> ist nicht in Struktur zu finden',par_names{j},group_names{i});            
                        error(tdum)
                    end
                    val{k} = par(k).(par_names{j});
                end
                c_value{n_zeile} = val;
            case {'string','text'}

                n_zeile = n_zeile+1;
                c_comment{n_zeile} = [comm_par{4}];
                
                val = {};
                for k=1:length(par)
                    % Prüfen
                    if( ~isfield(par(k),par_names{j}) )
                        tdum = sprintf('Parameter <%s> aus der Gruppe <%s> ist nicht in Struktur zu finden',par_names{j},group_names{i});            
                        error(tdum)
                    end
                    val{k} = par(k).(par_names{j});
                end
                c_value{n_zeile} = val;
                
        end
    end
    
    for j=1:n_zeile
        [okay,s_e] = ausgabe_excel('val',s_e,'col',1,'row',iz0+j,'val',  c_comment{j});
        
        for k=1:length(par)            
            [okay,s_e] = ausgabe_excel('val',s_e,'col',k+1,'row',iz0+j,'val',  c_value{j}{k});
        end
    end
    iz0 = iz0 + n_zeile;
end
s_e.izeile = iz0;


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
    
    h = p_figure(-1,2,'');
    
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

    h = p_figure(-1,2,'');
    
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
    


    



            
        
        
