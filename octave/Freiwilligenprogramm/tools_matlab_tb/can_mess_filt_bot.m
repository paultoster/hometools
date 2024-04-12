function cal = can_mess_filt_bot(cal,bot,filt)
%
% filt.zeit_durchlass        cell(double)    Liste mit Zeiten 
%                                            ungerade untere Schranke
%                                            gerade obere Schranke
% filt.sender_durchlass      cell{char}      Liste mit Botschaften eines Senders
% filt.bot_name_durchlass    cell{char}      Liste mit Botschaftsnamen

% Zeitfilter Durchlass
%===========================
if( isfield(filt,'zeit_durchlass') & ...
    strcmp(class(filt.zeit_durchlass),'cell') & ...
    length(filt.zeit_durchlass) > 0 )    % Filter mit Zeiten aktiv


    cal1  = struct([]);
    ncal1 = 0;
    nzd   = length(filt.zeit_durchlass);
    izd   = 1;
    uSchranke_flag = 1;
    end_flag = 0;
    for ical = 1:length(cal)
        
        if( end_flag )
            break;
        end
%         fprintf('i:%s zcal:%s zfilt:%s izd:%s\n',num2str(ical),num2str(cal(ical).zeit), ...
%                                                  num2str(filt.zeit_durchlass{izd}),num2str(izd));
        if( uSchranke_flag )
            if( cal(ical).zeit >= filt.zeit_durchlass{izd} )
            
                ncal1 = ncal1+1;
                if( ncal1 == 1 )
                    cal1 = cal(ical);
                else
                    cal1(ncal1) = cal(ical);
                end
                
                izd = izd + 1;
                uSchranke_flag = 0;
                if( izd > nzd )
                    end_flag = 1;
                end
            end
        else
            if( cal(ical).zeit <= filt.zeit_durchlass{izd} )
                
                ncal1 = ncal1+1;
                if( ncal1 == 1 )
                    cal1 = cal(ical);
                else
                    cal1(ncal1) = cal(ical);
                end
            else
                
                izd = izd + 1;
                uSchranke_flag = 1;
                if( izd > nzd )
                    end_flag = 1;
                end
            end
        end
    end             
    cal = cal1;
end

% Senderfilter Durchlass
%===========================
if( isfield(filt,'sender_durchlass') & ...
    strcmp(class(filt.sender_durchlass),'cell') & ...
    length(filt.sender_durchlass) > 0 )    % Filter mit ungenauen Sendernamen aktiv

    c_ident = {};
    
    for ibot=1:length(bot)
        
        copy_flag = 0;
        for i = 1:length(filt.sender_durchlass)
            if( length(strfind(bot(ibot).sender,filt.sender_durchlass{i})) > 0 )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            c_ident{length(c_ident)+1} = bot(ibot).ident;
        end
    end

    cal1  = struct([]);
    ncal1 = 0;
    for ical = 1:length(cal)
        
        copy_flag = 0;
        for i = 1:length(c_ident)
            if( cal(ical).ident == c_ident{i}  )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            
            ncal1 = ncal1+1;
            if( ncal1 == 1 )
                cal1 = cal(ical);
            else
                cal1(ncal1) = cal(ical);
            end
        end
    end
    
    cal = cal1;
end

% Botschaftsfilter Durchlass
%===========================
if( isfield(filt,'bot_name_durchlass') & ...
    strcmp(class(filt.bot_name_durchlass),'cell') & ...
    length(filt.bot_name_durchlass) > 0 )    % Filter mit ungenauen Namen aktiv

    c_ident = {};
    
    for ibot=1:length(bot)
        
        copy_flag = 0;
        for i = 1:length(filt.bot_name_durchlass)
            if( length(strfind(bot(ibot).name,filt.bot_name_durchlass{i})) > 0  | ...
                strcmp(lower(bot(ibot).identhex),lower(filt.bot_name_durchlass{i})) )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            c_ident{length(c_ident)+1} = bot(ibot).ident;
        end
    end

    cal1  = struct([]);
    ncal1 = 0;
    for ical = 1:length(cal)
        
        copy_flag = 0;
        for i = 1:length(c_ident)
            if( cal(ical).ident == c_ident{i}  )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            
            ncal1 = ncal1+1;
            if( ncal1 == 1 )
                cal1 = cal(ical);
            else
                cal1(ncal1) = cal(ical);
            end
        end
    end
    
    cal = cal1;
