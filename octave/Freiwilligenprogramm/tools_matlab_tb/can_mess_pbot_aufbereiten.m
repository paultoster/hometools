function pbot = can_mess_pbot_aufbereiten(cal,dbc)
% cal   struct Input mit aufbereiteten CAN-Messungen
%
% pbot(i).name
%        .comment
%        .ident
%        .identhex
%        .sender
%        .time              double vector mit Zeit
%        .sig(j).name
%               .comment    char            Kommentar
%               .einheit
%               .nr
%               .mtyp       char    '':normale,'Z':Zaehler,'Mi':Multiplexsignal mit Zaehler
%               .startbit
%               .bitlength
%               .empfang    cell
%               .faktor          double  Faktor
%               .offset          double  Offset
%               .minval             double  Minimum
%               .maxval             double  Maximum
%               .vec        double   Signal
%               .s_val(i)         struct  Stuktur mit Wert und Bezeichnung
%              
%                s_val(k).val    double  Wert
%                        .comment  char   Bezeichnung
%
%

pbot  = struct([]);
npbot = 0;
for ical=1:length(cal)

    % Botschaft raussuchen
    found_flag = 0;
    for ipbot=1:npbot
        if( strcmp(pbot(ipbot).name,cal(ical).name) )
            found_flag = 1;
            break;
        end
    end
    if( ~found_flag ) %neue Botschaft

        npbot = npbot+1;
        ipbot = npbot;
        pbot(npbot).name     = cal(ical).name;
        pbot(npbot).comment  = cal(ical).comment;
        pbot(npbot).ident    = cal(ical).ident;
        pbot(npbot).identhex = cal(ical).identhex;
        pbot(npbot).sender   = cal(ical).sender;
        pbot(npbot).time     = [];
        
        % Botschaft aus dbc suchen
        for idbc = 1:length(dbc)
            if( dbc(idbc).ident == pbot(npbot).ident )

                break;
            end
        end
        
        for isig=1:length(cal(ical).sig)
            pbot(npbot).sig(isig).name      = cal(ical).sig(isig).name;
            pbot(ipbot).sig(isig).comment   = cal(ical).sig(isig).comment;
            pbot(npbot).sig(isig).einheit   = cal(ical).sig(isig).einheit;
            pbot(npbot).sig(isig).nr        = cal(ical).sig(isig).nr;
            pbot(npbot).sig(isig).mtyp      = cal(ical).sig(isig).mtyp;
            pbot(npbot).sig(isig).startbit  = cal(ical).sig(isig).startbit;
            pbot(npbot).sig(isig).bitlength = cal(ical).sig(isig).bitlength;
            pbot(npbot).sig(isig).empfang   = cal(ical).sig(isig).empfang;
            pbot(npbot).sig(isig).vec       = [];
            
            for i=1:length(dbc(idbc).sig)
                
                if( pbot(npbot).sig(isig).nr == dbc(idbc).sig(i).nr )
                    
                    pbot(npbot).sig(isig).s_val     = dbc(idbc).sig(i).s_val;
                    pbot(npbot).sig(isig).faktor    = dbc(idbc).sig(i).faktor;
                    pbot(npbot).sig(isig).offset    = dbc(idbc).sig(i).offset;
                    pbot(npbot).sig(isig).minval    = dbc(idbc).sig(i).minval;
                    pbot(npbot).sig(isig).maxval    = dbc(idbc).sig(i).maxval;
                    break;
                end
            end
        end
    end
    
    % Zeitevktor
    pbot(ipbot).time = [pbot(ipbot).time;cal(ical).zeit];
    
    %Signale
    for isig=1:length(cal(ical).sig)
        pbot(ipbot).sig(isig).vec   = [pbot(ipbot).sig(isig).vec;cal(ical).sig(isig).val];
    end
end
pbot = can_mess_pbot_sort(pbot);
pbot = can_mess_pbot_multiplex(pbot);
%==========================================================================
%==========================================================================
function pbot = can_mess_pbot_sort(pbot)

    sort_flag = 1;
    icount = 0;
    pbot0 = pbot;
    while sort_flag & icount < 100000
        icount = icount+1;
        sort_flag = 0;
        for ipbot=1:length(pbot0)-1
        
            if( pbot0(ipbot).ident > pbot0(ipbot+1).ident ) %tauschen
    
                sort_flag = 1;
                pbot_d = pbot0(ipbot);
                pbot0(ipbot) = pbot0(ipbot+1);
                pbot0(ipbot+1) = pbot_d;
            end
        end
    end

    pbot = pbot0;

function pbot = can_mess_pbot_multiplex(pbot)    

for ipbot=1:length(pbot)
    
    for isig=1:length(pbot(ipbot).sig)
        
        if( strcmp(pbot(ipbot).sig(isig).mtyp,'M') ) % Multiplexsignal
            
            if( strcmp(pbot(ipbot).sig(isig).name,'KO3_Derivat') )
                m_status = 1;
            end
            
            m_status = 1;
            i        = 0;
            index    = 1;
            while( m_status > 0 & i < length(pbot(ipbot).sig(isig).vec) )
            
                i = i + 1;
                
                switch(m_status)
                    case 1
                        
                        if( pbot(ipbot).sig(isig).vec(i) == -1 )
                            
                            m_status = 2;
                        else
                            m_status = 0;
                        end
                    case 2
                        
                        if( pbot(ipbot).sig(isig).vec(i) ~= -1 )
                            
                            %m_status = 2;
                        %else
                            m_status = 0;
                            index = i;
                        end
                end
            end
            
            for i=1:index-1
                
                pbot(ipbot).sig(isig).vec(i) = pbot(ipbot).sig(isig).vec(index);
            end
        end
    end
end
                        
          