function  s_duh = duh_daten_bearb_x_cut(data_selection,s_duh,itype)


% Plotten
%===================
clear s_frage
s_frage.comment    = 'Soll ein Plot zur Hilfe genommen werden';
s_frage.prot       = 1;
s_frage.command    = 'plot_flag';
s_frage.default    = 1;
s_frage.def_value  = 0;

[plot_flag,s_duh.s_prot,s_duh.s_remote]  = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( s_duh.s_remote.run_flag )
    plot_flag = 0;
end

if( plot_flag )
    
        set_plot_standards
        % Vektor(en) auswählen
        %----------------------------
        clear s_frage s_set
        for i=1:length(data_selection)
            c_arr            = fieldnames(s_duh.s_data(data_selection(i)).d);
            s_set(i).c_names = {c_arr{1:length(c_arr)}};
        end
        [s_erg] = str_count_names_f(s_set,1);
        for i= 1:length(s_erg)
            s_frage.c_liste{i} = sprintf('%s (%g x)',s_erg(i).name,s_erg(i).n);
            s_frage.c_name{i}  = s_erg(i).name;
        end

        s_frage.frage          = sprintf('Vektor(en) aus %g Datensätze auswählen (n mal vorhanden) ?',length(data_selection));
        s_frage.command        = 'data_name';
        s_frage.single         = 0;
        s_frage.prot_name      = 1;
				s_frage.sort_list      = 1;
				
        [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        hplot = figure;
        n = 0;
        cname = {};
        for i=1:length(data_selection)
            
            for j=1:length(selection)
                
                if( isfield(s_duh.s_data(data_selection(i)).d,s_frage.c_name{selection(j)}) )
                    n = n+1;
                    plot( s_duh.s_data(data_selection(i)).d.(s_frage.c_name{selection(j)}),'Color',PlotStandards.Farbe{n} )
                    cname{n} = [num2str(data_selection(i)),'te Ds (', s_frage.c_name{selection(j)},')'];
                    hold on
                end
            end
        end
        hold off
        grid on
        legend(cname)
end
        
            
    
c_names   = fieldnames(s_duh.s_data(data_selection(1)).d);
n_max = length( s_duh.s_data(data_selection(1)).d.(c_names{1}));
for i=1:length(data_selection)
    c_names   = fieldnames(s_duh.s_data(data_selection(i)).d);
    for j=1:length(c_names)
        n_max = min(n_max,length( s_duh.s_data(data_selection(i)).d.(c_names{j})));
    end
end

o_ausgabe_f('\n------------------------------------\n',s_duh.s_prot.debug_fid);
for i=1:length(data_selection)
        a = sprintf('%s(%s)',s_duh.s_data(data_selection(i)).name,s_duh.s_data(data_selection(i)).h{1});
        o_ausgabe_f(a,s_duh.s_prot.debug_fid);
end
o_ausgabe_f('\n------------------------------------\n',s_duh.s_prot.debug_fid);

if( itype == 0 | itype == 1) % 0:Beginn abschneiden 1:Ende anschneiden

    if( itype == 0 )
    	s_frage.c_comment{1} = 'minimaler gemeinsamer Index';
        s_frage.c_comment{2} = sprintf('%i',n_max);
	    s_frage.frage     = 'Wieviele Werte sollen ma Anfang beschnitten werden';
	    s_frage.prot      = 1;
	    s_frage.command   = 'n_cut_begin';
	    s_frage.type      = 'double';
    else
    	s_frage.c_comment{1} = 'minimaler gemeinsamer Index';
        s_frage.c_comment{2} = sprintf('%i',n_max);
	    s_frage.frage     = 'Wieviele Werte sollen am Ende beschnitten werden';
	    s_frage.prot      = 1;
	    s_frage.command   = 'n_cut_end';
	    s_frage.type      = 'double';
    end
    

    [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( okay )
        if( itype == 0 )
            
            n0 = min(n_max,floor(value)+1);
            n1 = n_max;
        else
            n0 = 1;
            n1 = n_max - min(n_max-1,floor(value));
        end
        

    end
else % Wertebereich auswählen
	s_frage.c_comment{1} = 'minimaler gemeinsamer Indexbereich';
    s_frage.c_comment{2} = sprintf('1:%i',n_max);
    s_frage.frage     = 'Auf welchen Indexbereich [n0:n1] eingrenzen erster Wert n0';
    s_frage.prot      = 1;
    s_frage.command   = 'n0';
    s_frage.type      = 'double';
    [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

    if( okay )
        n0 = max(1,floor(value));
    
    	s_frage.c_comment{1} = 'minimaler gemeinsamer Wertebereich';
        s_frage.c_comment{2} = sprintf('1:%i',n_max);
        s_frage.frage     = 'Auf welchen Indexbereich [n0:n1] eingrenzen zweiter Wert n1';
        s_frage.prot      = 1;
        s_frage.command   = 'n1';
        s_frage.type      = 'double';
        [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

        if( okay )
            n1 = min(n_max,floor(value));
        end
    end
end  

if( okay )
    for i=1:length(data_selection)
        for j=1:length(c_names)
        
            s_duh.s_data(data_selection(i)).d.(c_names{j}) = s_duh.s_data(data_selection(i)).d.(c_names{j})(n0:n1);
        end
    end
end

if( plot_flag )

    close(hplot)
end
