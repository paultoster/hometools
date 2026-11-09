function pbot = can_mess_filt_pbot(pbot,filt)
%
% filt.zeit_durchlass        cell(double)    Liste mit Zeiten 
%                                            ungerade untere Schranke
%                                            gerade obere Schranke
% filt.sender_durchlass      cell{char}      Liste mit Botschaften eines Senders
% filt.bot_name_durchlass    cell{char}      Liste mit Botschaftsnamen

% Zeitfilter Durchlass
%===========================
if( isfield(filt,'zeit_durchlass') & ...
    strcmp(class(filt.zeit_durchlass),'double') & ...
    length(filt.zeit_durchlass) > 0 )    % Filter mit Zeiten aktiv


    c_liste = {};
    
    for ipbot = 1:length(pbot)
        
        for izd = 1:2:length(filt.zeit_durchlass)-1
            
            tstart = filt.zeit_durchlass(izd);
            tend   = filt.zeit_durchlass(izd+1);
            
            status = 0;
            for it = 1:length(pbot(ipbot).time)
                
                if( status == 0 )
                    
                    if( pbot(ipbot).time(it) >= tstart )
                        
                        index_start = it;
                        index_end   = length(pbot(ipbot).time);
                        if( it < length(pbot(ipbot).time) )
                            status = 1;
                        else
                            status = 2;
                        end
                    end
                elseif( status == 1 )
                    
                    if( pbot(ipbot).time(it) > tend )
                        
                        index_end = it;
                        status = 2;
                    end
                end
                if( status == 2 )
                    n = length(c_liste);
                    if( n == 0 )
                            c_liste{1} = [index_start,index_end];
                    else
                
                       if( index_start >= c_liste{n-1}(2) )
                    
                            c_liste{n+1} = [index_start,index_end];
                       end
                    end

                    break
                end
            end
        end
        
        
        while( length(c_liste) > 0 )
            
            if( length(c_liste) == 1 )
                
                i0 = c_liste{1}(1);
                i1 = c_liste{1}(2);
            else
                i0 = c_liste{1}(1);
                i1 = length(pbot(ipbot).time);
            end
            
            % Zeit
            pbot(ipbot).time = pbot(ipbot).time(i0:i1);
            % Signale
            for isig = 1:length(pbot(ipbot).sig)
                
                pbot(ipbot).sig(isig).vec    = pbot(ipbot).sig(isig).vec(i0:i1);
                pbot(ipbot).sig(isig).vecdec = pbot(ipbot).sig(isig).vecdec(i0:i1);
            end
            
            for ic = 2:length(c_liste)
                
                c_liste{ic}(1) = c_liste{ic}(1) - c_liste{1}(2);
                c_liste{ic}(2) = c_liste{ic}(2) - c_liste{1}(2);
            end
            if( length(c_liste) > 1 )
                c_liste = c_liste{2:length(c_liste)};
            else
                c_liste = {};
            end
        end
    end
end

% Senderfilter Durchlass
%===========================
if( isfield(filt,'sender_durchlass') & ...
    strcmp(class(filt.sender_durchlass),'cell') & ...
    length(filt.sender_durchlass) > 0 )    % Filter mit ungenauen Sendernamen aktiv

    c_ident = {};
    
    for ipbot=1:length(pbot)
        
        copy_flag = 0;
        for i = 1:length(filt.sender_durchlass)
            if( length(strfind(pbot(ipbot).sender,filt.sender_durchlass{i})) > 0 )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            c_ident{length(c_ident)+1} = pbot(ipbot).ident;
        end
    end

    pbot1  = struct([]);
    npbot1 = 0;
    for ipbot = 1:length(pbot)
        
        copy_flag = 0;
        for i = 1:length(c_ident)
            if( pbot(ipbot).ident == c_ident{i}  )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            
            npbot1 = npbot1+1;
            if( npbot1 == 1 )
                pbot1 = pbot(ipbot);
            else
                pbot1(npbot1) = pbot(ipbot);
            end
        end
    end
    
    pbot = pbot1;
end

