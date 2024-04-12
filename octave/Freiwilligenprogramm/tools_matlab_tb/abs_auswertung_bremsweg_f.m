function [in,out] = abs_auswertung_bremsweg_f(in,out);

out.kor_fak_100kmh        = (100/3.6/in.v_mess(out.trig_start_index))^2; 

% Pedalkraftasuwertung
%=====================================
if( in.f_pedal_exist )

    time    = in.time(out.trig_start_index:out.trig_start_abs_index);
    time    = time - time(1);    
    f_pedal = in.f_pedal(out.trig_start_index:out.trig_start_abs_index);

    out.f_pedal_max       = max(in.f_pedal);
    out.f_pedal_start_abs = f_pedal(length(f_pedal));
    out.f_pedal_grad_mit  = mean(diff(f_pedal)./diff(time));
end

% Raddruckauswertung
%=====================================
if( in.p_rad_exist )

    time    = in.time(out.trig_start_index:out.trig_start_abs_index);
    time    = time - time(1);    
    p_rad   = in.p_rad(out.trig_start_index:out.trig_start_abs_index,:);

    
    for i=1:4
        out.p_rad_max(i)       = max(in.p_rad(:,i));
        out.p_rad_start_abs(i) = p_rad(length(time),i);
        out.p_rad_grad_mit(i)   = mean(diff(p_rad(:,i))./diff(time));
    end
end

% Bremswege aus gemessener Geschwindigkeit
%=========================================
time   = in.time(out.trig_start_index:out.trig_end_index);
time   = time - time(1);    
v_mess = in.v_mess(out.trig_start_index:out.trig_end_index);


s_brems = v_mess*0.0;
for i=2:length(time)
    
    s_brems(i) = s_brems(i-1) + (v_mess(i-1)+v_mess(i))*0.5*(time(i) - time(i-1));
end

out.t_brems_ges  = time;
out.t_brems_schw = time(1:(out.trig_start_abs_index-out.trig_start_index+1));

out.v_brems_start      = v_mess(1);
out.v_brems_ges_end_v  = v_mess(out.trig_end_index-out.trig_start_index+1);
out.v_brems_schw_end_v = v_mess(out.trig_start_abs_index-out.trig_start_index+1);

out.s_brems_ges_v  = s_brems(out.trig_end_index-out.trig_start_index+1);
out.s_brems_schw_v = s_brems(out.trig_start_abs_index-out.trig_start_index+1);

out.s_brems_ges_100_v     = out.s_brems_ges_v * out.kor_fak_100kmh;
out.s_brems_schw_100_v    = out.s_brems_schw_v * out.kor_fak_100kmh;

out.a_brems_ges_mit_v     = - 0.5 * out.v_brems_start^2 / out.s_brems_ges_v;
out.a_brems_schw_mit_v     = - 0.5 * (out.v_brems_start-out.v_brems_schw_end_v) ...
                                   * (out.v_brems_start+out.v_brems_schw_end_v) ...
                                   / out.s_brems_schw_v;
out.a_brems_abs_mit_v     = - 0.5 * (out.v_brems_schw_end_v-out.v_brems_ges_end_v) ...
                                   * (out.v_brems_schw_end_v+out.v_brems_ges_end_v) ...
                                   / (out.s_brems_ges_v - out.s_brems_schw_v);

% out.a_brems_schw_mit_v     = mean( diff( v_mess(1:out.trig_start_abs_index)) ...
%                                    ./                                        ...
%                                    diff(time(1:out.trig_start_abs_index))    ...
%                                  );


% Bremsweg aus Verzögerung
%=======================================================
if( in.a_mess_exist  )
        
    time   = in.time(out.trig_start_index:out.trig_end_index);    
    time   = time - time(1);    
    n      = length(time);

    v_mess = in.v_mess(out.trig_start_index:out.trig_end_index);
    a_mess = in.a_mess(out.trig_start_index:out.trig_end_index);
    
    % Korrektur Verzögerung aus Geschwindigkeitsverlauf
    %--------------------------------------------------
    v_brems = a_mess*0.0+v_mess(1);
    for i=2:n
    
        delta_t    = time(i) - time(i-1);
        v_brems(i) = v_brems(i-1) + (a_mess(i-1)+a_mess(i))*0.5*delta_t;
    end
    
    a_offset = v_brems(n)/time(n);
    
    a_mess = in.a_mess(out.trig_start_index:out.trig_end_index)-a_offset;

