% $JustDate:: 15.11.05  $, $Revision:: 2 $ $Author:: Tftbe1    $
% $JustDate:: 15 $, $Revision:: 2 $ $Author:: Tftbe1    $
function s_duh = duh_daten_organisieren_f(s_duh)

s_duh_liste = o_abfragen_verzweigung_liste_erstellen_f ...
             (1,'show_data_set'      ,'Datensätze anzeigen' ...
             ,1,'show_data_names'    ,'Datennamen eines Datensatzes anzeigen' ...
             ,1,'resolve_data'       ,'Datennamen eines Datensatzes auflösen' ...
             ,1,'resolve_data_set'   ,'Datensatz in [d,u] auflösen' ...
             ,1,'get_resolved_data'  ,'aufgelöster Datensatz oder Datennamen wieder zurück holen' ...
             ,1,'clear_resolved_data','aufgelöste Datennamen eines Datensatzes löschen' ...
             ,1,'delete_data_set'    ,'Datensatz löschen' ...
             ,1,'x_vec'              ,'unabhängiges Messsignal auswählen und nach vorne sortieren' ...
             ,1,'my_func'            ,'m-File (my_name.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,h]=my_func(d,u,h)' ...
             ,1,'change_name'        ,'Name eines Messsignals ändern' ...
             ,1,'change_unit'        ,'Einheit eines Messsignals ändern' ...
             ,1,'delete_vektors'     ,'einzelne Messsignale löschen' ...
             ,1,'same_sample_length' ,'gleiche minimale Abtastlänge' ...
             ,1,'copy_vektor'        ,'Messsignal kopieren und neuen Namen geben' ...
             ,1,'delta_t'            ,'delta_t/delta_x aus erstem Messsignal anzeigen' ...
             ,1,'new_dataset'        ,'Neuen leeren Datensatz generieren' ...
             ,1,'copy_channels'      ,'Messsignale aus erstem Datensatz in zweiten Datensatz kopieren (neuer Datensatz muß generiert sein)' ...
             ,1,'my_func_c'          ,'m-File (my_name.m) für eigene Auswertung bestimmen (mit c-Struktur h{2} = c) (Interface zwingend [d,u,c]=my_func(d,u,c)' ...
             );

[end_flag,option,s_duh.s_prot,s_duh.s_remote] = o_abfragen_verzweigung_f(s_duh_liste,s_duh.s_prot,s_duh.s_remote);

if( end_flag )
   return;
end

