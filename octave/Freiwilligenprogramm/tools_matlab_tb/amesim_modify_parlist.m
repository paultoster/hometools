function okay = amesim_modify_parlist(par_file,model)
%
%  okay = amesim_modify_varlist(par_file,model)
%
% par_file          Name des mat-Files ohne Endung, gespeichert wird:
%                   cliste(i).par         Parametername AmeSim
%                   cliste(i).model       Modelname AmeSim
%                   cliste(i).unit        Einheit
%                   cliste(i).matname     Parametername Matlab
%                   cliste(i).val         Wert
%                   cliste(i).ipos        Position von 1 losgezählt
% model             Amesim-modelname
%
%
okay = 1;
if( exist([par_file,'.mat'],'file') )
    dos(['copy ',par_file,'.mat ',par_file,'_old.mat'])
    load(par_file);   
else
    cliste = [];
end

% Parameterstruktur holen
%
[P,V]=amegetp(model);

[c_p,np]=str_split(P,char(10));
c_p = cell_str_cut_ae_f(c_p,char(13));
[c_v,nv]=str_split(V,char(10));
c_v = cell_str_cut_ae_f(c_v,char(13));

nrow = min(nv,np);


cliste1 = [];
icl1    = 0;
lpar     = 0;
lmodel   = 0;
lunit    = 0;
lmatname = 3;
lval     = 0;


for i=1:nrow
    
    fullname = c_p{i};
    t = fullname;
    t = str_cut_ae_f(t,' ');
    val = c_v{i};
    val = str_cut_ae_f(val,' ');
    
    % Erstes Leerzeichen trennt Modell
    i0 = str_find_f(t,' ','vs');
    % Letztes Leerzeichen trennt Einheit
    i1 = str_find_f(t,' ','rs');
    
    if( i0 > 1 )
        model = t(1:i0-1);
    else
        model = '';
    end
    if( i1 > 1 )            
        unit  = t(i1+1:length(t));
        unit  = str_cut_ae_f(unit,' ');
        unit  = str_cut_a_f(unit,'[');
        unit  = str_cut_e_f(unit,']');
        unit  = str_cut_ae_f(unit,' ');
    else
        unit = '';
        i1   = length(t)+1;
    end
    par   = t(i0+1:i1-1);
    par   = str_cut_ae_f(par,' ');
    
    % In der cliste suchen
    found   = 0;
    for j=1:length(cliste)
        
        if( strcmp(cliste(j).par,par) && strcmp(cliste(j).model,model) )
            found = 1;
            icl1 = icl1 + 1;
            cliste1(icl1).par     = par;
            cliste1(icl1).model   = model;
            cliste1(icl1).unit    = unit;
            cliste1(icl1).matname = cliste(j).matname;
            cliste1(icl1).ipos    = i;
            cliste1(icl1).val     = val;
            cliste1(icl1).fullname = fullname;
            break;
        end
    end
        
    if( ~found )
        icl1 = icl1 + 1;
        cliste1(icl1).par     = par;
        cliste1(icl1).model   = model;
        cliste1(icl1).unit    = unit;
        if( strcmp(par,'time') )
            cliste1(icl1).matname = 'time';
        else
            cliste1(icl1).matname = '';
        end
        cliste1(icl1).ipos    = i;
        cliste1(icl1).val     = val;
        cliste1(icl1).fullname = fullname;

    end
    
    lpar     = max(lpar    ,length(cliste1(icl1).par     ));
    lmodel   = max(lmodel  ,length(cliste1(icl1).model   ));
    lunit    = max(lunit   ,length(cliste1(icl1).unit    ));
    lmatname = max(lmatname,length(cliste1(icl1).matname ));
    lval     = max(lval    ,length(cliste1(icl1).val     ));

end



okay = 1;
while( okay )
    clear s_frage
    s_frage.frage = 'Par: Auswahl, um Matlabname zu erstellen (ende:cancel)';
    s_frage.c_liste = {};
    for i=1:length(cliste1)
        cp  = str_format(cliste1(i).par,    lpar,    'v','l');
        cm  = str_format(cliste1(i).model,  lmodel,  'v','l');
        cu  = str_format(cliste1(i).unit,   lunit,   'v','l');
        cv  = str_format(cliste1(i).val,    lval,   'v','l');
        if( length(cliste1(i).matname) > 0 )
            cmm = str_format(cliste1(i).matname,lmatname,'v','l');
        else
            cmm = str_format('...',lmatname,'v','l');
        end

        s_frage.c_liste{i} = [cmm{1},'|',cm{1},'|',cp{1},'|',cu{1},'|',cv{1}];
    end
    %s_frage.single = 1;
    s_frage.fixedfont = 1;

    [okay,selection] = o_abfragen_listbox_f(s_frage);
    
    if( okay )
        for ii=1:length(selection)
            clear s_frage
            s_frage.c_comment{1} = ['par    :',cliste1(selection(ii)).par];
            s_frage.c_comment{2} = ['model  :',cliste1(selection(ii)).model];            
            s_frage.c_comment{3} = ['unit   :',cliste1(selection(ii)).unit];
            s_frage.c_comment{3} = ['val   :',cliste1(selection(ii)).val];
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

save(par_file,'cliste');


for i=1:length(cliste)
    
    if( length(cliste(i).matname) )
        
        fprintf('%i %s:    %s \n',i,cliste(i).matname,cliste(i).val);
    end
end
    
    
        
        
        