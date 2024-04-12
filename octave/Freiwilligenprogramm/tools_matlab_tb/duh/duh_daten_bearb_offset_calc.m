function  s_duh = duh_daten_bearb_offset_calc(data_selection,s_duh)

set_plot_standards

first_run_flag = 1;
s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal'           ,''       ,'Welches Signal' ...
             ,1      ,'index_flag'       ,1        ,'Sollen x-Wert bzw. Zeit festgelegt werden' ...
             ,1      ,'x_value0'         ,0        ,'Anfangswert festlegen' ...
             ,1      ,'x_value1'         ,0        ,'Endwert festlegen' ...
             ,1      ,'target_value'     ,0        ,'Zielwert' ...
             ,0      ,'new_name_flag'    ,0        ,'Soll neuer Kanal mit neuen Name mit angehängtem _oc verwendet werden' ...
             );
option_flag = 1;

while( option_flag )
	
	[end_flag,option_flag,option,s_liste,s_duh.s_prot,s_duh.s_remote] = ...
                                      o_abfragen_werte_liste_f(s_liste,s_duh.s_prot,s_duh.s_remote);
	
	if( end_flag )
       return;
	end
	if( option_flag )
        
        clear s_frage
        clear h
        switch option
            
            case 1 % signal

				for i=1:length(data_selection)
                    c_arr            = fieldnames(s_duh.s_data(data_selection(i)).d);
                    s_set(i).c_names = {c_arr{1:length(c_arr)}};
				end
				[s_erg] = str_count_names_f(s_set,1);
				j = 0;
				for i= 1:length(s_erg)
                    if( s_erg(i).n == length(data_selection) )
                        j = j+1;
                        s_frage.c_liste{j} = sprintf('%s',s_erg(i).name);
                        s_frage.c_name{j}  = s_erg(i).name;
                    end
				end
                    
				s_frage.frage          = sprintf('Signalname aus %g Datensätze auswählen ?',length(data_selection));
				s_frage.command        = 'signal';
				s_frage.single         = 1;
				s_frage.prot           = 0;
				s_frage.sort_list      = 1;
				
				[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = char(s_frage.c_name(selection(1)));
%                else
%                    return;
                end
                
            
            case 2  % index_flag
                                
   				s_frage.frage = 'Soll Index(y) oder x-Wert(n)/Zeitwert(1. Kanal) benutzt werden';
				s_frage.prot      = 0;
				s_frage.command   = 'index_flag';
				s_frage.default   = 1;
                s_frage.def_value = 'y';
		                
                [flag] = o_abfragen_jn_f(s_frage);
                
                if( flag )
                    s_liste(option).c_value{1} = 1;
                else
                    s_liste(option).c_value{1} = 0;
                end
                s_liste(option).tbd        = 0;
                
            case 3  %x_value0
                
                y_name       = s_liste(1).c_value{1};
                index_flag = s_liste(2).c_value{1};
                x_value0     = s_liste(3).c_value{1};
                x_value1     = s_liste(4).c_value{1};
                y_max = -1e30;
                y_min = 1e30;
                h = figure;
                for i=1:length(data_selection)
                    
                    if( ~index_flag ) % X-Werte
                        name = fieldnames( s_duh.s_data(data_selection(i)).d );
                        x_name = name{1};
                        
                        if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                            plot(s_duh.s_data(data_selection(i)).d.(x_name) ...
                                ,s_duh.s_data(data_selection(i)).d.(y_name) ...
                                ,'Color',PlotStandards.Farbe{i} ...
                                )
                            y_max = max(y_max,max(s_duh.s_data(data_selection(i)).d.(y_name)));
                            y_min = min(y_min,min(s_duh.s_data(data_selection(i)).d.(y_name)));
                            
                        end
                    else
                        if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                            plot(s_duh.s_data(data_selection(i)).d.(y_name) ...
                                ,'Color',PlotStandards.Farbe{i} ...
                                )
                            y_max = max(y_max,max(s_duh.s_data(data_selection(i)).d.(y_name)));
                            y_min = min(y_min,min(s_duh.s_data(data_selection(i)).d.(y_name)));
                        end
                        
                    end
                    hold on
                end
                if( ~first_run_flag )
                    plot([x_value0,x_value0],[y_min,y_max],'k:')
                    plot([x_value1,x_value1],[y_min,y_max],'k:')
                end

                hold off
                grid on
                
				s_frage.frage     = 'X0-Wert/Index0 festlegen (Anfang Wertebereich für Angleichung)';
				s_frage.prot      = 0;
				s_frage.command   = 'x_value0';
				s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    if( ~index_flag )
                        s_liste(option).c_value{1} = value;
                    else
                        s_liste(option).c_value{1} = round(value);
                    end
                    s_liste(option).tbd        = 0;
                    
                    % Endwert vorbelegen
                    if( first_run_flag )
                        s_liste(option+1).c_value{1} = value;
                        first_run_flag = 0;
                    end
                end
                
                close(h)
                
            case 4 % x_value1
                
                y_name       = s_liste(1).c_value{1};
                index_flag   = s_liste(2).c_value{1};
                x_value0     = s_liste(3).c_value{1};
                x_value1     = s_liste(4).c_value{1};
                h = figure;
                y_max = -1e30;
                y_min = 1e30;
                for i=1:length(data_selection)
                    
                    if( ~index_flag ) % X-Werte
                        name = fieldnames( s_duh.s_data(data_selection(i)).d );
                        x_name = name{1};
                        
                        if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                            plot(s_duh.s_data(data_selection(i)).d.(x_name) ...
                                ,s_duh.s_data(data_selection(i)).d.(y_name) ...
                                ,'Color',PlotStandards.Farbe{i} ...
                                )
                            y_max = max(y_max,max(s_duh.s_data(data_selection(i)).d.(y_name)));
                            y_min = min(y_min,min(s_duh.s_data(data_selection(i)).d.(y_name)));
                        end
                    else
                        if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                            plot(s_duh.s_data(data_selection(i)).d.(y_name) ...
                                ,'Color',PlotStandards.Farbe{i} ...
                                )
                            y_max = max(y_max,max(s_duh.s_data(data_selection(i)).d.(y_name)));
                            y_min = min(y_min,min(s_duh.s_data(data_selection(i)).d.(y_name)));
                        end
                        
                    end
                    hold on
                end
                
                plot([x_value0,x_value0],[y_min,y_max],'k:')
                plot([x_value1,x_value1],[y_min,y_max],'k:')
                hold off
                grid on
                
				s_frage.frage     = sprintf('X1-Wert/Index1 festlegen (X0=%f,Anfang Wertebereich für Angleichung)',x_value0);
				s_frage.prot      = 0;
				s_frage.command   = 'x_value1';
				s_frage.type      = 'double';
                s_frage.default   = x_value0;
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    if( ~index_flag )
                        s_liste(option).c_value{1} = value;
                    else
                        s_liste(option).c_value{1} = round(value);
                    end
                    s_liste(option).tbd        = 0;
                    
                end
                close(h)
                
            case 5 % target_value
                y_name       = s_liste(1).c_value{1};
                index_flag   = s_liste(2).c_value{1};
                x_value0     = s_liste(3).c_value{1};
                x_value1     = s_liste(4).c_value{1};
                
                icom = 0;
                
                if( abs(x_value1-x_value0) < eps ) % Nur Einwert Ausgabe
                    
                    yvec = cell(length(data_selection),1);
                    yy   = 0;
                    n    = 0;
                    for i=1:length(data_selection)                                                
                        
                        if( ~index_flag )
                            
                            name = fieldnames( s_duh.s_data(data_selection(i)).d );
                            x_name = name{1};
                            
                            index = suche_index(s_duh.s_data(data_selection(i)).d.(x_name),x_value0);
                        else
                            if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                                index = max(1,min(length(s_duh.s_data(data_selection(i)).d.(y_name)),x_value0));
                            else
                                index = 1;
                            end
                        end
                            
                        if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )  % EInzelwerte  
                            icom = icom +1;
                            s_frage.c_comment{icom} = sprintf('%s: y_value: %g' ...
                                                             ,s_duh.s_data(data_selection(i)).name ...
                                                             ,s_duh.s_data(data_selection(i)).d.(y_name)(index) ...
                                                             );
                            yvec{i} = s_duh.s_data(data_selection(i)).d.(y_name)(index);
                            yy      = yy + yvec{i};
                            n       = n + 1;
                            
                        end
                        
                    end
                    if( n > 0 )
                        ym = yy/n;
                        icom = icom +1;
                        s_frage.c_comment{icom} = sprintf('y_mean: %g',ym);
                    end
                    
                else % Wertebereich plotten und Mittelwert berechnen
                    h = figure;
                    for i=1:length(data_selection)
                    
                        if( ~index_flag ) % X-Werte
                            name = fieldnames( s_duh.s_data(data_selection(i)).d );
                            x_name = name{1};
                        
                            if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                                plot(s_duh.s_data(data_selection(i)).d.(x_name) ...
                                    ,s_duh.s_data(data_selection(i)).d.(y_name) ...
                                    ,'Color',PlotStandards.Farbe{i} ...
                                    )
                            end
                        else
                            if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                                plot(s_duh.s_data(data_selection(i)).d.(y_name) ...
                                    ,'Color',PlotStandards.Farbe{i} ...
                                    )
                            end
                        
                        end
                        hold on
                    end
                    hold off
                    grid on
                    xlim([x_value0,x_value1])
                    
                    % Vektorstücke
                    yvec = cell(length(data_selection),1);
                    for i=1:length(data_selection)                                                
                        
                        if( ~index_flag )
                            
                            name = fieldnames( s_duh.s_data(data_selection(i)).d );
                            x_name = name{1};
                            
                            index0  = suche_index(s_duh.s_data(data_selection(i)).d.(x_name),x_value0);
                            index1  = suche_index(s_duh.s_data(data_selection(i)).d.(x_name),x_value1);
                            
                        else
                            if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                                index0 = max(1,min(length(s_duh.s_data(data_selection(i)).d.(y_name)),x_value0));
                                index1 = max(1,min(length(s_duh.s_data(data_selection(i)).d.(y_name)),x_value1));
                            else
                                index1 = 1;
                            end
                        end
                        if( index0 > index1 )
                            dum    = index0;
                            index0 = index1;
                            index1 = dum;
                        end
                        if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )

                            yvec{i} = s_duh.s_data(data_selection(i)).d.(y_name)(index0:index1);
                        end
                    end

                    % Anfangs-, Mitttel-, Endwert
                    ya = cell(length(data_selection),1);
                    ym = cell(length(data_selection),1);
                    ye = cell(length(data_selection),1);
                    for i=1:length(data_selection)                                                
                            
                        if( ~isempty(yvec{i}) )  
                            ya{i} = yvec{i}(1);
                            icom = icom +1;
                            s_frage.c_comment{icom} = sprintf('%s: y_start: %g' ...
                                                             ,s_duh.s_data(data_selection(i)).name ...
                                                             ,ya{i} ...
                                                             );
                            
                            ym{i} = mean(yvec{i});
                            icom = icom +1;
                            s_frage.c_comment{icom} = sprintf('%s: y_mean: %g' ...
                                                             ,s_duh.s_data(data_selection(i)).name ...
                                                             ,ym{i} ...
                                                             );
                            ye{i} = yvec{i}(length(yvec{i}));
                            icom = icom +1;
                            s_frage.c_comment{icom} = sprintf('%s: y_end: %g' ...
                                                             ,s_duh.s_data(data_selection(i)).name ...
                                                             ,ye{i} ...
                                                             );                                                         
                        end
                    end
                       
                    n = 0;
                    yaa = 0;
                    ymm = 0;
                    yee = 0;
                    for i=1:length(data_selection)
                        
                        if( ~isempty(ya{i}) )
                            n = n+1;
                            yaa = yaa+ya{i};
                            ymm = ymm+ym{i};
                            yee = yee+ye{i};
                        end
                    end
                    yaa = yaa/n;
                    ymm = ymm/n;
                    yee = yee/n;

                    if( n > 0 )
                        icom = icom +1;
                        s_frage.c_comment{icom} = sprintf('Over all: y_start_mean: %g',yaa);
                        icom = icom +1;
                        s_frage.c_comment{icom} = sprintf('Over all: y_mean_mean: %g',ymm);
                        icom = icom +1;
                        s_frage.c_comment{icom} = sprintf('Over all: y_end_mean: %g',yee);
                    end
                    
                end

                s_frage.frage     = 'Auf welchen Wert soll angelichen werden werden)';
				s_frage.prot      = 0;
				s_frage.command   = 'target_value';
				s_frage.type      = 'double';
		
                [okay,target_value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_liste(option).c_value{1} = target_value;
                    s_liste(option).tbd        = 0;
                    
                    % Offsets berechnen
                    yoffset = cell(length(data_selection),1);
                    for i=1:length(data_selection)                                                
                            
                        if( ~isempty(yvec{i}) )
                            
                            yoffset{i} = target_value - mean( yvec{i} );
                        end
                    end
                    
                end
               
             
                if( exist('h','var') )
                    close(h)
                end
            case 6
                s_frage.comment  = 'Neuer Name mit angehängtem _oc ?';
                s_frage.default  = 1;
                s_frage.def_value  = ~s_liste(option).c_value{1};

                if( o_abfragen_jn_f(s_frage) )
                    s_liste(option).c_value{1} = 1;
                else
                    s_liste(option).c_value{1} = 0;
                end
                s_liste(option).tbd     = 0;
        end
	end
end


y_name        = s_liste(1).c_value{1};
index_flag    = s_liste(2).c_value{1};
x_value0      = s_liste(3).c_value{1};
x_value1      = s_liste(4).c_value{1};
target_value  = s_liste(6).c_value{1};
new_name_flag = s_liste(6).c_value{1};


% Offset bestimmen, wenn remote gefahren wird
%============================================
if( ~exist('yoffset','var') )
    
    if( abs(x_value1-x_value0) < eps ) % Nur Einwert Ausgabe

        yvec = cell(length(data_selection),1);
        for i=1:length(data_selection)                                                

            if( ~index_flag )

                name = fieldnames( s_duh.s_data(data_selection(i)).d );
                x_name = name{1};

                index = suche_index(s_duh.s_data(data_selection(i)).d.(x_name),x_value0);
            else
                if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                    index = max(1,min(length(s_duh.s_data(data_selection(i)).d.(y_name)),x_value0));
                else
                    index = 1;
                end
            end

            if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )  % EInzelwerte  
                yvec{i} = s_duh.s_data(data_selection(i)).d.(y_name)(index);
            end

        end

    else % Wertebereich plotten und Mittelwert berechnen

        % Vektorstücke
        yvec = cell(length(data_selection),1);
        for i=1:length(data_selection)                                                

            if( ~index_flag )

                name = fieldnames( s_duh.s_data(data_selection(i)).d );
                x_name = name{1};

                index0  = suche_index(s_duh.s_data(data_selection(i)).d.(x_name),x_value0);
                index1  = suche_index(s_duh.s_data(data_selection(i)).d.(x_name),x_value1);

            else
                if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )
                    index0 = max(1,min(length(s_duh.s_data(data_selection(i)).d.(y_name)),x_value0));
                    index1 = max(1,min(length(s_duh.s_data(data_selection(i)).d.(y_name)),x_value1));
                else
                    index0 = 1;
                    index1 = 1;
                end
            end
            if( index0 > index1 )
                dum    = index0;
                index0 = index1;
                index1 = dum;
            end
            if( isfield(s_duh.s_data(data_selection(i)).d,y_name) )

                yvec{i} = s_duh.s_data(data_selection(i)).d.(y_name)(index0:index1);
            end
        end


    end
    
    % Offsets berechnen
    yoffset = cell(length(data_selection),1);
    for i=1:length(data_selection)                                                

        if( ~isempty(yvec{i}) )

            yoffset{i} = target_value - mean( yvec{i} );
        end
    end
    
end

%==========================================================================




for i=1:length(data_selection)
    
    % data index
    i_data = data_selection(i);
    
    if( ~isempty(yoffset{i}) )                 
        vektor = s_duh.s_data(i_data).d.(y_name) +  yoffset{i};

        if( new_name_flag )
            s_duh.s_data(i_data).d.([y_name,'_oc']) = vektor;
            s_duh.s_data(i_data).u.([y_name,'_oc']) = s_duh.s_data(i_data).u.(y_name);
        else
            s_duh.s_data(i_data).d.(y_name) = vektor;
        end
                                                                       
    end
end
