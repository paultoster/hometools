function [in,out] = abs_auswertung_plot_gesamt_f(in,out)

set_plot_standards

% Übergabe in die Datenstruktur für Plotten
%==========================================
d.time = out.t_brems_ges;

d.title     = in.name;
d.bot_title = in.file_name;
d.xlim_set  = in.plot_xlim_ges_set;
d.xmin      = in.plot_xmin_ges;
d.xmax      = in.plot_xmax_ges;

subplots = 0;

% Subplot Valti
if( out.valti_exist )

    subplots  = subplots + 1;
    
    d.valti     = in.valti(out.trig_start_index:out.trig_end_index,:);
    c.valti     = in.valti_color;
    delta_valti = 20;
end

% Subplot Phasen
if( out.phase_exist)
    
    subplots  = subplots + 1;        
    
    d.phase     = in.phase(out.trig_start_index:out.trig_end_index,:);
    c.phase     = in.phase_color;
    delta_phase = 10;
end
% Subplot Geschwindigkeit
if( out.v_ref_exist | out.v_rad_exist )
    
    subplots  = subplots + 1;
    
    if(  out.v_ref_exist )
        
        d.v_ref = in.v_ref(out.trig_start_index:out.trig_end_index);
        c.v_ref = in.v_ref_color;
    else
        d.v_ref = out.t_brems_ges*0;
        c.v_ref = PlotStandards.Mschwarz;
    end    
    if(  out.v_rad_exist )
        
        d.v_rad = in.v_rad(out.trig_start_index:out.trig_end_index,:);
        c.v_rad = in.v_rad_color;
    else
        d.v_rad = out.t_brems_ges*0;
        c.v_rad = {PlotStandards.Mrot,PlotStandards.Mgruen,PlotStandards.Mgelb,PlotStandards.Mblau};
    end    
    delta_v_rad = 20/3.6;
end
% Subplot Drücke
if( out.p_thz_exist | out.p_rad_exist | out.p_rad_req_exist )
    
    subplots  = subplots + 1;
    if(  out.p_thz_exist )
        
        d.p_thz = in.p_thz(out.trig_start_index:out.trig_end_index);
        c.p_thz = in.p_thz_color;
    else
        d.p_thz = out.t_brems_ges*0;
        c.p_thz = PlotStandards.Mschwarz;
    end    
    if( out.p_rad_exist )
        
        d.p_rad = in.p_rad(out.trig_start_index:out.trig_end_index,:);    
        c.p_rad = in.p_rad_color;
    else
        
        d.p_rad = [out.t_brems_ges,out.t_brems_ges,out.t_brems_ges,out.t_brems_ges]*0;
        c.p_rad = {PlotStandards.Mrot,PlotStandards.Mgruen,PlotStandards.Mgelb,PlotStandards.Mblau};
    end
    if( out.p_rad_req_exist )
        
        d.p_rad_req = in.p_rad_req(out.trig_start_index:out.trig_end_index,:);    
        c.p_rad_req = in.p_rad_req_color;
    else
        
        d.p_rad_req = [out.t_brems_ges,out.t_brems_ges,out.t_brems_ges,out.t_brems_ges]*0;
        c.p_rad_req = {PlotStandards.Mrot,PlotStandards.Mgruen,PlotStandards.Mgelb,PlotStandards.Mblau};
    end
    delta_p_rad = 20;
end