switch option
    case 1 % Datensätze anzeigen
        
        for i=1:s_duh.n_data
            fprintf('---------------------------------------------\n');
            fprintf('%i. Datensatz:\n',i);
            fprintf('Name    : %s\n',s_duh.s_data(i).name);
            fprintf('Filename: %s\n',s_duh.s_data(i).file);
            if( ~isempty(s_duh.s_data(i).c_prc_files) )
                for j=1:length(s_duh.s_data(i).c_prc_files)
                    fprintf('prc-file: %s\n',char(s_duh.s_data(i).c_prc_files{j}));
                end
            end
            if( ~isempty(s_duh.s_data(i).h) )
                for j=1:length(s_duh.s_data(i).h)
                  if( ischar(s_duh.s_data(i).h{j}) )
                    fprintf('comment: %s\n',char(s_duh.s_data(i).h{j}));
                  end
                end
            end
            [okay,n] = duh_auswert_f(s_duh.s_data(i),1);
            if( okay )
                fprintf('Anzahl Daten: %i\n',n);
            end
            [okay,n] = duh_auswert_f(s_duh.s_data(i),2);
            if( okay )
                fprintf('maxDatenlänge: %i\n',n);
            end
            [okay,n] = duh_auswert_f(s_duh.s_data(i),3);
            if( okay )
                fprintf('minDatenlänge: %i\n',n);
            end
        end
            fprintf('---------------------------------------------\n');
        
        if( ~s_duh.s_remote.run_flag )
            input('Weiter mit <return>','s')
        end
    case 2 % Datennamen eines Datensatzes anzeigen
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensatz auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 1;
            s_frage.prot           = 1;

            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            value = selection(1);
            fprintf('---------------------------------------------\n');
            fprintf('%i. Datensatz: %s\n',value,s_duh.s_data(value).file);
            fprintf('length   name\n');
            c_names = fieldnames(s_duh.s_data(value).d);
            for i=1:length(c_names)
                le = length(s_duh.s_data(value).d.(char(c_names{i})));
                fprintf('%-8i %s\n',le,char(c_names{i}));               
            end
 
            fprintf('---------------------------------------------\n');
            if( ~s_duh.s_remote.run_flag )
                input('Weiter mit <return>','s')
            end
            
        end
    case 3 % Datennamen eines Datensatzes auflösen
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensatz auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 1;
            s_frage.prot           = 1;

            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            value = selection(1);
            if( okay )
                clear s_frage
                c_arr            = fieldnames(s_duh.s_data(value).d);
                
                s_frage.c_liste = c_arr;
                s_frage.c_name  = c_arr;
    
                s_frage.frage          = sprintf('Datennamen aus Datensatz auswählen ?');
                s_frage.command        = 'data_names';
                s_frage.single         = 0;
                s_frage.prot_name      = 1;
								s_frage.sort_list      = 1;
								
                [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay )

                    s_duh.post_command_run = 1;
                    if( isfield(s_duh,'s_duh.resolved_data_names') )
                        len = length(s_duh.resolved_data_names);
                    else
                        len = 0;
                    end
                    for i=1:length(selection)
                        ind = selection(i);
                        s_duh.c_post_command{i} = [char(c_arr{ind}),'=s_duh.s_data(%i).d.',char(c_arr{ind}),';'];
                        s_duh.c_post_command{i} = sprintf(s_duh.c_post_command{i},value);
                        len = len+1;
                        s_duh.resolved_data_names{len} = char(c_arr{ind});
                    end
                end
            end
                         
        end
    case 4 % Datensatz in [d,u,h,f] auflösen
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
                        
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%s (%s)',s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end

            s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 0;
						
            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

            if( okay )
                
                s_duh.post_command_run = 1;
                if( isfield(s_duh,'s_duh.resolved_data_names') )
                    len = length(s_duh.resolved_data_names);
                else
                    len = 0;
                end
                
                
                s_duh.c_post_command{1} = sprintf('d=s_duh.s_data(1).d;');
                s_duh.c_post_command{2} = sprintf('u=s_duh.s_data(1).u;');
                %s_duh.c_post_command{3} = sprintf('h={};');
                s_duh.c_post_command{3} = sprintf('f={};');
                s_duh.c_post_command{4} = sprintf('name={};');
                
                s_duh.resolve_data_set = [];
                for i=1:length(selection)
                    
                    value = selection(i);
                    
                    s_duh.c_post_command{i*4+1} = sprintf('d(%i)=s_duh.s_data(%i).d;',i,value);
                    s_duh.c_post_command{i*4+2} = sprintf('u(%i)=s_duh.s_data(%i).u;',i,value);
                    %s_duh.c_post_command{i*4+3} = sprintf('h(%i)=s_duh.s_data(%i).h;',i,value);
                    s_duh.c_post_command{i*4+3} = sprintf('f{%i}=s_duh.s_data(%i).file;',i,value);
                    s_duh.c_post_command{i*4+4} = sprintf('name{%i}=s_duh.s_data(%i).name;',i,value);
                
                    s_duh.resolved_data_names{len+1}  = 'd';
                    s_duh.resolved_data_names{len+2}  = 'u';
                    %s_duh.resolved_data_names{len+3}  = 'h';
                    s_duh.resolved_data_names{len+3}  = 'f';
                    s_duh.resolved_data_names{len+4}  = 'name';
                    s_duh.resolve_data_set            = [s_duh.resolve_data_set,value];
                end
            end
             
        end
    case 5 %  aufgelöste Datennamen zurückholen
        
        if( isfield(s_duh,'resolve_data_set') & length(s_duh.resolve_data_set) > 0 )
            
            for i = 1:length(s_duh.resolve_data_set)
                s_duh.c_post_command{1} = sprintf('s_duh.s_data(%i).d=d(%i);',s_duh.resolve_data_set(i),i);
                s_duh.c_post_command{2} = sprintf('s_duh.s_data(%i).u=u(%i);',s_duh.resolve_data_set(i),i);
                %s_duh.c_post_command{3} = sprintf('s_duh.s_data(%i).h=h(%i);',s_duh.resolve_data_set(i),i);
                %s_duh.c_post_command{4} = sprintf('s_duh.s_data(%i).file=f;',s_duh.resolve_data_set(i),i);
                s_duh.c_post_command{5} = sprintf('s_duh.s_data(%i).u = duh_check_du_f(s_duh.s_data(%i).d,s_duh.s_data(%i).u);', ...
                                      s_duh.resolve_data_set(i),s_duh.resolve_data_set(i),s_duh.resolve_data_set(i));
            end
            s_duh.resolve_data_set = 0;
            s_duh.post_command_run = 1;
        else
            o_ausgabe_f('keine aufgelösten data gefunden, s_duh.resove_data_set',s_duh.s_prot.debug_fid);
        end
           
    case 6 % Lösche aufgelöste Datennamen
        if( isfield(s_duh,'resolved_data_names') & length(s_duh.resolved_data_names) > 0 )
            s_duh.post_command_run = 1;
            for i=1:length(s_duh.resolved_data_names)
                s_duh.c_post_command{i} = ['clear ',s_duh.resolved_data_names{i}];
            end
            s_duh.resolved_data_names = {};
        end
    case 7 % Datensatz löschen
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
    		    s_frage.command        = 'data_set';
            s_frage.single         = 0;

    		[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                if( length(selection) == s_duh.n_data )
                    s_duh.s_data(1).file        = '';
                    s_duh.s_data(1).c_prc_files = {};
                    s_duh.s_data(1).d.a         = 0;
                    s_duh.s_data(1).u.a         = '';
                    s_duh.s_data(1).h   = {};
                    
                    s_duh.n_data = 0;
                else
%                   selection = sortiere_abfallend_f(selection);
%                   for i = 1:length(selection)                        
%                      for j=selection(i):s_duh.n_data-1
%                          s_duh.s_data(j) = s_duh.s_data(j+1);
%                      end
%                      s_duh.n_data = s_duh.n_data - 1;
%                   end
                    icount = 0;
                    for i=1:s_duh.n_data
                        copy_flag = 1;
                        for j=1:length(selection)
                            if( selection(j) == i )
                                copy_flag = 0;
                            end
                        end
                        if( copy_flag )
                            icount = icount + 1;
                            s_data(icount) = s_duh.s_data(i);
                        end
                    end
                    s_duh.s_data = s_data;
                    s_duh.n_data = icount;
                end
            end
        end
    case 8 % unabhängige Variable sortieren
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
		    s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
		    s_frage.command        = 'data_set';
            s_frage.single         = 0;
    		s_frage.prot           = 1;

    		[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                clear s_frage
                s_frage.c_liste = fieldnames(s_duh.s_data(selection(1)).d);                
			    s_frage.frage          = 'Den unabhängigen Vektor bestimmen (z.B. Zeit) ?';
			    s_frage.command        = 'x_vec_name';
                s_frage.single         = 1;
        		s_frage.prot           = 1;
					s_frage.sort_list      = 1;
					
        		[okay,iv,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay )
                    
                    for i=1:length(selection)
                        id = selection(i);
                        
                        if( isfield(s_duh.s_data(id).d,s_frage.c_liste{iv}) )
                            d.(s_frage.c_liste{iv}) = getfield(s_duh.s_data(id).d,s_frage.c_liste{iv});
                        end
                        if( isfield(s_duh.s_data(id).u,s_frage.c_liste{iv}) )
                            u.(s_frage.c_liste{iv}) = getfield(s_duh.s_data(id).u,s_frage.c_liste{iv});
                        end
                        for j=1:length(s_frage.c_liste)
                            if( j ~= iv )
                                if( isfield(s_duh.s_data(id).d,s_frage.c_liste{j}) )
                                    d.(s_frage.c_liste{j}) = getfield(s_duh.s_data(id).d,s_frage.c_liste{j});
                                end
                                if( isfield(s_duh.s_data(id).u,s_frage.c_liste{j}) )
                                    u.(s_frage.c_liste{j}) = getfield(s_duh.s_data(id).u,s_frage.c_liste{j});
                                end
                            end
                        end
                        
                        s_duh.s_data(id).d = d;
                        s_duh.s_data(id).u = u;
                        
                    end
                    
                end
            end
           
        end
    case 9 %m-File (my_name.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,h]=my_func(d,u,h)
        
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 0;
            s_frage.prot           = 1;

            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
		
                s_frage.comment   = 'm-File (my_func.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,h]=my_func(d,u,h)';
				s_frage.command   = 'my_func_file';
        		s_frage.prot      = 1;
                s_frage.file_spec = '*.m';
                s_frage.start_dir = s_duh.start_dir;
                s_frage.file_number    = 0;
		
         		[okay1,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
		
                if( okay1 )
                    
                    for i=1:length(selection)
                        
                        for j=1:length(c_filenames)
                            
                            my_func_file = c_filenames{j};
                            i_sel        = selection(i);
                        
                            s_file = str_get_pfe_f( my_func_file );
                    
                            o_ausgabe_f('\n--------------------------------------------------------------------------\n',0);
                            if( length(s_file.dir) > 0 )
                                act_dir = pwd;
                                command = ['cd ',s_file.dir];
                                o_ausgabe_f(command,0);
                                o_ausgabe_f('\n',0);
                                eval(command);
                            else
                                act_dir = '.'
                            end
                    
                            command = ['[s_duh.s_data(i_sel).d,s_duh.s_data(i_sel).u,s_duh.s_data(i_sel).h] = ',s_file.name,'(s_duh.s_data(i_sel).d,s_duh.s_data(i_sel).u,s_duh.s_data(i_sel).h);'];
                            o_ausgabe_f(command,0);
                            o_ausgabe_f('\n',0);
                            try
                              eval(command);
                              command = ['cd ',act_dir];
                              eval(command);
                            catch exception
                              command = ['cd ',act_dir];
                              eval(command);
                              throw(exception)
                            end
                            o_ausgabe_f('\n--------------------------------------------------------------------------',0);
                            s_duh.s_data(i_sel).u = duh_check_du_f(s_duh.s_data(i_sel).d,s_duh.s_data(i_sel).u);
                        end
                    end
                end %end okay1
            end % end okay
        end % end no data
        
    case 10 % NAmen ändern
        
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 1;
            s_frage.prot           = 1;

            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                clear s_frage
                s_frage.c_liste = fieldnames(s_duh.s_data(selection(1)).d);                
			    s_frage.frage          = 'Den zu änderten Vektor bestimmen ?';
			    s_frage.command        = 'vec_name';
                s_frage.single         = 1;
        		s_frage.prot           = 1;
						s_frage.sort_list      = 1;
						
        		[okay,iv,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay )
                    
                    old_name = s_frage.c_liste{iv};
                    clear s_frage
		            s_frage.frage          = 'Wie soll der neue Name heißen (oder default verwenden)?';
		            s_frage.command        = 'new_name';
                    s_frage.type           = 'char';
                    s_frage.default        = old_name;
    		        s_frage.prot           = 1;

    		        [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                    
                    if( okay )
                        
                        command = ['s_duh.s_data(selection(1)).d.',value,' = s_duh.s_data(selection(1)).d.',old_name,';'];
                        eval(command);                    
                        command = ['s_duh.s_data(selection(1)).u.',value,' = s_duh.s_data(selection(1)).u.',old_name,';'];
                        eval(command);                    
                        
                        command = ['s_duh.s_data(selection(1)).d  = rmfield(s_duh.s_data(selection(1)).d,old_name);'];
                        eval(command);                    
                        command = ['s_duh.s_data(selection(1)).u  = rmfield(s_duh.s_data(selection(1)).u,old_name);'];
                        eval(command); 
                    end
                end
            end
        end

    case 11 % Einheit ändern
        
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 1;
            s_frage.prot           = 1;

            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                clear s_frage
                s_frage.c_liste = fieldnames(s_duh.s_data(selection(1)).d);  
                s_frage.c_name  = s_frage.c_liste;
                s_frage.frage          = 'Den zu änderten Vektor bestimmen ?';
                s_frage.command        = 'vec_name';
                s_frage.single         = 1;
                s_frage.prot           = 1;
                s_frage.sort_list      = 1;
						
                [okay,iv,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay )
                    
                    old_name = s_frage.c_liste{iv};
                    clear s_frage
		            s_frage.frage          = sprintf('Wie soll die neue Einheit von %s sein ?',old_name);
		            s_frage.command        = 'new_unit';
                    s_frage.type           = 'char';
                    s_frage.default        = s_duh.s_data(selection(1)).u.(old_name);
    		        s_frage.prot           = 1;

    		        [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                    
                    if( okay )
                        
                        s_duh.s_data(selection(1)).u.(old_name) = value;
                        
                    end
                end
            end
        end
    case 12 % Vektoren löschen
        
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 1;
            s_frage.prot           = 1;

            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                clear s_frage
                c_names         = fieldnames(s_duh.s_data(selection(1)).d);
                c_liste         = {};
                for i=1:length(c_names)
                    c_liste{i} = [c_names{i},'(',num2str(length(s_duh.s_data(selection(1)).d.(c_names{i}))),')'];
                end
                s_frage.c_liste        = c_liste;
                s_frage.c_name         = c_names;
                s_frage.frage          = 'Die zu löschenenden Vektoren bestimmen ?';
                s_frage.command        = 'vec_names';
                s_frage.single         = 0;
                s_frage.prot           = 1;
                s_frage.prot_name      = 1;
                s_frage.sort_list      = 1;

                [okay,iv,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay )
                    
                    for i=1:length(iv)
                        
                        j = iv(i);
                        s_duh.s_data(selection(1)).d = rmfield(s_duh.s_data(selection(1)).d,c_names{j});
                    end
                end
            end
        end % end no data            
            
    case 13 % gleiche Abtastlänge
        
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 0;
            s_frage.prot           = 1;

            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                n_min = 1e39;
                for j=1:length(selection)
                    c_names         = fieldnames(s_duh.s_data(selection(j)).d);
                    % n_min           = length(s_duh.s_data(selection(j)).d.(c_names{1}));
                    for i=1:length(c_names)
                    
                        n = length(s_duh.s_data(selection(j)).d.(c_names{i}));
                        n_min = min(n_min,n);
                    end
                end
                for j=1:length(selection)
                    c_names         = fieldnames(s_duh.s_data(selection(j)).d);
                    for i=1:length(c_names)
                        s_duh.s_data(selection(j)).d.(c_names{i}) = s_duh.s_data(selection(j)).d.(c_names{i})(1:n_min);
                    end
                end
            end
        end % end no data            
            
    case 14 % Vektor kopieren
        
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
            s_frage.frage          = 'Datensatz auswählen ?';
            s_frage.command        = 'data_set';
            s_frage.single         = 1;
            s_frage.prot           = 1;

            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                clear s_frage
                c_names         = fieldnames(s_duh.s_data(selection(1)).d);
                c_liste         = {};
                for i=1:length(c_names)
                    c_liste{i} = [c_names{i},'(',num2str(length(s_duh.s_data(selection(1)).d.(c_names{i}))),')'];
                end
                s_frage.c_liste        = c_liste;
                s_frage.c_name         = c_names;
			          s_frage.frage          = 'Den zu kopierenden Vektor bestimmen ?';
			          s_frage.command        = 'vec_name';
                s_frage.single         = 1;
        		    s_frage.prot           = 1;
                s_frage.prot_name      = 1;
						    s_frage.sort_list      = 1;
						
        		[okay,iv,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay )
                    
                    clear s_frage
		            s_frage.frage          = 'Wie soll der Name des kopierten Vektors heißen ?';
		            s_frage.command        = 'copy_name';
                s_frage.type           = 'char';
                s_frage.default        = [c_names{iv},'_1'];
    		        s_frage.prot           = 1;

    		        [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                    
                    if( okay )
                    
                        s_duh.s_data(selection(1)).d.(value) = s_duh.s_data(selection(1)).d.(c_names{iv});
                        if( isfield(s_duh.s_data(selection(1)).u,c_names{iv}) )
                            s_duh.s_data(selection(1)).u.(value) = s_duh.s_data(selection(1)).u.(c_names{iv});
                        else
                            s_duh.s_data(selection(1)).u.(value) = '';
                        end
                    end
                    
                end
            end
        end % end no data            
    case 15 % delta_t anzeigen
        
        if( s_duh.n_data == 0 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten vorhanden (Weiter mit <return>)','s')
            end
        else
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
		    s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
		    s_frage.command        = 'data_set';
        s_frage.single         = 1;
    		s_frage.prot           = 1;

    		[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                cnames = fieldnames(s_duh.s_data(selection).d);
                vec = s_duh.s_data(selection).d.(cnames{1});
                if( ist_monton_steigend(vec) )
                    
                    dvec = diff(vec);
                    delta_t = mean(dvec);
                    minvec = min(dvec)
                    maxvec = max(dvec)
                    stdvec = std(dvec);

                    fprintf('---------------------------------------------\n');
                    fprintf('%i. Datensatz:\n',selection);
                    fprintf('Filename:      %s\n',s_duh.s_data(selection).file);
                    fprintf('DatensatzName: %s\n\n',s_duh.s_data(selection).name);
                    fprintf('VektorName:    %s\n\n',cnames{1});
                    fprintf('delta_%s:     %g\n',cnames{1},delta_t);                    
                    fprintf('min:          %g\n',minvec);                    
                    fprintf('max:          %g\n',maxvec);                    
                    fprintf('std:          %g\n',stdvec);                    
                    
                else
                    if( ~s_duh.s_remote.run_flag )
                        input('Erster Vektor ist nicht montonsteigend (Weiter mit <return>)','s')
                    end
                end
            end         
        end
    case 16 % neuen Datensatz generieren
        
        clear s_frage
        s_frage.frage          = 'Wie soll der Name des Datensatzes heißen ?';
        s_frage.command        = 'data_set_name';
        s_frage.type           = 'char';
        s_frage.default        = ['data_set_',num2str(s_duh.n_data+1)];
        s_frage.prot           = 1;

        [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        
        if( okay )
            
           s_duh.n_data                    = s_duh.n_data+1; 
           s_duh.s_data(s_duh.n_data).name = value;
           s_duh.s_data(s_duh.n_data).h    = {[datestr(now),' new-data-set']};
           s_duh.s_data(s_duh.n_data).file = 'no';
        end
    case 17 % Kanäle kopieren
        
        if( s_duh.n_data < 2 )
            if( ~s_duh.s_remote.run_flag )
                input('Keine Daten oder zuwenige Datensätze vorhanden (Weiter mit <return>)','s')
            end
        else
            for i= 1:s_duh.n_data
                s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
            end
            
		    s_frage.frage          = '1. Datensatz auswählen (aus dem wird kopiert)?';
		    s_frage.command        = 'data_set_1';
        s_frage.single         = 1;
    		s_frage.prot           = 1;

    		[okay,sel1,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                
                clear s_frage
                c_names         = fieldnames(s_duh.s_data(sel1(1)).d);
                c_liste         = {};
                for i=1:length(c_names)
                    c_liste{i} = [c_names{i},'(',num2str(length(s_duh.s_data(sel1(1)).d.(c_names{i}))),')'];
                end
                s_frage.c_liste        = c_liste;
                s_frage.c_name         = c_names;
			          s_frage.frage          = 'Die zu kopierenden Vektor(en) bestimmen ?';
			          s_frage.command        = 'vec_names';
                s_frage.single         = 0;
        		    s_frage.prot           = 1;
                s_frage.prot_name      = 1;
						    s_frage.sort_list      = 1;

        		    [okay,selv,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay )
                    
                    clear s_frage
                    for i= 1:s_duh.n_data
                        s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
                    end
                    s_frage.frage          = '2. Datensatz auswählen (in diesen wird kopiert)?';
                    s_frage.command        = 'data_set_2';
                    s_frage.single         = 1;
                    s_frage.prot           = 1;
                    s_frage.sort_list      = 1;
                    
                    [okay,sel2,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                    
                    if( okay )
                        
                        for iv = 1:length(selv)
                            
                            s_duh.s_data(sel2(1)).d.(c_names{selv(iv)}) = s_duh.s_data(sel1(1)).d.(c_names{selv(iv)});
                            s_duh.s_data(sel2(1)).u.(c_names{selv(iv)}) = s_duh.s_data(sel1(1)).u.(c_names{selv(iv)});
                        end
                    end
                end
            end            
        end
      case 18 %m-File (my_name.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,c]=my_func(d,u,c)
        
        if( s_duh.n_data == 0 )
          if( ~s_duh.s_remote.run_flag )
            input('Keine Daten vorhanden (Weiter mit <return>)','s')
          end
        else  
          for i= 1:s_duh.n_data
            s_frage.c_liste{i} = sprintf('%i. %s(%s)',i,s_duh.s_data(i).name,s_duh.s_data(i).h{1});
          end
            
          s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
          s_frage.command        = 'data_set';
          s_frage.single         = 0;
          s_frage.prot           = 1;

          [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
          if( okay )
		
            s_frage.comment     = 'm-File (my_func.m) für eigene Auswertung bestimmen (c-Struct comment h{2} = c)(Interface zwingend [d,u,c]=my_func(d,u,c)';
				    s_frage.command     = 'my_func_file';
        		s_frage.prot        = 1;
            s_frage.file_spec   = '*.m';
            s_frage.start_dir   = s_duh.start_dir;
            s_frage.file_number = 0;
		
         		[okay1,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
		
            if( okay1 )
               for i=1:length(selection)       
                 for j=1:length(c_filenames)       
                   my_func_file = c_filenames{j};
                   i_sel        = selection(i);
                        
                   s_file = str_get_pfe_f( my_func_file );
                    
                   o_ausgabe_f('\n--------------------------------------------------------------------------\n',0);
                   if( ~isempty(s_file.dir) )
                      act_dir = pwd;
                      command = ['cd ',s_file.dir];
                      o_ausgabe_f(command,0);
                      o_ausgabe_f('\n',0);
                      eval(command);
                   else
                     act_dir = '.';
                   end
                   if( (length(s_duh.s_data(i_sel).h) > 1) &&  isstruct(s_duh.s_data(i_sel).h{2})) % c-struct vorhanden
                     c = s_duh.s_data(i_sel).h{2};
                   else
                     c = d_data_build_empty_cstruct(s_duh.s_data(i_sel).d);
                   end
                   command = ['[s_duh.s_data(i_sel).d,s_duh.s_data(i_sel).u,c] = ',s_file.name,'(s_duh.s_data(i_sel).d,s_duh.s_data(i_sel).u,c);'];
                   o_ausgabe_f(command,0);
                   o_ausgabe_f('\n',0);
                   try
                     eval(command);
                     s_duh.s_data(i_sel).h{2} = c;
                     command = ['cd ',act_dir];
                     eval(command);
                   catch exception
                     command = ['cd ',act_dir];
                     eval(command);
                     throw(exception)
                   end 
                   o_ausgabe_f('\n--------------------------------------------------------------------------',0);
                   s_duh.s_data(i_sel).u = duh_check_du_f(s_duh.s_data(i_sel).d,s_duh.s_data(i_sel).u);
                 end
               end
             end %end okay1
           end % end okay
        end % end no data
        
      
end % switch
function [okay,n] = duh_auswert_f(s_data,choice)

okay = 1;
switch choice
    case 1
        n = length(fieldnames(s_data.d));
    case 2
        n = 0;
        names = fieldnames(s_data.d);
        for i=1:length(names)
            command = ['len = length(s_data.d.',char(names{i}),');'];
            eval(command);
            n = max(n,len);
        end
    case 3
        names = fieldnames(s_data.d);
        command = ['n = length(s_data.d.',char(names{1}),');'];
        eval(command);
        for i=1:length(names)
            command = ['len = length(s_data.d.',char(names{i}),');'];
            eval(command);
            n = min(n,len);
        end
end
        