end



% Signalfilter Durchlass
%===========================
if( isfield(filt,'bot_signal_durchlass') & ...
    strcmp(class(filt.bot_signal_durchlass),'cell') & ...
    length(filt.bot_signal_durchlass) > 0 )    % Filter mit ungenauen Namen aktiv

    botf = struct([]);
    nbotf = 0;
    
    for icell=1:length(filt.bot_signal_durchlass)
        
        nbotf = nbotf+1;
        botf(nbotf).bname = filt.bot_signal_durchlass{icell}{1};
        
        botf(nbotf).sname = {};
        for i=2:length(filt.bot_signal_durchlass{icell})
            botf(nbotf).sname{i-1} = filt.bot_signal_durchlass{icell}{i};
        end
        botf(nbotf).ident = 0;
        botf(nbotf).snr   = {}; 
    end

    if( length(botf(nbotf).sname) > 0 )
            
        for ibot=1:length(bot)
        
            for i = 1:nbotf
                if( length(strfind(bot(ibot).name,botf(i).bname)) > 0  | ...
                    strcmp(lower(bot(ibot).identhex),lower(botf(i).bname)) )
                    
                    botf(i).ident = bot(ibot).ident;
                    
                    for isig=1:length(bot(ibot).sig)
                        
                        for j=1:length(botf(i).sname)
                        
                            if( length(strfind(bot(ibot).sig(isig).name,botf(i).sname{j})) > 0 )
                            
                                botf(i).snr{length(botf(i).snr)+1} = bot(ibot).sig(isig).nr;
                            end
                        end
                    end
                        
                end
            end
        end

        for ical = 1:length(cal)

            for i=1:nbotf

                if( cal(ical).ident == botf(i).ident )

                    nsig1 = 0;
                    for isig=1:length(cal(ical).sig)

                        for j=1:length(botf(i).snr)

                            if( cal(ical).sig(isig).nr == botf(i).snr{j} )

                                nsig1 = nsig1+1;
                                if( nsig1 == 1 )
                                    sig1 = cal(ical).sig(isig);
                                else
                                    sig1(nsig1) = cal(ical).sig(isig);
                                end
                            end
                        end
                    end
                    cal(ical).sig = sig1;
                end
            end
        end
    end
end

% Empfangsfilter Durchlass
%===========================
if( isfield(filt,'empfang_durchlass') & ...
    strcmp(class(filt.empfang_durchlass),'cell') & ...
    length(filt.empfang_durchlass) > 0 )    % Filter mit ungenauen Namen aktiv

    clear cal1
    ical1 = 0;
    for ical = 1:length(cal)
        
        if( strcmp(cal(ical).name,'mLW_1') )
            fprintf('stop\n');
        end

    
        index = [];
        for isig = 1:length(cal(ical).sig)
            
           
            
            for iemp = 1:length( cal(ical).sig(isig).empfang)
            
                for ie = 1:length(filt.empfang_durchlass)
        
                    if( strcmp(filt.empfang_durchlass{ie},cal(ical).sig(isig).empfang{iemp}) )
                        index = [index,isig];
                        break;
                    end
                end
            end
        end
        
        if( length(index) > 0 ) % Botschaft kopieren
        
            ical1 = ical1 + 1;
            cal1(ical1) = cal(ical);
            
            clear sig1
            isig1 = 0;
            for i = 1:length(index)
    
                for isig = 1:length(cal(ical).sig)
    
                    if( isig == index(i) )
                        
                        isig1 = isig1 + 1;
                        sig1(isig1) = cal(ical).sig(isig);
                        break;
                    end
                end
            end
            cal1(ical1).sig = sig1;
        end
    end
    
    cal = cal1;
end