% Plot erstellen
%===============
if( subplots > 0 )
    
    set_plot_standards


    in.fig_num = in.fig_num+1;
    
    % Konfiguration der Plot-Figure
    s_fig.fig_num = in.fig_num ;
    s_fig.short_name_set     = 1;
    s_fig.short_name          = 'ABS_Ges';
    s_fig.dina4              = 1; 
    s_fig.rows               = subplots;
    s_fig.cols               = 1;
    
    % Subplot valti erstellen
    isub = 0;
    if( isfield(d,'valti') )

        isub = isub + 1;

        s_fig.s_plot(isub).bot_title_set      = 0;
        s_fig.s_plot(isub).bot_title{1}       = d.bot_title;
		s_fig.s_plot(isub).title_set          = 1;
		s_fig.s_plot(isub).title              = [d.title,' Gesamtzeit'];
		s_fig.s_plot(isub).x_label_set        = 0;
		s_fig.s_plot(isub).x_label            = ['Zeit [s]'];
		s_fig.s_plot(isub).y_label_set        = 1;
		s_fig.s_plot(isub).y_label            = ['valti [ms]'];
		s_fig.s_plot(isub).xlim_set           = d.xlim_set;
		s_fig.s_plot(isub).xmin               = d.xmin;
		s_fig.s_plot(isub).xmax               = d.xmax;
		s_fig.s_plot(isub).ylim_set           = 0;
		s_fig.s_plot(isub).ymin               = 0;
		s_fig.s_plot(isub).ymax               = 0;
		s_fig.s_plot(isub).legend_set         = 0;        
		s_fig.s_plot(isub).data_set           = 1;        
        
        c_text = {'fl','fr','rl','rr'};
        i_p = 0;
        for i=1:4
            i_p = i_p + 1;
		    s_data(i_p).x_vec         = d.time;
    		s_data(i_p).y_vec         = d.valti(:,i)+delta_valti*(4-i);
    		s_data(i_p).line_color    = c.valti{i};          % [a b c]  ([0 0 0])
            s_data(i_p).line_type     = PlotStandards.Ltype{1};
    		s_data(i_p).legend        = ['valti_',c_text{i}];
        end
        
        s_fig.s_plot(isub).s_data  = s_data;
        clear s_data
    end
        
    % Subplot phase erstellen
    if( isfield(d,'phase') )

        isub = isub + 1;

        s_fig.s_plot(isub).bot_title_set      = 0;
        s_fig.s_plot(isub).bot_title{1}       = d.bot_title;
		s_fig.s_plot(isub).title_set          = 1;
		s_fig.s_plot(isub).title              = [d.title,' Gesamtzeit'];
		s_fig.s_plot(isub).x_label_set        = 0;
		s_fig.s_plot(isub).x_label            = ['Zeit [s]'];
		s_fig.s_plot(isub).y_label_set        = 1;
		s_fig.s_plot(isub).y_label            = ['phase [-]'];
		s_fig.s_plot(isub).xlim_set           = d.xlim_set;
		s_fig.s_plot(isub).xmin               = d.xmin;
		s_fig.s_plot(isub).xmax               = d.xmax;
		s_fig.s_plot(isub).ylim_set           = 0;
		s_fig.s_plot(isub).ymin               = 0;
		s_fig.s_plot(isub).ymax               = 0;
		s_fig.s_plot(isub).legend_set         = 0;        
		s_fig.s_plot(isub).data_set           = 1;        
        
        c_text = {'fl','fr','rl','rr'};
        i_p = 0;
        for i=1:4
            i_p = i_p + 1;
		    s_data(i_p).x_vec         = d.time;
    		s_data(i_p).y_vec         = d.phase(:,i)+delta_phase*(4-i);
    		s_data(i_p).line_color    = c.phase{i};          % [a b c]  ([0 0 0])
            s_data(i_p).line_type     = PlotStandards.Ltype{1};
    		s_data(i_p).legend        = ['phase_',c_text{i}];
        end
        
        s_fig.s_plot(isub).s_data  = s_data;
        clear s_data
    end

    % Subplot Geschw erstellen
    if( isfield(d,'v_ref') )

        isub = isub + 1;

        s_fig.s_plot(isub).bot_title_set      = 0;
        s_fig.s_plot(isub).bot_title{1}       = d.bot_title;
		s_fig.s_plot(isub).title_set          = 1;
		s_fig.s_plot(isub).title              = [d.title,' Gesamtzeit'];
		s_fig.s_plot(isub).x_label_set        = 0;
		s_fig.s_plot(isub).x_label            = ['Zeit [s]'];
		s_fig.s_plot(isub).y_label_set        = 1;
		s_fig.s_plot(isub).y_label            = ['v [km/h]'];
		s_fig.s_plot(isub).xlim_set           = d.xlim_set;
		s_fig.s_plot(isub).xmin               = d.xmin;
		s_fig.s_plot(isub).xmax               = d.xmax;
		s_fig.s_plot(isub).ylim_set           = 0;
		s_fig.s_plot(isub).ymin               = 0;
		s_fig.s_plot(isub).ymax               = 0;
		s_fig.s_plot(isub).legend_set         = 0;        
		s_fig.s_plot(isub).data_set           = 1;        
        
        c_text = {'fl','fr','rl','rr'};
        i_p = 0;
        for i=1:4
            i_p = i_p + 1;
		    s_data(i_p).x_vec         = d.time;
    		s_data(i_p).y_vec         = (d.v_ref + delta_v_rad*(4-i))*3.6;
    		s_data(i_p).line_color    = c.v_ref;          % [a b c]  ([0 0 0])
            s_data(i_p).line_type     = PlotStandards.Ltype{1};
    		s_data(i_p).legend        = ['v_ref_',c_text{i}];
            i_p = i_p + 1;
		    s_data(i_p).x_vec         = d.time;
    		s_data(i_p).y_vec         = (d.v_rad(:,i)+delta_v_rad*(4-i))*3.6;
    		s_data(i_p).line_color    = c.v_rad{i};          % [a b c]  ([0 0 0])
            s_data(i_p).line_type     = PlotStandards.Ltype{1};
    		s_data(i_p).legend        = ['v_rad_',c_text{i}];
        end
        
        s_fig.s_plot(isub).s_data  = s_data;
        clear s_data
    end

    % Subplot Druck erstellen
    if( out.p_thz_exist | out.p_rad_exist )
        
        isub = isub + 1;
        
		s_fig.s_plot(isub).bot_title_set      = 0;
        s_fig.s_plot(isub).bot_title{1}       = d.bot_title;
		s_fig.s_plot(isub).title_set          = 1;
		s_fig.s_plot(isub).title              = [d.title,' hydraulische Drücke'];
		s_fig.s_plot(isub).x_label_set        = 1;
		s_fig.s_plot(isub).x_label            = ['Zeit [s]'];
		s_fig.s_plot(isub).y_label_set        = 1;
		s_fig.s_plot(isub).y_label            = ['p [bar]'];
		s_fig.s_plot(isub).xlim_set           = d.xlim_set;
		s_fig.s_plot(isub).xmin               = d.xmin;
		s_fig.s_plot(isub).xmax               = d.xmax;
		s_fig.s_plot(isub).ylim_set           = 0;
		s_fig.s_plot(isub).ymin               = 0;
		s_fig.s_plot(isub).ymax               = 0;
		s_fig.s_plot(isub).legend_set         = 0;        
		s_fig.s_plot(isub).data_set           = 1;        
        
        i_p = 0;
        c_text = {'fl','fr','rl','rr'};
        for i=1:4
            i_p = i_p + 1;
    		s_data(i_p).x_vec         = d.time;
		    s_data(i_p).y_vec         = d.p_rad_req(:,i)+delta_p_rad*(4-i);
    		s_data(i_p).line_color    = c.p_rad_req{i};          % [a b c]  ([0 0 0])
            s_data(i_p).line_type     = PlotStandards.Ltype{1};
    		s_data(i_p).legend        = ['p_rad_req',c_text{i}];
            i_p = i_p + 1;
    		s_data(i_p).x_vec         = d.time;
		    s_data(i_p).y_vec         = d.p_rad(:,i)+delta_p_rad*(4-i);
    		s_data(i_p).line_color    = c.p_rad{i};          % [a b c]  ([0 0 0])
            s_data(i_p).line_type     = PlotStandards.Ltype{1};
    		s_data(i_p).legend        = ['p_rad',c_text{i}];
        end
            
        
        s_fig.s_plot(isub).s_data  = s_data;
        clear s_data
    end
    

    % Plot asuführen
    plot_f(s_fig);

end