%     it = 0;
%     kor_flag = 1;
%     it_max   = 500;
%     
%     while( it < it_max & kor_flag > 0 )
%         it = it+1;
% 
%     
%         kor_flag = 0;
%         v_brems = a_mess*0.0+v_mess(1);
%         for i=2:length(time)
%     
%             delta_t    = time(i) - time(i-1);
%             v_brems(i) = v_brems(i-1) + (a_mess(i-1)+a_mess(i))*0.5*delta_t;
%         end
%         
%         if(abs(v_brems(n)) > 0.5/3.6 )
%             
%             kor_flag = 1;
%             
%             a_offset = a_offset + v_brems(n)/time(n);
%             fprintf('vbrems   : %g\n',v_brems(n)*3.6);
%             fprintf('a_offset : %g\n',a_offset);
%         end
%         a_mess = in.a_mess(out.trig_start_index:out.trig_end_index)-a_offset;
%     end
%     if( it == it_max )
%         
%         warning('abs_auswwertung_bremsweg_f: Offsetbestimmung Iteration gleich it_max = %i',it_max)
%     end

    
    out.a_mess_offset = a_offset;
    
    v_brems = a_mess*0.0+v_mess(1);
    s_brems = a_mess*0.0;
    for i=2:n
    
        delta_t    = time(i) - time(i-1);
        v_brems(i) = v_brems(i-1) + (a_mess(i-1)+a_mess(i))*0.5*delta_t;
        s_brems(i) = s_brems(i-1) + (v_brems(i-1)+v_brems(i))*0.5*delta_t;
    end
    
    out.v_brems_a      = [in.v_mess(1:out.trig_start_index-1);v_brems];
    if( length(in.time) > out.trig_end_index )
        out.v_brems_a  = [out.v_brems_a;in.time(out.trig_end_index+1:length(in.time))];
    end
    out.s_brems_ges_a  = s_brems(out.trig_end_index-out.trig_start_index+1);
    out.s_brems_schw_a = s_brems(out.trig_start_abs_index-out.trig_start_index+1);

    out.s_brems_ges_100_a     = out.s_brems_ges_a * out.kor_fak_100kmh;
    out.s_brems_schw_100_a    = out.s_brems_schw_a * out.kor_fak_100kmh;

    out.a_brems_ges_mit_a     = mean(a_mess);
    out.a_brems_schw_mit_a    = mean(a_mess(1:out.trig_start_abs_index-out.trig_start_index+1));
    out.a_brems_abs_mit_a     = mean(a_mess(out.trig_start_abs_index-out.trig_start_index+1:out.trig_end_index-out.trig_start_index+1));

    out.v_brems_schw_end_a    = v_brems(out.trig_start_abs_index-out.trig_start_index+1);
    out.v_brems_ges_end_a     = v_brems(n);
else    

    out.s_brems_ges_a  = v_mess*0;
    out.s_brems_schw_a = v_mess(1:(out.trig_start_abs_index-out.trig_start_index+1))*0;


    out.s_brems_ges_100_a     = v_mess * 0;;
    out.s_brems_schw_100_a    = v_mess(1:(out.trig_start_abs_index-out.trig_start_index+1))*0;

    out.a_brems_ges_mit_a     = 0;
    out.a_brems_schw_mit_a     = 0;
    out.a_brems_abs_mit_a     = 0;
    
end
    
    
% Bremsweg aus Wegmessung
%=======================================================
if( in.s_mess_exist  )
        
    s_mess   = in.s_mess(out.trig_start_index:out.trig_end_index);    
    s_mess   = s_mess - s_mess(1);    
    n      = length(s_mess);
    n_schw = out.trig_start_abs_index-out.trig_start_index+1;

    out.s_brems_ges_s  = s_mess(n);
    out.s_brems_schw_s = s_mess(n_schw);
    out.s_brems_abs_s = out.s_brems_ges_s - out.s_brems_schw_s;
    
    out.a_brems_schw_mit_s = (out.v_brems_start+out.v_brems_schw_end_v)*(-out.v_brems_start+out.v_brems_schw_end_v) ...
                           / 2.0 / out.s_brems_schw_s;
    out.a_brems_abs_mit_s = (out.v_brems_schw_end_v+out.v_brems_ges_end_v)*(-out.v_brems_schw_end_v+out.v_brems_ges_end_v) ...
                           / 2.0 / out.s_brems_abs_s;
    out.a_brems_ges_mit_s = (out.v_brems_start+out.v_brems_ges_end_v)*(-out.v_brems_start+out.v_brems_ges_end_v) ...
                           / 2.0 / out.s_brems_ges_s;
    

    out.s_brems_ges_100_s     = out.s_brems_ges_s * out.kor_fak_100kmh;
    out.s_brems_schw_100_s    = out.s_brems_schw_s * out.kor_fak_100kmh;
    out.s_brems_abs_100_s    = out.s_brems_abs_s * out.kor_fak_100kmh;
else
    out.s_brems_ges_s  = 0;
    out.s_brems_schw_s = 0;
    out.s_brems_abs_s = 0;

    out.s_brems_ges_100_s     = 0;
    out.s_brems_schw_100_s    = 0;
    out.s_brems_abs_100_s    = 0;
end    