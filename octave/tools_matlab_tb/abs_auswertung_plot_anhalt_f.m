function [in,out] = abs_auswertung_plot_anhalt_f(in,out)


if( in.a_mess_exist )

    time   = in.time(out.trig_start_index:out.trig_end_index);
    time   = time - time(1);
        
    a_mess = in.a_mess(out.trig_start_index:out.trig_end_index)-out.a_mess_offset;
    v_mess = in.v_mess(out.trig_start_index:out.trig_end_index)-out.a_mess_offset;
    if( in.s_mess_exist )
        s_mess = in.s_mess(out.trig_start_index:out.trig_end_index);
        s_mess = s_mess - s_mess(1);
    end

    v_brems = a_mess*0.0+v_mess(1);
    s_brems = a_mess*0.0;
    for i=2:length(time)
    
        delta_t    = time(i) - time(i-1);
        v_brems(i) = v_brems(i-1) + (a_mess(i-1)+a_mess(i))*0.5*delta_t;
        s_brems(i) = s_brems(i-1) + (v_brems(i-1)+v_brems(i))*0.5*delta_t;
    end
    
    out.t_anhw = time;
    out.s_anhw = s_brems;
    out.a_anhw = a_mess;
    out.a_anhw_mit = a_mess*0+out.a_brems_ges_mit_a;
    if( out.p_rad_exist )
        out.p_rad_anhw = in.p_rad(out.trig_start_index:out.trig_end_index,:);
    end
    if( out.v_rad_exist )
        out.v_rad_anhw = in.v_rad(out.trig_start_index:out.trig_end_index,:);
    end
    a_mit  = time*0;
    t1 = max(out.t_brems_schw);
    for i=1:length(time)
        if( time(i) < t1 )
            a_mit(i) = out.a_brems_schw_mit_a;
        else
            a_mit(i) = out.a_brems_abs_mit_a;
        end
    end
    out.v_anhw = v_brems;
    out.v_anhw_mess = v_mess;
    
    in.fig_num = in.fig_num+1;
    p_figure(in.fig_num,1,'ABS_anh');
    
    subplot(3,1,1)
    plot(out.t_anhw,[out.a_anhw,out.a_anhw_mit,a_mit])
    title(ersetze_char(in.name,'_',' '))
    grid
    subplot(3,1,2)
    plot(out.t_anhw,[out.v_anhw*3.6,out.v_anhw_mess*3.6])
    grid
    subplot(3,1,3)
    if( in.s_mess_exist )
        plot(out.t_anhw,[out.s_anhw,s_mess])
    else
        plot(out.t_anhw,[out.s_anhw])
    end
    grid
end