function dbc = can_mess_filt_dbc(dbc,filt)
%
% filt.sender_durchlass      cell{char}      Liste mit Botschaften eines Senders
% filt.bot_name_durchlass    cell{char}      Liste mit Botschaftsnamen
%                                            Botschaftsbname oder Identifier
% filt.bot_signal_durchlass  cell(char)      Liste mit Signalname
% filt.empfang_durchlass     cell(char)      Liste mit Empfängerdurchlass

% Senderfilter Durchlass
%===========================
if( isfield(filt,'sender_durchlass') & ...
    strcmp(class(filt.sender_durchlass),'cell') & ...
    length(filt.sender_durchlass) > 0 )    % Filter mit ungenauen Sendernamen aktiv

    c_ident = {};
    
    for idbc=1:length(dbc)
        
        copy_flag = 0;
        for i = 1:length(filt.sender_durchlass)
            if( length(strfind(dbc(idbc).sender,filt.sender_durchlass{i})) > 0 )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            c_ident{length(c_ident)+1} = dbc(idbc).ident;
        end
    end

    dbc1  = struct([]);
    ndbc1 = 0;
    for idbc = 1:length(dbc)
        
        copy_flag = 0;
        for i = 1:length(c_ident)
            if( dbc(idbc).ident == c_ident{i}  )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            
            ndbc1 = ndbc1+1;
            if( ndbc1 == 1 )
                dbc1 = dbc(idbc);
            else
                dbc1(ndbc1) = dbc(idbc);
            end
        end
    end
    
    dbc = dbc1;
end

% Botschaftsfilter Durchlass
%===========================
if( isfield(filt,'bot_name_durchlass') & ...
    strcmp(class(filt.bot_name_durchlass),'cell') & ...
    length(filt.bot_name_durchlass) > 0 )    % Filter mit ungenauen Namen aktiv

    c_ident = {};
    
    for idbc=1:length(dbc)
        
        copy_flag = 0;
        for i = 1:length(filt.bot_name_durchlass)
            if( length(strfind(dbc(idbc).name,filt.bot_name_durchlass{i})) > 0  | ...
                strcmp(lower(dbc(idbc).identhex),lower(filt.bot_name_durchlass{i})) )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            c_ident{length(c_ident)+1} = dbc(idbc).ident;
        end
    end

    dbc1  = struct([]);
    ndbc1 = 0;
    for idbc = 1:length(dbc)
        
        copy_flag = 0;
        for i = 1:length(c_ident)
            if( dbc(idbc).ident == c_ident{i}  )
                copy_flag = 1;
                break;
            end
        end
        if( copy_flag )
            
            ndbc1 = ndbc1+1;
            if( ndbc1 == 1 )
                dbc1 = dbc(idbc);
            else
                dbc1(ndbc1) = dbc(idbc);
            end
        end
    end
    
    dbc = dbc1;
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
            
        for idbc=1:length(dbc)
        
            for i = 1:nbotf
                if( length(strfind(dbc(idbc).name,botf(i).bname)) > 0  | ...
                    strcmp(lower(dbc(idbc).identhex),lower(botf(i).bname)) )
                    
                    botf(i).ident = dbc(idbc).ident;
                    
                    for isig=1:length(dbc(idbc).sig)
                        
                        for j=1:length(dbcf(i).sname)
                        
                            if( length(strfind(dbc(idbc).sig(isig).name,botf(i).sname{j})) > 0 )
                            
                                botf(i).snr{length(botf(i).snr)+1} = dbc(idbc).sig(isig).nr;
                            end
                        end
                    end
                        
                end
            end
        end

        for idbc = 1:length(dbc)

            for i=1:nbotf

                if( dbc(idbc).ident == botf(i).ident )

                    nsig1 = 0;
                    for isig=1:length(dbc(idbc).sig)

                        for j=1:length(botf(i).snr)

                            if( dbc(idbc).sig(isig).nr == botf(i).snr{j} )

                                nsig1 = nsig1+1;
                                if( nsig1 == 1 )
                                    sig1 = dbc(idbc).sig(isig);
                                else
                                    sig1(nsig1) = dbc(idbc).sig(isig);
                                end
                            end
                        end
                    end
                    dbc(idbc).sig = sig1;
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

    clear dbc1
    idbc1 = 0;
    for idbc = 1:length(dbc)
        
    
        index = [];
        for isig = 1:length(dbc(idbc).sig)
            
           
            flag = 0;
            for iemp = 1:length( dbc(idbc).sig(isig).empfang)
            
                for ie = 1:length(filt.empfang_durchlass)
        
                    if( strcmp(filt.empfang_durchlass{ie},dbc(idbc).sig(isig).empfang{iemp}) )
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
        
            idbc1 = idbc1 + 1;
            dbc1(idbc1) = dbc(idbc);
            
            clear sig1
            isig1 = 0;
            for i = 1:length(index)
    
                for isig = 1:length(dbc(idbc).sig)
    
                    if( isig == index(i) )
                        
                        isig1 = isig1 + 1;
                        sig1(isig1) = dbc(idbc).sig(isig);
                        break;
                    end
                end
            end
            dbc1(idbc1).sig = sig1;
        end
    end
    
    dbc = dbc1;
end