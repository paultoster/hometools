function okay = amesim_modify_varlist(var_file,S)
%
%  okay = amesim_modify_varlist(var_file,S)
%
% var_file          Name des mat-Files ohne Endung, gespeichert wird:
%                   cliste(i).var         Variablenname AmeSim
%                   cliste(i).model       Modelname AmeSim
%                   cliste(i).unit        Einheit
%                   cliste(i).matname     Variablenname Matlab
%                   cliste(i).ipos        Position von 1 losgezählt
% S                 String-Matrix von Amesim mit den Variablennamen
%
%
okay = 1;
if( exist([var_file,'.mat'],'file') )
    dos(['copy ',var_file,'.mat ',var_file,'_old.mat'])
    load(var_file);
    
%     clear s_frage
%     s_frage.comment   = 'Soll aktuelle var_liste in Excel gezeigt werden';
%     s_frgae.default   = 1;
%     s_frgae.def_value = 'n';
%     
%     [flag] = o_abfragen_jn_f(s_frage);
%     
%     if( flag )
%         [okay,s_e] = write_struct_in_excel('struct',cliste,'name',var_file);
%     end
%         
            
        
        
else
    cliste = [];
end

% Zerlegen der S-Struktur
%

[nrow,ncol] = size(S);

cliste1 = [];
icl1    = 0;
lvar     = 0;
lmodel   = 0;
lunit    = 0;
lmatname = 3;


for i=1:nrow
    
    t = S(i,:);
    t = str_cut_ae_f(t,' ');
    
    % Erstes Leerzeichen trennt Modell
    i0 = str_find_f(t,' ','vs');
    
    [c_names,icount] = str_split(t,' ');
    if( icount > 2 )
        % Letztes Leerzeichen trennt Einheit
        i1 = str_find_f(t,' ','rs');
        unit_found = 1;
    else % keine Einheit
        i1 = length(t);
        unit_found = 0;
    end
    
    % Zeitvektor
    if( str_find_f(t,'time') > 0 )
        
        model = '';
        var   = 'time';
        % Letztes Leerzeichen trennt Einheit
        i1 = str_find_f(t,' ','rs');
        if( i1 > 0 )            
            unit  = t(i1+1:length(t));
            unit  = str_cut_ae_f(unit,' ');
            unit  = str_cut_a_f(unit,'[');
            unit  = str_cut_e_f(unit,']');
            unit  = str_cut_ae_f(unit,' ');
        else
            unit = '';
        end
    else
        if( i0 > 1 )
            model = t(1:i0-1);
        else
            model = '';
        end
        if( unit_found )            
            unit  = t(i1+1:length(t));
            unit  = str_cut_ae_f(unit,' ');
            unit  = str_cut_a_f(unit,'[');
            unit  = str_cut_e_f(unit,']');
            unit  = str_cut_ae_f(unit,' ');
        else
            unit = '';
            i1   = length(t)+1;
        end
        var   = t(i0+1:i1-1);
        var   = str_cut_ae_f(var,' ');
    end
    
    % In der cliste suchen
    found   = 0;
    for j=1:length(cliste)
        
        if( strcmp(cliste(j).var,var) && strcmp(cliste(j).model,model) )
            found = 1;
            icl1 = icl1 + 1;
            cliste1(icl1).var     = var;
            cliste1(icl1).model   = model;
            cliste1(icl1).unit    = unit;
            cliste1(icl1).matname = cliste(j).matname;
            cliste1(icl1).ipos    = i;
            break;
        end
    end
        
    if( ~found )
        icl1 = icl1 + 1;
        cliste1(icl1).var     = var;
        cliste1(icl1).model   = model;
        cliste1(icl1).unit    = unit;
        if( strcmp(var,'time') )
            cliste1(icl1).matname = 'time';
        else
            cliste1(icl1).matname = '';
        end
        cliste1(icl1).ipos    = i;

    end
    
    lvar     = max(lvar    ,length(cliste1(icl1).var     ));
    lmodel   = max(lmodel  ,length(cliste1(icl1).model   ));
    lunit    = max(lunit   ,length(cliste1(icl1).unit    ));
    lmatname = max(lmatname,length(cliste1(icl1).matname ));

end



okay = 1;
while( okay )
    clear s_frage
    s_frage.frage = 'Auswahl, um Matlabname zu erstellen (ende:cancel)';
    s_frage.c_liste = {};
    for i=1:length(cliste1)
        cv  = str_format(cliste1(i).var,    lvar,    'v','l');
        cm  = str_format(cliste1(i).model,  lmodel,  'v','l');
        cu  = str_format(cliste1(i).unit,   lunit,   'v','l');
        if( length(cliste1(i).matname) > 0 )
            cmm = str_format(cliste1(i).matname,lmatname,'v','l');
        else
            cmm = str_format('...',lmatname,'v','l');
        end

        s_frage.c_liste{i} = [cmm{1},'|',cm{1},'|',cv{1},'|',cu{1},'|',];
    end
    %s_frage.single = 1;
    s_frage.fixedfont = 1;

    [okay,selection] = o_abfragen_listbox_f(s_frage);
    
    if( okay )
        for ii=1:length(selection)
            clear s_frage
            s_frage.c_comment{1} = ['var    :',cliste1(selection(ii)).var];
            s_frage.c_comment{2} = ['model  :',cliste1(selection(ii)).model];            
            s_frage.c_comment{3} = ['unit   :',cliste1(selection(ii)).unit];
            if( ~isempty(cliste1(selection(ii)).matname) )
                s_frage.c_comment{3} = ['matname   :',cliste1(selection(ii)).matname];
                s_frage.default      = cliste1(selection(ii)).matname;
            end
            s_frage.frage = 'Welcher Name in Matlab soll dafür verwendet matname ?';
            s_frage.type  = 'char';

            [okay,value] = o_abfragen_wert_f(s_frage);

            if( okay && ~isempty(value))

                cliste1(selection(ii)).matname = value;
                lmatname = max(lmatname,length(value));
                
            end
        end
    end
            

end
i=2;
while(i<=length(cliste1))
    if( ~isempty(cliste1(i).matname) )
        for j=1:i-1        
            if( strcmp(cliste1(i).matname,cliste1(j).matname) )
                cliste1(i).matname = [cliste1(i).matname,'1'];
                i = i-1;
                break;
            end
        end
    end
    i = i+1;
end
            
            
    
    

cliste = cliste1;

save(var_file,'cliste');
        
        
        