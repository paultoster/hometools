function [in,out] = abs_auswertung_input_f(in)
%
% Input prüfen
%
%===========================================================================================
% Zeitvektor
%===========================================================================================
if( ~isfield(in,'time') )
    
    error('Zeitvektor time in input-Struktur existiert nicht')
else
    in.n = length(in.time);
end

%===========================================================================================
% gemessene Verzögerung
%===========================================================================================
if( isfield(in,'a_mess') )
    
    in.a_mess_exist = 1;
    % Filterzeitkonstante
    if( isfield(in,'a_mess_T_filt') )
        p_figure(0,0,'a_mess');
        plot(in.time,in.a_mess,'k-')
        xlabel('time')
        ylabel('a_mess')
        title(['a_mess gefiltert a_mess_T_filt =',num2str(in.a_mess_T_filt)])
        hold on
        in.a_mess = pt1_filter_zp(in.time,in.a_mess,in.a_mess_T_filt);
        plot(in.time,in.a_mess,'r-')
        hold off
    end
else
    in.a_mess_exist = 0;
end
out.a_mess_exist = in.a_mess_exist;

%===========================================================================================
% gemessene Geschwindigkeit
%===========================================================================================
if( isfield(in,'v_mess') )
    
    % Filterzeitkonstante
    if( isfield(in,'v_mess_T_filt') )
        p_figure(0,0,'v_mess');
        plot(in.time,in.v_mess,'k-')
        xlabel('time')
        ylabel('v_mess')
        title(['v_mess gefiltert v_mess_T_filt =',num2str(in.v_mess_T_filt)])
        hold on
        in.v_mess = pt1_filter_zp(in.time,in.v_mess,in.v_mess_T_filt);
        plot(in.time,in.v_mess,'r-')
        hold off
    end
else
    error('Geschwindigkeit v_mess in input-Struktur existiert nicht')
end

%===========================================================================================
% gemessene Weg
%===========================================================================================
if( isfield(in,'s_mess') )
    
    in.s_mess_exist = 1;
    % Filterzeitkonstante
    if( isfield(in,'s_mess_T_filt') )
        p_figure(0,0,'s_mess');
        plot(in.time,in.s_mess,'k-')
        xlabel('time')
        ylabel('s_mess')
        title(['s_mess gefiltert s_mess_T_filt =',num2str(in.s_mess_T_filt)])
        hold on
        in.s_mess = pt1_filter_zp(in.time,in.s_mess,in.s_mess_T_filt);
        plot(in.time,in.s_mess,'r-')
        hold off
    end
else
    in.s_mess_exist = 0;
end
out.s_mess_exist = in.s_mess_exist;

%===========================================================================================
% Pedalkraft
%===========================================================================================
if( isfield(in,'f_pedal') )
    
    in.f_pedal_exist = 1;
    % Filterzeitkonstante
    if( isfield(in,'f_pedal_T_filt') )
        p_figure(0,0,'f_pedal');
        plot(in.time,in.f_pedal,'k-')
        xlabel('time')
        ylabel('f_pedal')
        title(['f_pedal gefiltert f_pedal_T_filt =',num2str(in.f_pedal_T_filt)])
        hold on
        in.f_pedal = pt1_filter_zp(in.time,in.f_pedal,in.f_pedal_T_filt);
        plot(in.time,in.f_pedal,'r-')
        hold off
    end
else
    in.f_pedal_exist = 0;
end
out.f_pedal_exist = in.f_pedal_exist;

%===========================================================================================
% verzögerung aus Referenzgeschw.
%===========================================================================================
if( isfield(in,'a_ref') )
    
    in.a_ref_exist = 1;
    % Filterzeitkonstante
    if( isfield(in,'a_ref_T_filt') )
        p_figure(0,0,'a_ref');
        plot(in.time,in.a_ref,'k-')
        xlabel('time')
        ylabel('a_ref')
        title(['a_ref gefiltert a_ref_T_filt =',num2str(in.a_ref_T_filt)])
        hold on
        in.a_ref = pt1_filter_zp(in.time,in.a_ref,in.a_ref_T_filt);
        plot(in.time,in.a_ref,'r-')
        hold off
    end
else
    in.a_ref_exist = 0;
end
out.a_ref_exist = in.a_ref_exist;

%===========================================================================================
% Referenzgeschw.
%===========================================================================================
if( isfield(in,'v_ref') )
    
    in.v_ref_exist = 1;
    % Filterzeitkonstante
    if( isfield(in,'v_ref_T_filt') )
        p_figure(0,0,'v_ref');
        plot(in.time,in.v_ref,'k-')
        xlabel('time')
        ylabel('v_ref')
        title(['v_ref gefiltert v_ref_T_filt =',num2str(in.v_ref_T_filt)])
        hold on
        in.v_ref = pt1_filter_zp(in.time,in.v_ref,in.v_ref_T_filt);
        plot(in.time,in.v_ref,'r-')
        hold off
    end
