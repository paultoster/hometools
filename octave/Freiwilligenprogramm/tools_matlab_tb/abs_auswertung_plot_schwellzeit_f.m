function [in,out] = abs_auswertung_plot_schwellzeit_f(in,out)

set_plot_standards
% Übergabe in die Datenstruktur für Plotten
%==========================================
d.time = out.t_brems_schw;

d.title     = in.name;
d.bot_title = in.file_name;
d.xlim_set  = in.plot_xlim_schw_set;
d.xmin      = in.plot_xmin_schw;
d.xmax      = in.plot_xmax_schw;

subplots = 0;

% Subplot Pedalkraft 
if( out.f_pedal_exist )
    
    d.f_pedal = in.f_pedal(out.trig_start_index:out.trig_start_abs_index);
    c.f_pedal = in.f_pedal_color;
    subplots  = subplots + 1;
end

% Subplot Drücke
if( out.p_thz_exist | out.p_rad_exist )
    
    subplots  = subplots + 1;
    if(  out.p_thz_exist )
        
        d.p_thz = in.p_thz(out.trig_start_index:out.trig_start_abs_index);
        c.p_thz = in.p_thz_color;
    else
        d.p_thz = out.t_brems_schw*0;
        c.p_thz = PlotStandards.Mschwarz;
    end    
    if( out.p_rad_exist )
        
        d.p_rad = in.p_rad(out.trig_start_index:out.trig_start_abs_index,:);    
        c.p_rad = in.p_rad_color;
    else
        
        d.p_rad = [out.t_brems_schw,out.t_brems_schw,out.t_brems_schw,out.t_brems_schw]*0;
        c.p_rad = {PlotStandards.Mrot,PlotStandards.Mgruen,PlotStandards.Mgelb,PlotStandards.Mblau};
    end
end
% Subplot Beschleunigung
if( out.a_mess_exist | out.a_ref_exist )
    
    subplots  = subplots + 1;
    if(  out.a_mess_exist )
        
        d.a_mess = in.a_mess(out.trig_start_index:out.trig_start_abs_index)-out.a_mess_offset;
        c.a_mess = in.a_mess_color;
    else
        d.a_mess = out.t_brems_schw*0;
        c.a_mess = PlotStandards.Mblau;
    end    
    if(  out.a_ref_exist )
        
        d.a_ref = in.a_ref(out.trig_start_index:out.trig_start_abs_index);
        c.a_ref = in.a_ref_color;
    else
        d.a_ref = out.t_brems_schw*0;
        c.a_ref = PlotStandards.Hblau;
    end    
end
% Subplot Geschwindigkeit
d.v_mess = in.v_mess(out.trig_start_index:out.trig_start_abs_index);
c.v_mess = in.v_mess_color;

subplots  = subplots + 1;
if(  out.v_ref_exist )
    
    d.v_ref = in.v_ref(out.trig_start_index:out.trig_start_abs_index);
    c.v_ref = in.v_ref_color;
else
    d.v_ref = out.t_brems_schw*0;
    c.v_ref = PlotStandards.Mschwarz;
end
if(  out.a_mess_exist )
    
    d.v_brems_a = out.v_brems_a(out.trig_start_index:out.trig_start_abs_index);
    c.v_brems_a = PlotStandards.Mrot;
else
    d.v_bremsa_a = out.t_brems_schw*0;
    c.v_brems_a = PlotStandards.Mschwarz;
end

