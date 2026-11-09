function [in,out] = abs_auswertung_ausgabe_f(in,out)

out.ausgabe_file_name = ['abs_auswertung_',in.name,'.dat'];

fid = fopen(out.ausgabe_file_name,'w');
strich_zeile = '------------------------------------------------------------------------------------------';
strich_gleich = '==========================================================================================';


ausgabe1_f(fid,'');
ausgabe1_f(fid,strich_gleich);

ausgabe2_f(fid,'Messung',in.name);
ausgabe2_f(fid,'File',in.file_name);
ausgabe1_f(fid,strich_gleich);

ausgabe3_f(fid,'trig_start_time','s',num2str(out.trig_start_time));
ausgabe3_f(fid,'trig_start_abs_time','s',num2str(out.trig_start_abs_time));
ausgabe3_f(fid,'trig_end_time','s',num2str(out.trig_end_time));
ausgabe3_f(fid,'t_brems_schw','s',num2str(max(out.t_brems_schw)));
ausgabe3_f(fid,'t_brems_ges','s',num2str(max(out.t_brems_ges)));
ausgabe1_f(fid,strich_gleich);

if( out.f_pedal_exist )
    ausgabe3_f(fid,'f_pedal_max','N',num2str(out.f_pedal_max));
    ausgabe3_f(fid,'f_pedal_start_abs','N',num2str(out.f_pedal_start_abs));
    ausgabe3_f(fid,'out_f_pedal_grad_schw_mit','N/s',num2str(out.f_pedal_grad_mit));
    ausgabe1_f(fid,strich_gleich);
end

if( out.p_rad_exist )
    c_text={'fl','fr','rl','rr'};
    for i=1:4
        ausgabe3_f(fid,['p_rad_max_',c_text{i}],'bar',num2str(out.p_rad_max(i)));
    end
    ausgabe1_f(fid,strich_zeile);

    for i=1:4
        ausgabe3_f(fid,['p_rad_start_abs_',c_text{i}],'bar',num2str(out.p_rad_start_abs(i)));
    end
    ausgabe1_f(fid,strich_zeile);
    
    for i=1:4
        ausgabe3_f(fid,['p_rad_grad_schw_mit_',c_text{i}],'bar/s',num2str(out.p_rad_grad_mit(i)));
    end
    ausgabe1_f(fid,strich_gleich);
end


ausgabe3_f(fid,'v_brems_start','km/h',num2str(out.v_brems_start*3.6));
ausgabe1_f(fid,strich_zeile);
ausgabe3_f(fid,'v_brems_schw_end_v','km/h',num2str(out.v_brems_schw_end_v*3.6));
ausgabe3_f(fid,'v_brems_ges_end_v','km/h',num2str(out.v_brems_ges_end_v*3.6));
ausgabe1_f(fid,strich_zeile);

ausgabe1_f(fid,'Bremsweg aus Geschwindigkeitssmessung');
ausgabe3_f(fid,'s_brems_schw_v','m',num2str(out.s_brems_schw_v));
ausgabe3_f(fid,'s_brems_ges_v','m',num2str(out.s_brems_ges_v));
ausgabe3_f(fid,'s_brems_schw_100_v','m',num2str(out.s_brems_schw_100_v));
ausgabe3_f(fid,'s_brems_ges_100_v','m',num2str(out.s_brems_ges_100_v));
ausgabe1_f(fid,strich_zeile);

ausgabe3_f(fid,'a_brems_schw_mit_v','m/s/s',num2str(out.a_brems_schw_mit_v));
ausgabe3_f(fid,'a_brems_abs_mit_v','m/s/s',num2str(out.a_brems_abs_mit_v));
ausgabe3_f(fid,'a_brems_ges_mit_v','m/s/s',num2str(out.a_brems_ges_mit_v));
ausgabe1_f(fid,strich_gleich);

if( in.a_mess_exist )

    ausgabe3_f(fid,'a_mess_offset','m/s/s',num2str(out.a_mess_offset));
	ausgabe1_f(fid,strich_zeile);
    ausgabe3_f(fid,'v_brems_schw_end_a','km/h',num2str(out.v_brems_schw_end_a*3.6));
    ausgabe3_f(fid,'v_brems_ges_end_a','km/h',num2str(out.v_brems_ges_end_a*3.6));
	ausgabe1_f(fid,strich_zeile);
	ausgabe1_f(fid,'Bremsweg aus Beschleunigungsmessung');
    ausgabe3_f(fid,'s_brems_schw_a','m',num2str(out.s_brems_schw_a));
	ausgabe3_f(fid,'s_brems_ges_a','m',num2str(out.s_brems_ges_a));
	ausgabe3_f(fid,'s_brems_schw_100_a','m',num2str(out.s_brems_schw_100_a));
	ausgabe3_f(fid,'s_brems_ges_100_a','m',num2str(out.s_brems_ges_100_a));
	ausgabe1_f(fid,strich_zeile);
	
	ausgabe3_f(fid,'a_brems_schw_mit_a','m/s/s',num2str(out.a_brems_schw_mit_a));
	ausgabe3_f(fid,'a_brems_abs_mit_a','m/s/s',num2str(out.a_brems_abs_mit_a));
	ausgabe3_f(fid,'a_brems_ges_mit_a','m/s/s',num2str(out.a_brems_ges_mit_a));
	ausgabe1_f(fid,strich_gleich);
    
end

if( in.s_mess_exist )

	ausgabe1_f(fid,'aus Bremswegmessung');
    ausgabe3_f(fid,'s_brems_schw_s','m',num2str(out.s_brems_schw_s));
	ausgabe3_f(fid,'s_brems_abs_s','m',num2str(out.s_brems_ges_s-out.s_brems_schw_s));
	ausgabe3_f(fid,'s_brems_ges_s','m',num2str(out.s_brems_ges_s));
	ausgabe3_f(fid,'s_brems_schw_100_s','m',num2str(out.s_brems_schw_100_s));
	ausgabe3_f(fid,'s_brems_abs_100_s','m',num2str(out.s_brems_ges_100_s-out.s_brems_schw_100_s));
	ausgabe3_f(fid,'s_brems_ges_100_s','m',num2str(out.s_brems_ges_100_s));
	ausgabe1_f(fid,strich_zeile);
	
	ausgabe3_f(fid,'a_brems_schw_mit_s','m/s/s',num2str(out.a_brems_schw_mit_s));
	ausgabe3_f(fid,'a_brems_abs_mit_s','m/s/s',num2str(out.a_brems_abs_mit_s));
	ausgabe3_f(fid,'a_brems_ges_mit_s','m/s/s',num2str(out.a_brems_ges_mit_s));
	ausgabe1_f(fid,strich_gleich);
	
    
end

fclose(fid);


function ausgabe1_f(fid,text1)
fprintf(fid,'%s\n',text1);
fprintf('%s\n',text1);
function ausgabe2_f(fid,text1,text2)
fprintf(fid,'%43s : %s\n',text1,text2);
fprintf('%43s : %s\n',text1,text2);
function ausgabe3_f(fid,text1,text2,text3)
fprintf(fid,'%30s [%10s] : %s\n',text1,text2,text3);
fprintf('%30s [%10s] : %s\n',text1,text2,text3);