else
    in.v_ref_exist = 0;
end
out.v_ref_exist = in.v_ref_exist;

%===========================================================================================
% Radgeschw.
%===========================================================================================
c_pos = {'fl','fr','rl','rr'};
if( isfield(in,'v_rad') )
    
    [m,n] = size(in.v_rad);
    
    if( n == 4 )
    
        in.v_rad_exist = 1;
        % Filterzeitkonstante
        if( isfield(in,'v_rad_T_filt') )
            for i=1:n
                p_figure(0,0,['v_rad',c_pos{i}]);
                plot(in.time,in.v_rad(:,i),'k-')
                xlabel('time')
                ylabel('v_rad')
                title(['v_rad gefiltert v_rad_T_filt =',num2str(in.v_rad_T_filt)])
                hold on
                in.v_rad(:,i) = pt1_filter_zp(in.time,in.v_rad(:,n),in.v_rad_T_filt);
                plot(in.time,in.v_rad(:,i),'r-')
                hold off
            end
        end
    else
        in.v_rad_exist = 0;
    end    
else
    in.v_rad_exist = 0;
end
out.v_rad_exist = in.v_rad_exist;

%===========================================================================================
% THZ-Druck
%===========================================================================================
if( isfield(in,'p_thz') )
    
    in.p_thz_exist = 1;
    % Filterzeitkonstante
    if( isfield(in,'p_thz_T_filt') )
        p_figure(0,0,'p_thz');
        plot(in.time,in.p_thz,'k-')
        xlabel('time')
        ylabel('p_thz')
        title(['p_thz gefiltert p_thz_T_filt =',num2str(in.p_thz_T_filt)])
        hold on
        in.p_thz = pt1_filter_zp(in.time,in.p_thz,in.p_thz_T_filt);
        plot(in.time,in.p_thz,'r-')
        hold off
    end
else
    in.p_thz_exist = 0;
end
out.p_thz_exist = in.p_thz_exist;

%===========================================================================================
% Raddrücke
%===========================================================================================
if( isfield(in,'p_rad') )
    
    [m,n] = size(in.p_rad);
    
    if( n == 4 )
    
        in.p_rad_exist = 1;
        % Filterzeitkonstante
        if( isfield(in,'p_rad_T_filt') )
            for i=1:n
                p_figure(0,0,['p_rad',c_pos{i}]);
                plot(in.time,in.p_rad(:,i),'k-')
                xlabel('time')
                ylabel('p_rad')
                title(['p_rad gefiltert p_rad_T_filt =',num2str(in.p_rad_T_filt)])
                hold on
                in.p_rad(:,i) = pt1_filter_zp(in.time,in.p_rad(:,n),in.p_rad_T_filt);
                plot(in.time,in.p_rad(:,i),'r-')
                hold off
            end
        end
    else
        in.p_rad_exist = 0;
    end    
else
    in.p_rad_exist = 0;
end
out.p_rad_exist = in.p_rad_exist;

%===========================================================================================
% Radsolldrücke
%===========================================================================================
if( isfield(in,'p_rad_req') )
    
    [m,n] = size(in.p_rad_req);
    
    if( n == 4 )
    
        in.p_rad_req_exist = 1;
        % Filterzeitkonstante
        if( isfield(in,'p_rad_req_T_filt') )
            for i=1:n
                p_figure(0,0,['p_rad_req',c_pos{i}]);
                plot(in.time,in.p_rad_req(:,i),'k-')
                xlabel('time')
                ylabel('p_rad_req')
                title(['p_rad_req gefiltert p_rad_req_T_filt =',num2str(in.p_rad_T_filt)])
                in.p_rad_req(:,i) = pt1_filter_zp(in.time,in.p_rad_req(:,n),in.p_rad_req_T_filt);
                plot(in.time,in.p_rad_req(:,i),'r-')
                hold off
            end
        end
    else
        in.p_rad_req_exist = 0;
    end    
else
    in.p_rad_req_exist = 0;
end
out.p_rad_req_exist = in.p_rad_req_exist;

%===========================================================================================
% Valtis
%===========================================================================================
if( isfield(in,'valti') )
    
    [m,n] = size(in.valti);
    
    if( n == 4 )
    
        in.valti_exist = 1;
    else
        in.valti_exist = 0;
    end    
else
    in.valti_exist = 0;
end
out.valti_exist = in.valti_exist;

%===========================================================================================
% Phasen
%===========================================================================================
if( isfield(in,'phase') )
    
    [m,n] = size(in.phase);
    
    if( n == 4 )
    
        in.phase_exist = 1;
        in.phase = floor(in.phase);
        
        % ABS in cycle
        for i=1:n
            in.abs_in_cycle(:,i) = bitget(in.phase(:,i),1); % bit0
            phase(:,i)           = bitget(in.phase(:,i),8)*0 ...
                                 + bitget(in.phase(:,i),7)*1 ...
                                 + bitget(in.phase(:,i),6)*2 ...
                                 + bitget(in.phase(:,i),5)*3 ...
                                 + bitget(in.phase(:,i),4)*4 ...
                                 + bitget(in.phase(:,i),3)*5 ...
                                 ;
        end
        in.phase = phase;
    else
        in.phase_exist = 0;
    end    