% Plot erstellen
%===============
if( subplots > 0 )
    
    set_plot_standards


    in.fig_num = in.fig_num+1;
    
    % Konfiguration der Plot-Figure
    s_fig.fig_num = in.fig_num ;
    s_fig.short_name_set     = 1;
    s_fig.short_name          = 'ABS_Schw';
    s_fig.dina4              = 1; 
    s_fig.rows               = subplots;
    s_fig.cols               = 1;
    
    % Subplot Peadlkraft erstellen
    isub = 0;
    if( isfield(d,'f_pedal') )

        isub = isub + 1;

        s_fig.s_plot(isub).bot_title_set      = 0;
        s_fig.s_plot(isub).bot_title{1}       = d.bot_title;
		s_fig.s_plot(isub).title_set          = 1;
		s_fig.s_plot(isub).title              = [d.title,' Schwellzeit'];
		s_fig.s_plot(isub).x_label_set        = 0;
		s_fig.s_plot(isub).x_label            = ['Zeit [s]'];
		s_fig.s_plot(isub).y_label_set        = 1;
		s_fig.s_plot(isub).y_label            = ['Pedalkraft [N]'];
		s_fig.s_plot(isub).xlim_set           = d.xlim_set;
		s_fig.s_plot(isub).xmin               = d.xmin;
		s_fig.s_plot(isub).xmax               = d.xmax;
		s_fig.s_plot(isub).ylim_set           = 0;
		s_fig.s_plot(isub).ymin               = 0;
		s_fig.s_plot(isub).ymax               = 0;
		s_fig.s_plot(isub).legend_set         = 1;        
		s_fig.s_plot(isub).data_set           = 1;        
        
        i_p = 1;
		s_data(i_p).x_vec         = d.time;
		s_data(i_p).y_vec         = d.f_pedal;
		s_data(i_p).line_color    = c.f_pedal;          % [a b c]  ([0 0 0])
		s_data(i_p).legend        = ['f_pedal'];
        
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
		s_fig.s_plot(isub).x_label_set        = 0;
		s_fig.s_plot(isub).x_label            = ['Zeit [s]'];
		s_fig.s_plot(isub).y_label_set        = 1;
		s_fig.s_plot(isub).y_label            = ['p [bar]'];
		s_fig.s_plot(isub).xlim_set           = d.xlim_set;
		s_fig.s_plot(isub).xmin               = d.xmin;
		s_fig.s_plot(isub).xmax               = d.xmax;
		s_fig.s_plot(isub).ylim_set           = 0;
		s_fig.s_plot(isub).ymin               = 0;
		s_fig.s_plot(isub).ymax               = 0;
		s_fig.s_plot(isub).legend_set         = 1;        
		s_fig.s_plot(isub).data_set           = 1;        
        
        i_p = 1;
		s_data(i_p).x_vec         = d.time;
		s_data(i_p).y_vec         = d.p_thz;
		s_data(i_p).line_color    = c.p_thz;          % [a b c]  ([0 0 0])
        s_data(i_p).line_type     = PlotStandards.Ltype{1};
		s_data(i_p).legend        = ['p_thz'];
        
        c_text = {'fl','fr','rl','rr'};
        for i=1:4
            i_p = i_p + 1;
    		s_data(i_p).x_vec         = d.time;
		    s_data(i_p).y_vec         = d.p_rad(:,i);
    		s_data(i_p).line_color    = c.p_rad{i};          % [a b c]  ([0 0 0])
            s_data(i_p).line_type     = PlotStandards.Ltype{1};
    		s_data(i_p).legend        = ['p_rad',c_text{i}];
        end
            
        
        s_fig.s_plot(isub).s_data  = s_data;
        clear s_data
    end
    
    % Subplot Beschleunigung erstellen
    if( out.a_mess_exist | out.a_ref_exist )
    
        isub = isub + 1;

        s_fig.s_plot(isub).bot_title_set      = 0;
        s_fig.s_plot(isub).bot_title{1}       = d.bot_title;
		s_fig.s_plot(isub).title_set          = 1;
		s_fig.s_plot(isub).title              = [d.title,' Beschleunigung'];
		s_fig.s_plot(isub).x_label_set        = 0;
		s_fig.s_plot(isub).x_label            = ['Zeit [s]'];
		s_fig.s_plot(isub).y_label_set        = 1;
		s_fig.s_plot(isub).y_label            = ['a [m/s/s]'];
		s_fig.s_plot(isub).xlim_set           = d.xlim_set;
		s_fig.s_plot(isub).xmin               = d.xmin;
		s_fig.s_plot(isub).xmax               = d.xmax;
		s_fig.s_plot(isub).ylim_set           = 0;
		s_fig.s_plot(isub).ymin               = 0;
		s_fig.s_plot(isub).ymax               = 0;
		s_fig.s_plot(isub).legend_set         = 1;        
		s_fig.s_plot(isub).data_set           = 1;        
        
        i_p = 1;
		s_data(i_p).x_vec         = d.time;
		s_data(i_p).y_vec         = d.a_mess;
		s_data(i_p).line_color    = c.a_mess;          % [a b c]  ([0 0 0])
        s_data(i_p).line_type     = PlotStandards.Ltype{1};
		s_data(i_p).legend        = ['a_mess'];
        i_p = 2;
		s_data(i_p).x_vec         = d.time;
		s_data(i_p).y_vec         = d.a_ref;
		s_data(i_p).line_color    = c.a_ref;          % [a b c]  ([0 0 0])
        s_data(i_p).line_type     = PlotStandards.Ltype{1};
		s_data(i_p).legend        = ['a_ref'];
        
        s_fig.s_plot(isub).s_data  = s_data;
        clear s_data
    end

    % Subplot Geschwindigkeit erstellen
    isub = isub + 1;

    s_fig.s_plot(isub).bot_title_set      = 1;
    s_fig.s_plot(isub).bot_title{1}       = d.bot_title;
	s_fig.s_plot(isub).title_set          = 1;
	s_fig.s_plot(isub).title              = [d.title,' Geschwindigkeit'];
	s_fig.s_plot(isub).x_label_set        = 1;
	s_fig.s_plot(isub).x_label            = ['Zeit [s]'];
	s_fig.s_plot(isub).y_label_set        = 1;
	s_fig.s_plot(isub).y_label            = ['v [km/h]'];
	s_fig.s_plot(isub).xlim_set           = d.xlim_set;
	s_fig.s_plot(isub).xmin               = d.xmin;
	s_fig.s_plot(isub).xmax               = d.xmax;
	s_fig.s_plot(isub).ylim_set           = 0;
	s_fig.s_plot(isub).ymin               = 0;
	s_fig.s_plot(isub).ymax               = 0;
	s_fig.s_plot(isub).legend_set         = 1;        
	s_fig.s_plot(isub).data_set           = 1;        
    
    i_p = 1;
	s_data(i_p).x_vec         = d.time;
	s_data(i_p).y_vec         = d.v_mess*3.6;
	s_data(i_p).line_color    = c.v_mess;          % [a b c]  ([0 0 0])
    s_data(i_p).line_type     = PlotStandards.Ltype{1};
	s_data(i_p).legend        = ['v_mess'];
    i_p = 2;
	s_data(i_p).x_vec         = d.time;
	s_data(i_p).y_vec         = d.v_ref*3.6;
	s_data(i_p).line_color    = c.v_ref;          % [a b c]  ([0 0 0])
    s_data(i_p).line_type     = PlotStandards.Ltype{1};
	s_data(i_p).legend        = ['v_ref'];
    
    if( isfield(d,'v_brems_a') )
        
        i_p = i_p+1;
		s_data(i_p).x_vec         = d.time;
		s_data(i_p).y_vec         = d.v_brems_a*3.6;
		s_data(i_p).line_color    = c.v_brems_a;          % [a b c]  ([0 0 0])
        s_data(i_p).line_type     = PlotStandards.Ltype{1};
		s_data(i_p).legend        = ['v_brems_a'];
	end    
    
    s_fig.s_plot(isub).s_data  = s_data;
    clear s_data

    % Plot asuführen
    plot_f(s_fig);

end