% Botschaftsfilter Durchlass
%===========================
if( isfield(filt,'bot_name_durchlass') & ...
    strcmp(class(filt.bot_name_durchlass),'cell') & ...
    length(filt.bot_name_durchlass) > 0 )    % Filter mit ungenauen Namen aktiv

    c_ident = {};
    
    for ipbot=1:length(pbot)
        
        copy_flag = 0;
        for i = 1:length(filt.bot_name_durchlass)
            if( length(strfind(pbot(ipbot).name,filt.bot_name_durchlass{i})) > 0  | ...
                strcmp(lower(pbot(ipbot).identhex),lower(filt.bot_name_durchlass{i})) )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            c_ident{length(c_ident)+1} = pbot(ipbot).ident;
        end
    end

    pbot1  = struct([]);
    npbot1 = 0;
    for ipbot = 1:length(pbot)
        
        copy_flag = 0;
        for i = 1:length(c_ident)
            if( pbot(ipbot).ident == c_ident{i}  )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            
            npbot1 = npbot1+1;
            if( npbot1 == 1 )
                pbot1 = pbot(ipbot);
            else
                pbot1(npbot1) = pbot(ipbot);
            end
        end
    end
    
    pbot = pbot1;
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
            
        pbot1  = struct([]);
        npbot1 = 0;
        for ipbot=1:length(pbot)
            
            copy_flag = 0;
        
            for i = 1:nbotf
                if( length(strfind(pbot(ipbot).name,botf(i).bname)) > 0  | ...
                    strcmp(lower(pbot(ipbot).identhex),lower(botf(i).bname)) )
                    
                    copy_flag = 1;
                    
                    botf(i).ident = pbot(ipbot).ident;
                    
                    for isig=1:length(pbot(ipbot).sig)
                        
                        for j=1:length(botf(i).sname)
                        
                            if( length(strfind(pbot(ipbot).sig(isig).name,botf(i).sname{j})) > 0 )
                                
                                botf(i).snr{length(botf(i).snr)+1} = pbot(ipbot).sig(isig).nr;
                            end
                        end
                    end
                        
                end
            end
            if( copy_flag )
            
                npbot1 = npbot1+1;
                if( npbot1 == 1 )
                    pbot1 = pbot(ipbot);
                else
                    pbot1(npbot1) = pbot(ipbot);
                end
            end
        end
       
        pbot = pbot1;
        
        if( length(pbot) > 0 )
            for ipbot = 1:length(pbot)

                for i=1:nbotf

                    if( pbot(ipbot).ident == botf(i).ident )

                        nsig1 = 0;
                        for isig=1:length(pbot(ipbot).sig)

                            for j=1:length(botf(i).snr)

                                if( pbot(ipbot).sig(isig).nr == botf(i).snr{j} )

                                    nsig1 = nsig1+1;
                                    if( nsig1 == 1 )
                                        sig1 = pbot(ipbot).sig(isig);
                                    else
                                        sig1(nsig1) = pbot(ipbot).sig(isig);
                                    end
                                end
                            end
                        end
                        pbot(ipbot).sig = sig1;
                    end
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

    clear pbot1
    ipbot1 = 0;
    for ipbot = 1:length(pbot)
        
    
        index = [];
        for isig = 1:length(pbot(ipbot).sig)
            
           
            flag = 0;
            for iemp = 1:length( pbot(ipbot).sig(isig).empfang)
            
                for ie = 1:length(filt.empfang_durchlass)
        
                    if( strcmp(filt.empfang_durchlass{ie},pbot(ipbot).sig(isig).empfang{iemp}) )
                        index = [index,isig];
                        flag = 1;
                        break;
                    end
                end
                if( flag )
                    break;
                end
            end
        end
        
        if( length(index) > 0 ) % Botschaft kopieren
        
            ipbot1 = ipbot1 + 1;
            pbot1(ipbot1) = pbot(ipbot);
            
            clear sig1
            isig1 = 0;
            for i = 1:length(index)
    
                for isig = 1:length(pbot(ipbot).sig)
    
                    if( isig == index(i) )
                        
                        isig1 = isig1 + 1;
                        sig1(isig1) = pbot(ipbot).sig(isig);
                        break;
                    end
                end
            end
            pbot1(ipbot1).sig = sig1;
        end
    end
    
    pbot = pbot1;
end