function s_duh = duh_daten_plotten_name_f(s_duh)
%
% Daten enfach plotten
%
%

% Standards fürs plotten setzen:
set_plot_standards

% Datennsätze auswählen

for i= 1:s_duh.n_data
    s_frage.c_liste{i} = sprintf('%s (%s)',s_duh.s_data(i).name,s_duh.s_data(i).h{1});
end

s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
s_frage.command        = 'data_set';
s_frage.single         = 0;

[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( ~okay )
    return
end
data_set_select = selection;

clear s_frage

s_frage.frage   = 'Namensteil angeben, mit dem die Signale geplottet werden soll (bei mehrereh durch Komma getrennt;''*'': alle)';
s_frage.command = 'part_name';
s_frage.type    = 'char';

[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( ~okay )
    return
end

[part_names,icount] = str_split(value,',');

clear s_frage

s_frage.frage   = 'Anzahl der Plotzeilen';
s_frage.command = 'nrow';
s_frage.type    = 'double';
s_frage.default = 3;

[okay,nrows,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( ~okay )
    return
end

clear s_frage

s_frage.frage   = 'Anzahl der Plotspalten';
s_frage.command = 'ncol';
s_frage.type    = 'double';
s_frage.default = 2;

[okay,ncols,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( ~okay )
    return
end

% Plotten starten
% Zuerst figmen-Box setzen
figmen
for i=1:length(data_set_select)
    
    i1 = data_set_select(i);
    c_names  = fieldnames(s_duh.s_data(i1).d);

    if( strcmp(part_names{1},'*') ) 
        
        ppart_names = cell(length(c_names)-1,1);
        for j=2:length(c_names)
            ppart_names{j-1} = c_names{j};
        end
    else
        ppart_names = part_names;
    end
    liste = cell_find_f(c_names,ppart_names,'n');
    if( isempty(liste) )
        for j=1:length(part_names)
            fprintf('Keine Signalnamen mit dem Inhalt ''%s'' enthalten\n',part_names{j});
        end
    else

        if( nrows > ncols )
            idina4 = 1;
        else
            idina4 = 2;
        end
        [okay,out.fig_num] = plot_from_struct('fig_num',0 ...
                                             ,'fig_name',value ...
                                             ,'struct',s_duh.s_data(i1).d ...
                                             ,'xname',c_names{1} ...
                                             ,'find_yname',ppart_names ...
                                             ,'exclude_yname','' ...
                                             ,'dina4', idina4 ...
                                             ,'nrows',nrows ...
                                             ,'ncols',ncols ...
                                             ,'title',['Signale ',value] ...
                                             ,'xlabel','' ...
                                             ,'ylabel',1 ...
                                             ,'chs_on',0 ...
                                             ,'xlimit',[] ...
                                             ,'bottom',s_duh.s_data(i1).file ...
                                             ,'line_width',2 ...
                                             );                                         

        zaf('set')
    end
end
figmen