else
    in.phase_exist = 0;
end
out.phase_exist = in.phase_exist;
out.abs_in_cycle = in.abs_in_cycle;

%===========================================================================================
% Trigger Bremsbeginn
%===========================================================================================
if( ~isfield(in,'trig_start_sig') )
    error('Triggerwert trig_start_sig in input-Struktur existiert nicht')
end
if( ~isfield(in,'trig_start_thr') )
    error('Triggerwert trig_start_thr in input-Struktur existiert nicht')
end
if( ~isfield(in,'trig_start_rel') )
    error('Triggerwert trig_rel_rel in input-Struktur existiert nicht')
else
    switch(in.trig_start_rel)
        case {'==','~=','!=','>','>=','<','<='}
            okay =1;
        otherwise
            in.trig_start_rel
            error('Triggerwert trig_rel_rel ist nicht ==,~=,!=,>,>=,<,<=')
    end
end

if( isfield(in,'trig_start_T_filt') )
    p_figure(0,0,'trig_start_sig');
    plot(in.time,in.trig_start_sig,'k-')
    xlabel('time')
    ylabel('trig_start_sig')
    title(['trig_start_sig gefiltert trig_start_T_filt =',num2str(in.trig_start_T_filt)])
    hold on
    in.trig_start_sig = pt1_filter_zp(in.time,in.trig_start_sig,in.trig_start_T_filt);
    plot(in.time,in.trig_start_sig,'r-')
    hold off
end
index = suche_schwelle(in.trig_start_sig,in.trig_start_thr,in.trig_start_rel);

if( index == 0 )
    figure
    plot(in.time,[in.trig_start_sig,in.trig_start_sig*0+in.trig_start_thr])
    text(mean(mean(in.time)),mean(mean(in.trig_start_sig)),in.trig_start_rel)
    error('Bremsbeginn konnte nicht egtriggert werden')
else
    out.trig_start_index = index;
end
out.trig_start_time = in.time(index);

%===========================================================================================
% Trigger Bremsenende
%===========================================================================================
if( ~isfield(in,'trig_end_sig') )
    error('Triggerwert trig_end_sig in input-Struktur existiert nicht')
end
if( ~isfield(in,'trig_end_thr') )
    error('Triggerwert trig_end_thr in input-Struktur existiert nicht')
end
if( ~isfield(in,'trig_end_rel') )
    error('Triggerwert trig_rel_rel in input-Struktur existiert nicht')
else
    switch(in.trig_end_rel)
        case {'==','~=','!=','>','>=','<','<='}
            okay =1;
        otherwise
            in.trig_end_rel
            error('Triggerwert trig_rel_rel ist nicht ==,~=,!=,>,>=,<,<=')
    end
end

if( isfield(in,'trig_end_T_filt') )
    p_figure(0,0,'trig_end_sig');
    plot(in.time,in.trig_end_sig,'k-')
    xlabel('time')
    ylabel('trig_end_sig')
    title(['trig_end_sig gefiltert trig_end_T_filt =',num2str(in.trig_end_T_filt)])
    hold on
    in.trig_end_sig = pt1_filter_zp(in.time,in.trig_end_sig,in.trig_end_T_filt);
    plot(in.time,in.trig_end_sig,'r-')
    hold off
end

index = suche_schwelle(in.trig_end_sig,in.trig_end_thr,in.trig_end_rel);

if( index == 0 )
    figure
    plot(in.time,[in.trig_end_sig,in.trig_end_sig*0+in.trig_end_thr])
    text(mean(mean(in.time)),mean(mean(in.trig_end_sig)),in.trig_end_rel)
    error('Bremsbeginn konnte nicht egtriggert werden')
else
    out.trig_end_index = index;
end
out.trig_end_time = in.time(index);

%===========================================================================================
% Trigger ABS-Beginn
%===========================================================================================
if( in.phase_exist )
    
    index = 0;
    for i=1:in.n
        for j=1:2 % nur Vorderachse
            if( in.abs_in_cycle(i,j) )
                index = i;
                break
            end
        end
        if( index > 0 )
            break
        end
    end
elseif(in.valti_exist )
    
    index = 0;
    for i=1:in.n
        for j=1:2 % nur Vorderacshe
            if( in.valti(i,j) < 0.0 )
                index = i;
                break
            end
        end
        if( index > 0 )
            break
        end
    end
else
    
    error('Kein Signal vorhanden (phase,valti), um ABS-Regelung zu detektieren')
end
if( index == 0 )
    warning('Keine ABS-Regelung erkannt')
    out.trig_start_abs_index = in.trig_end_index;
else
    out.trig_start_abs_index = index;
end
out.trig_start_abs_time = in.time(out.trig_start_abs_index);
