function  s_duh = duh_daten_bearb_vergleich(data_selection,s_duh)
n_data_set = length(data_selection);

if( n_data_set == 1 )
    warning('EInen Datensatz zum Vergleich ist zu wenig')
    input('<pause>')
elseif( n_data_set > 2 )
    warning('Zuviele Datensätze zum Vergleich max = 2')
    input('<pause>')
else

    s_frage    = 0;
    s_liste = o_abfragen_werte_liste_erstellen_f ...
                 (1      ,'rel_error'        ,1       ,'reative Toleranz für die Abweichung in %' ...
                 ,0      ,'plot_diff_flag'   ,1       ,'Soll Abweichung geplottet werden' ...
                 ,0      ,'plot_ident_flag'  ,0       ,'Soll Übereinstimmung geplottet werden' ...
                 ,0      ,'out_diff_flag'    ,1       ,'Soll Abweichung im Text ausgegeben werden' ... 
                 ,0      ,'out_ident_flag'   ,0       ,'Soll Übereinstimmung im Text ausgegeben werden' ... 
                 ,0      ,'word_flag'        ,0       ,'Soll Ausgabe in Word erfolgen' ...
                 );
    option_flag = 1;

    while( option_flag )

        [end_flag,option_flag,option,s_liste,s_duh.s_prot,s_duh.s_remote] = ...
                                          o_abfragen_werte_liste_f(s_liste,s_duh.s_prot,s_duh.s_remote);

        if( end_flag )
           return;
        end
        if( option_flag )

            if( exist('s_frage') == 1 )
                clear s_frage
            end
            switch option

                case 1            
                    s_frage.frage     = 'reative Toleranz für die Abweichung in %';
                    s_frage.prot      = 0;
                    s_frage.type      = 'double';

                    [okay,value] = o_abfragen_wert_f(s_frage);

                    if( okay )
                        s_liste(option).c_value{1} = value;
                        s_liste(option).tbd        = 0;
                    end

                case 2

                    if( s_liste(option).c_value{1} )
                        s_liste(option).c_value{1} = 0;
                    else
                        s_liste(option).c_value{1} = 1;
                    end  
                case 3

                    if( s_liste(option).c_value{1} )
                        s_liste(option).c_value{1} = 0;
                    else
                        s_liste(option).c_value{1} = 1;
                    end  
                case 4

                    if( s_liste(option).c_value{1} )
                        s_liste(option).c_value{1} = 0;
                    else
                        s_liste(option).c_value{1} = 1;
                    end  
                case 5

                    if( s_liste(option).c_value{1} )
                        s_liste(option).c_value{1} = 0;
                    else
                        s_liste(option).c_value{1} = 1;
                    end  
                case 6

                    if( s_liste(option).c_value{1} )
                        s_liste(option).c_value{1} = 0;
                    else
                        s_liste(option).c_value{1} = 1;
                    end  

            end
        end
    end
    
    
		
   rel_err         = abs(s_liste(1).c_value{1})/100;
   plot_diff_flag  = s_liste(2).c_value{1};
   plot_ident_flag = s_liste(3).c_value{1};
   out_diff_flag   = s_liste(4).c_value{1};
   out_ident_flag  = s_liste(5).c_value{1};
   word_flag       = s_liste(6).c_value{1};
   
   

    if( okay )
        
        idat1 = data_selection(1);
        idat2 = data_selection(2);
        
        cliste1 = fieldnames(s_duh.s_data(idat1).d);
        cliste2 = fieldnames(s_duh.s_data(idat2).d);
        
        plot_flag = 0;
        
        if( word_flag == 1 )
            [okay,s_a] = ausgabe_aw('init' ...
                                   ,'name',    'duh_daten_bearb_vergleich' ...
                                   ,'path',    '.' ...
                                   ,'ascii',   0 ...
                                   ,'word',    1 ...
                                   ,'visible', 1 ...
                                   );
            if( okay )
                word_flag = 2;
            else
                word_flag = 0;
            end
            
        end

        text1 = sprintf('================================================================');
        fprintf('%s\n',text1);
        if( word_flag > 1 )    
            [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
        end
        text1 = ['Datei1: ',s_duh.s_data(idat1).name];
        fprintf('%s\n',text1);
        if( word_flag > 1 )    
            [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
        end
        text1 = ['Datei2: ',s_duh.s_data(idat2).name];
        fprintf('%s\n',text1);
        if( word_flag > 1 )    
            [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
        end

        for i1 = 1:length(cliste1)
               
            found_flag = 0;
            for i2 = 1:length(cliste2)
                
                
                if( strcmp(cliste1{i1},cliste2{i2}) )
                    
%                     if( strcmp(cliste1{i1},'Fres') )
%                         found_flag = 1;
%                     end
                    found_flag = 1;
                    
%                     if( strcmp(cliste1{i1},'SOC_end') )
%                         a = 1;
%                     end
                    
                    signal1 = s_duh.s_data(idat1).d.(cliste1{i1});
                    signal2 = s_duh.s_data(idat2).d.(cliste1{i1});
                    n1      = ndims(signal1);
                    n2      = ndims(signal2);
                    length_flag = 0;
                    
                    if( isnumeric(signal1) && isnumeric(signal2) && n1 == n2 && n1 <= 2 )
                        
                    
                        [m1,n1] = size(signal1);
                        [m2,n2] = size(signal2);
                        
                        if( m1 ~= m2 || n1 ~= n2 )
                            length_flag = 1;
                        end
                    
                        m = min(m1,m2);
                        n = min(n1,n2);
                    
                        if( n == 1 && m == 1)
                            delta = abs(signal1(1:m,1:n));
                        else
                            delta = abs(max(max(signal1(1:m,1:n)))-min(min(signal1(1:m,1:n))));
                            if( delta < 1e-20 )
                                delta = abs(max(max(signal1(1:m,1:n))));
                            end
                        end
                        abs_err = max(1.0e-20,delta)*rel_err;
                        
                        delta_s     = signal1(1:m,1:n) - signal2(1:m,1:n);
                        max_delta_s = max(max(abs(delta_s)));
                        try
                        rel_s   = max_delta_s / not_zero(delta);
                         catch
                             delta_s
                             delta
                             error('rel_s   = delta_s / not_zero(delta); funktioniert nicht')
                         end
                        if( max_delta_s > abs_err )  % Fehler gösser als Toleranz

                            if( m > 1 || n > 1)

                                if( plot_diff_flag )

                                    plot_flag = 1;

                                    % Plotten
                                    text1 = sprintf('================================================================');
                                    fprintf('%s\n',text1);
                                    if( word_flag > 1 )    
                                        [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                    end
                                    
                                    text1 = sprintf('%s',cliste1{i1});
                                    fprintf('%s\n',text1);
                                    if( word_flag > 1 )    
                                        [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                    end

                                    h = p_figure(-1,0,cliste1{i1});

                                    subplot(2,1,1)
                                    plot(signal1,'k-')
                                    hold on
                                    plot(signal2,'b-')
                                    hold off
                                    grid on
                                    title(str_change_f(cliste1{i1},'_',' '))
                                    ylabel(s_duh.s_data(idat1).u.(cliste1{i1}))
                                    xlabel('index')
                                    legend(str_change_f(s_duh.s_data(idat1).name,'_',' '),str_change_f(s_duh.s_data(idat2).name,'_',' '))

                                    subplot(2,1,2)
                                    plot(delta_s)
                                    grid on
                                    title('signal1 - signal2')

                                    zaf('setact');

                                    if( word_flag > 1 )    
                                        [okay,s_a] = ausgabe_aw('figure',s_a,'handle',h,'newline',1);
                                        [okay,s_a] = ausgabe_aw('newline',s_a);
                                        close(h)
                                    end
                                end


                            else
                                if( out_diff_flag )
                                    try
                                    text1 = sprintf('================================================================');
                                    fprintf('%s\n',text1);
                                    if( word_flag > 1 )    
                                        [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                    end
                                    text1 = sprintf('1. %s = %g %s',cliste1{i1},signal1(1),s_duh.s_data(idat1).u.(cliste1{i1}));
                                    fprintf('%s\n',text1);
                                    if( word_flag > 1 )    
                                        [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                    end

                                    text1 = sprintf('2. %s = %g %s\n',cliste1{i1},signal2(1),s_duh.s_data(idat2).u.(cliste2{i2}));
                                    fprintf('%s\n',text1);
                                    if( word_flag > 1 )    
                                        [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                    end
                                    catch
                                        a = 0;
                                    end
                                end
                            end
                            if( out_diff_flag )
                                text1 = sprintf('max. Abweichung Signal %s: %g %s',cliste1{i1},max_delta_s,s_duh.s_data(idat1).u.(cliste1{i1}));
                                fprintf('%s\n',text1);
                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                end
                                text1 = sprintf('rel. Abweichung Signal %s: %g %s',cliste1{i1},rel_s,s_duh.s_data(idat1).u.(cliste1{i1}));
                                fprintf('%s\n',text1);
                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('title',s_a,'text',text1,'newline',1,'uline','');
                                end
                            end
                        else
                            if( plot_ident_flag && (n > 1 || m > 1) )

                                plot_flag = 1;

                                % Plotten
                                text1 = sprintf('================================================================');
                                fprintf('%s\n',text1);
                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                end

                                text1 = sprintf('%s',cliste1{i1});
                                fprintf('%s\n',text1);
                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                end
                                
                                h = p_figure(-1,0,cliste1{i1});

                                subplot(2,1,1)
                                plot(signal1,'k-')
                                hold on
                                plot(signal2,'b-')
                                hold off
                                grid on
                                title(str_change_f(cliste1{i1},'_',' '))
                                ylabel(s_duh.s_data(idat1).u.(cliste1{i1}))
                                xlabel('index')
                                legend(str_change_f(s_duh.s_data(idat1).name,'_',' '),str_change_f(s_duh.s_data(idat2).name,'_',' '))

                                subplot(2,1,2)
                                plot(delta_s)
                                grid on
                                title('signal1 - signal2')

                                zaf('setact');

                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('figure',s_a,'handle',h,'newline',1);
                                    [okay,s_a] = ausgabe_aw('newline',s_a);
                                    close(h)
                                end
                            end
                            if( out_ident_flag )
                                text1 = sprintf('================================================================');
                                fprintf('%s\n',text1);
                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                end
                                text1 = sprintf('Signal <%s> ist innerhalb der Toleranz identisch',cliste1{i1});
                                fprintf('%s\n',text1);
                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                end
                                text1 = sprintf('max. Abweichung Signal %s: %g %s',cliste1{i1},max_delta_s,s_duh.s_data(idat1).u.(cliste1{i1}));
                                fprintf('%s\n',text1);
                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                end
                                text1 = sprintf('rel. Abweichung Signal %s: %g %s',cliste1{i1},rel_s,s_duh.s_data(idat1).u.(cliste1{i1}));
                                fprintf('%s\n',text1);
                                if( word_flag > 1 )    
                                    [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                                end
                            end
                        end
                    
                        break;
                    end
                    if( length_flag )
                        if( out_diff_flag )
                            text1 = sprintf('Signal %s hat unterschiedliche Längen n1=%i,m1=%i,n2=%i,m2=%i',cliste1{i1},n1,m1,n2,m2);
                            fprintf('%s\n',text1);
                            if( word_flag > 1 )    
                                [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                            end
                        end                    
                    end
                end
            end
            if( ~found_flag )
                if( out_diff_flag )
                    text1 = sprintf('Signal %s in der einen oder anderen Liste nicht vorhanden',cliste1{i1});
                    fprintf('%s\n',text1);
                    if( word_flag > 1 )    
                        [okay,s_a] = ausgabe_aw('title',s_a,'text',text1);
                    end
                end
            end
        end
        
        if( plot_flag )
            figmen
        end
        
        if( word_flag > 1 )
           [okay,s_a] = ausgabe_aw('save',s_a);
           word_flag = 0;
        end
    end
end
