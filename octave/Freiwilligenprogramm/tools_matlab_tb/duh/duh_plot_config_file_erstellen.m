function okay = duh_plot_config_file_erstellen(filename,s_fig)

    okay = 1;
    fid = fopen(filename,'w');    
    if( fid <= 0 )
        okay = 0
        warning('config_file_erstellen: file: %s konnte nicht erstellt werden',filename)
        return
    end
    
    for i_f=1:length(s_fig)
        
        fprintf(fid,'\n');
        if( length(s_fig(i_f).short_name) > 0 )
            fprintf(fid,'s_fig(%i).short_name                            = ''%s'';\n',i_f,s_fig(i_f).short_name);
        else
            fprintf(fid,'s_fig(%i).short_name                            = '''';\n',i_f);
        end
        
        fprintf(fid,'s_fig(%i).format                                = ''%s'';\n',i_f,s_fig(i_f).format);
        fprintf(fid,'s_fig(%i).rows                                  = %g;\n',i_f,s_fig(i_f).rows);
        fprintf(fid,'s_fig(%i).cols                                  = %g;\n',i_f,s_fig(i_f).cols);
        fprintf(fid,'\n');
        
        nn_plots = length(s_fig(i_f).s_plot);
        for i_p=1:s_fig(i_f).cols*s_fig(i_f).rows
            if( nn_plots >= i_p )
                if( length(s_fig(i_f).s_plot(i_p).title) > 0 )
                    fprintf(fid,'s_fig(%i).s_plot(%i).title                       = ''%s'';\n',i_f,i_p,s_fig(i_f).s_plot(i_p).title);
                else
                    fprintf(fid,'s_fig(%i).s_plot(%i).title                       = '''';\n',i_f,i_p);
                end

                fprintf(fid,'s_fig(%i).s_plot(%i).bot_title                   = ''%s'';\n',i_f,i_p,s_fig(i_f).s_plot(i_p).bot_title);
                fprintf(fid,'s_fig(%i).s_plot(%i).legend_choice               = ''%s'';\n',i_f,i_p,s_fig(i_f).s_plot(i_p).legend_choice);
                fprintf(fid,'s_fig(%i).s_plot(%i).grid_set                    = %g;\n',i_f,i_p,s_fig(i_f).s_plot(i_p).grid_set);

                fprintf(fid,'s_fig(%i).s_plot(%i).xlim_set                    = %g;\n',i_f,i_p,s_fig(i_f).s_plot(i_p).xlim_set);
                fprintf(fid,'s_fig(%i).s_plot(%i).xmin                        = %g;\n',i_f,i_p,s_fig(i_f).s_plot(i_p).xmin);
                fprintf(fid,'s_fig(%i).s_plot(%i).xmax                        = %g;\n',i_f,i_p,s_fig(i_f).s_plot(i_p).xmax);

                fprintf(fid,'s_fig(%i).s_plot(%i).ylim_set                    = %g;\n',i_f,i_p,s_fig(i_f).s_plot(i_p).ylim_set);
                fprintf(fid,'s_fig(%i).s_plot(%i).ymin                        = %g;\n',i_f,i_p,s_fig(i_f).s_plot(i_p).ymin);
                fprintf(fid,'s_fig(%i).s_plot(%i).ymax                        = %g;\n',i_f,i_p,s_fig(i_f).s_plot(i_p).ymax);

                if( length(s_fig(i_f).s_plot(i_p).x_label) > 0 )
                    fprintf(fid,'s_fig(%i).s_plot(%i).x_label                      = ''%s'';\n',i_f,i_p,s_fig(i_f).s_plot(i_p).x_label);
                else
                    fprintf(fid,'s_fig(%i).s_plot(%i).x_label                      = '''';\n',i_f,i_p);
                end

                if( length(s_fig(i_f).s_plot(i_p).y_label) > 0 )
                    fprintf(fid,'s_fig(%i).s_plot(%i).y_label                      = ''%s'';\n',i_f,i_p,s_fig(i_f).s_plot(i_p).y_label);
                else
                    fprintf(fid,'s_fig(%i).s_plot(%i).y_label                      = '''';\n',i_f,i_p);
                end

                fprintf(fid,'s_fig(%i).s_plot(%i).data_set                    = %g;\n',i_f,i_p,s_fig(i_f).s_plot(i_p).data_set);
                fprintf(fid,'\n');

                for i_d=1:s_fig(i_f).s_plot(i_p).n_data

                    fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).ndim              = %g;\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).ndim);

                    if( s_fig(i_f).s_plot(i_p).s_data(i_d).ndim == 2 )

                        fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).x_vec_name        = ''%s'';\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).x_vec_name);
                        fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).x_offset          = %g;\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).x_offset);
                        fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).x_factor          = %g;\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).x_factor);
                    end

                    fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).y_vec_name        = ''%s'';\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).y_vec_name);
                    fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).y_offset          = %g;\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).y_offset);
                    fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).y_factor          = %g;\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).y_factor);

                    fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).n_start           = %g;\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).n_start);
                    fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).n_end             = %g;\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).n_end);

                    fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).line_size         = %g;\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).line_size);
                    fprintf(fid,'s_fig(%i).s_plot(%i).s_data(%i).line_color_name   = ''%s'';\n',i_f,i_p,i_d,s_fig(i_f).s_plot(i_p).s_data(i_d).line_color_name);
                    fprintf(fid,'\n');

                end
            end
        end
    end
                                
    fclose(fid);        
