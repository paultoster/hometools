% $JustDate:: 16.08.05  $, $Revision:: 1 $ $Author:: Tftbe1    $
function s_duh = duh_daten_plotten_one_plot_f(s_duh)
%
% Daten enfach in ein Bild plotten
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

[okay,data_set_select,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( ~okay )
    return
end
data_select = {};

for i=1:length(data_set_select)
    clear s_frage
    
    s_frage.c_liste = fieldnames(s_duh.s_data(data_set_select(i)).d);
    s_frage.c_name  = fieldnames(s_duh.s_data(data_set_select(i)).d);
    s_frage.frage   = sprintf('Vektoren aus Datensatz %s auswählen?',s_duh.s_data(data_set_select(i)).name);
    s_frage.command = 'data_names';
    s_frage.single         = 0;
    s_frage.prot_name      = 1;
    s_frage.sort_list      = 1;
    
    %[okay,data_select{i},s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    [okay,data_select{i},s_duh.s_prot,s_duh.s_remote] = o_abfragen_listboxsort_f(s_frage,s_duh.s_prot,s_duh.s_remote);
end

% Plotten starten

% Zuerst figmen-Box setzen
figmen
set_plot_standards

% neue Figure
h = figure;
i_line = 0;
c_legend = {};
for i=1:length(data_set_select)
    
    i_data_set = data_set_select(i);
    c_arr   = fieldnames(s_duh.s_data(i_data_set).d);
    x_arr   = c_arr{1};
    
    
    for j=1:length(data_select{i})
        
        i_data           = data_select{i}(j);
        i_line           = i_line + 1;
        if( isfield(s_duh.s_data(i_data_set).u,c_arr{i_data}) )
          unit           = s_duh.s_data(i_data_set).u.(c_arr{i_data});
        else
          unit           = '';
        end
        c_legend{i_line} = str_change_f([c_arr{i_data},' ',unit,' (',s_duh.s_data(i_data_set).name,')'],'_',' ');
        
        plot(s_duh.s_data(i_data_set).d.(x_arr) ...
            ,s_duh.s_data(i_data_set).d.(c_arr{i_data}) ...
            ,'Color',PlotStandards.Farbe{min(i_line,PlotStandards.nFarbe)} ...
            ,'Linewidth',PlotStandards.Lsize{2} ...
        )
        hold on
    end
    zaf('setact_silent')

end

grid on
legend(c_legend)

figmen
