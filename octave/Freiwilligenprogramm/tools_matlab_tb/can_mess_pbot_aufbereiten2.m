function pbot = can_mess_pbot_aufbereiten2(mess,dbc)
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
%               .typ        double   -2 -> Signal (normal)
%                                    -1 -> Multiplexsignal (also Zähler)
%                                  i>=0 -> gemultiplexte Signal und
%                                          Zählerwert
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
npbot   = 0;
% Anzahl der Botschaften listen
%==============================
ident_liste = can_mess_pbot_aufbereiten2_bot_liste(mess);

pbot  = struct([]);


for id=1:length(ident_liste)
    
    ident   = ident_liste(id);
    zaehler = -1;
    
    found_flag = 0;
    % Botschaft aus dbc suchen
    %=========================
    for idbc = 1:length(dbc)
        if( dbc(idbc).ident == ident )
            found_flag = 1;
            break;
        end
    end
    
    % pbot(i) anlegen
    %================
    npbot = npbot+1;
    
    if( found_flag )
        
        pbot(npbot).name     = dbc(idbc).name;
        pbot(npbot).comment  = dbc(idbc).comment;
        pbot(npbot).ident    = dbc(idbc).ident;
        pbot(npbot).identhex = dbc(idbc).identhex;
        pbot(npbot).sender   = dbc(idbc).sender;
        pbot(npbot).indexmz  = dbc(idbc).indexmz;
        pbot(npbot).dlc      = dbc(idbc).dlc;
        pbot(npbot).time     = [];
        
        for isig=1:length(dbc(idbc).sig)
            
            pbot(npbot).sig(isig).name = dbc(idbc).sig(isig).name;
            pbot(npbot).sig(isig).comment = dbc(idbc).sig(isig).comment;
            pbot(npbot).sig(isig).nr = dbc(idbc).sig(isig).nr;
            pbot(npbot).sig(isig).empfang = dbc(idbc).sig(isig).empfang;
            pbot(npbot).sig(isig).typ     = dbc(idbc).sig(isig).typ;    
            
            if( dbc(idbc).sig(isig).typ >= 0 )
                pbot(npbot).sig(isig).mtyp = sprintf('M%s',num2str(dbc(idbc).sig(isig).typ));
                
            elseif( dbc(idbc).sig(isig).typ == -1 )
                pbot(npbot).sig(isig).mtyp = 'Z';
            else
                pbot(npbot).sig(isig).mtyp = ' ';
            end

            pbot(npbot).sig(isig).startbit  = dbc(idbc).sig(isig).startbit;
            pbot(npbot).sig(isig).bitlength = dbc(idbc).sig(isig).bitlength;    
            pbot(npbot).sig(isig).byteorder = dbc(idbc).sig(isig).byteorder;    
            pbot(npbot).sig(isig).wertetyp  = dbc(idbc).sig(isig).wertetyp;    
            pbot(npbot).sig(isig).faktor    = dbc(idbc).sig(isig).faktor;    
            pbot(npbot).sig(isig).offset    = dbc(idbc).sig(isig).offset;    
            pbot(npbot).sig(isig).minval    = dbc(idbc).sig(isig).minval;    
            pbot(npbot).sig(isig).maxval    = dbc(idbc).sig(isig).maxval;  
            pbot(npbot).sig(isig).einheit   = dbc(idbc).sig(isig).einheit;    
            pbot(npbot).sig(isig).s_val     = dbc(idbc).sig(isig).s_val;
            pbot(npbot).sig(isig).vec       = [];
            pbot(npbot).sig(isig).vecdec    = [];
        end
    else
        
        pbot(npbot).name     = dec2hex(ident);
        pbot(npbot).comment  = 'nicht in dbc gefunden';
        pbot(npbot).ident    = ident;
        pbot(npbot).identhex = dec2hex(ident);
        pbot(npbot).sender   = 'no_name';
        pbot(npbot).indexmz  = -1;
        for imess=1:length(mess)
            if( mess(imess).ident == ident )
                dlc = mess(imess).dlc;
                break
            end
        end
        pbot(npbot).dlc      = dlc;
        pbot(npbot).time     = [];
        
        for isig = 1:dlc
        
            pbot(npbot).sig(isig).name      = num2str(isig);
            pbot(npbot).sig(isig).comment   = '';
            pbot(npbot).sig(isig).nr        = isig;
            pbot(npbot).sig(isig).empfang       = {};  
            pbot(npbot).sig(isig).typ       = -2;
            pbot(npbot).sig(isig).mtyp      = ' ';
            pbot(npbot).sig(isig).startbit  = (isig-1)*8;
            pbot(npbot).sig(isig).bitlength = 8;    
            pbot(npbot).sig(isig).byteorder     = 1;    
            pbot(npbot).sig(isig).wertetyp      = 0;    
            pbot(npbot).sig(isig).faktor        = 1;    
            pbot(npbot).sig(isig).offset        = 0;    
            pbot(npbot).sig(isig).minval        = 0;    
            pbot(npbot).sig(isig).maxval        = 255;    
            pbot(npbot).sig(isig).einheit       = '';    
            pbot(npbot).sig(isig).s_val         = {};   
            pbot(npbot).sig(isig).vec       = [];
            pbot(npbot).sig(isig).vecdec    = [];

        end
    end
end

for imess = 1:length(mess)
    
    for ipbot=1:length(pbot)
        
        % richtige Botschaft raussuchen
        %==============================
        if( mess(imess).ident == pbot(ipbot).ident )
            
            
            pbot(ipbot).time = [pbot(ipbot).time;mess(imess).zeit];
            
            for isig=1:length(pbot(ipbot).sig)
                
                % Rohwert
                valdec = can_mess_pbot_aufbereiten2_to_dec(mess(imess).val,mess(imess).dlc, ...
                                                           pbot(ipbot).sig(isig).startbit, ...
                                                           pbot(ipbot).sig(isig).bitlength, ...
                                                           pbot(ipbot).sig(isig).byteorder, ...
                                                           pbot(ipbot).sig(isig).wertetyp, ...
                                                           pbot(ipbot).name, ...
                                                           pbot(ipbot).sig(isig).name ...
                                                          );
               
                val = valdec*pbot(ipbot).sig(isig).faktor+pbot(ipbot).sig(isig).offset; 
                
                pbot(ipbot).sig(isig).vecdec = [pbot(ipbot).sig(isig).vecdec;valdec];
                pbot(ipbot).sig(isig).vec    = [pbot(ipbot).sig(isig).vec;val];
                
                
                % Zaehlerwert merken
                %===================
                if( isig == pbot(ipbot).indexmz ) 
                    izaehler = valdec;
                end
                
                
            end
            
            % Multiplexsignale aufbereiten
            %=============================
            for isig=1:length(pbot(ipbot).sig)
                
                % Multiplexsignal
                %================
                if( pbot(ipbot).sig(isig).typ >= 0 )
                    
                    if( strcmp(pbot(ipbot).name,'mGetriebe_2') & ...
                        strcmp(pbot(ipbot).sig(isig).name,'GE2_Tip7Gang') )
                    
                        i123 = isig;
                    end
                
                    % Abfrage, ob Signal nicht gesetzt wird
                    %======================================
                    if( izaehler ~= pbot(ipbot).sig(isig).typ )
                        
                        l0 = length(pbot(ipbot).sig(isig).vec);
                        if( l0 > 1 )
                            % alter Wert
                            %===========
                            pbot(ipbot).sig(isig).vec(l0)    = pbot(ipbot).sig(isig).vec(l0-1);
                            pbot(ipbot).sig(isig).vecdec(l0) = pbot(ipbot).sig(isig).vecdec(l0-1);
                        else
                            pbot(ipbot).sig(isig).vec(l0)    = -1;
                            pbot(ipbot).sig(isig).vecdec(l0) = -1;
                        end
                    end
                end
            end
        end
    end
end
%pbot = can_mess_pbot_aufbereiten2_sort(pbot);
pbot = can_mess_pbot_aufbereiten2_multiplex(pbot);
%==========================================================================
%==========================================================================                        
function ident_liste = can_mess_pbot_aufbereiten2_bot_liste(mess)

    ident_liste = [];

    for imess=1:length(mess)

         found_flag = 0;
         for id = 1:length(ident_liste)

             if( mess(imess).ident == ident_liste(id) )
                 found_flag = 1;
                 break
             end
         end
         if( ~found_flag )
             
             if( mess(imess).ident == 16 )
                 
                 m=mess(imess);
             end

             ident_liste = [ident_liste,mess(imess).ident];
         end
    end
    
    ident_liste = sort(ident_liste);

function val = can_mess_pbot_aufbereiten2_to_dec(bytes,dlc,startbit,bitlength,byteorder,wertetyp,bot_name,sig_name)

% if( strcmp(bot_name,'mTP_Er_Tester') && strcmp(sig_name,'Tester_TP_Er') )
%     val = 0;
% end
val = 0;
if( bitlength > 8 )
    val = 0;
end
endbit = startbit+bitlength-1;

istart = floor(startbit/8)+1;
iend   = floor(endbit/8)+1;

if( iend > dlc | istart > dlc )
    
%     text = sprintf('can_mess_calc: Aus Botschaft <%s> Signal <%s> ist gemessenes dlc=%i zu klein \nfür Signal (startbit=%i,bitlength=%i)', ...
%                    bot_name,sig_name,dlc,startbit,bitlength);
%     warning(text);
    val = 0;
else    

    startbit_istart = startbit - (istart-1)*8;
    endbit_iend     = endbit - (istart-1)*8;

    bb= '';
    if( byteorder == 1 | istart == iend ) % Intel bzw. alles in einem bytes von daher egal
    
        % Die entsprechenden bytes in bits wandeln
        for i=istart:iend
    
            b = dec2bin(bytes(i));
    
            while length(b) < 8
                b = ['0',b];
            end
    
            bb = [b,bb];
        end
    
        % Den Ausschnitt der bits bestimmen
        bb = bb(length(bb)-endbit_iend:length(bb)-startbit_istart);
    
        if( wertetyp == 1 ) %signed
            val = binbin2dec(bb,bitlength);
        else %unsigned
            val = binbin2dec(bb,bitlength);
        end
    
        
    else % Motorola
        
        sig.startbit  = startbit;
        sig.bitlength = bitlength;
        sig.byteorder = byteorder;
        
        [lsb,msb] = can_calc_lsbmsb(sig)
        
        text = sprintf('can_mess_calc: Aus Botschaft <%s> Signal <%s> ist mit byteorder Motorola angegeben. Bisher noch nicht programmiert', ...
                       bot_name,sig_name);
        error(text);
    end    

end
function pbot = can_mess_pbot_aufbereiten2_sort(pbot)

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

function pbot = can_mess_pbot_aufbereiten2_multiplex(pbot)    

for ipbot=1:length(pbot)
    
    for isig=1:length(pbot(ipbot).sig)
        
        if( pbot(ipbot).sig(isig).typ >= 0 ) % Multiplexsignal
                        
            m_status = 1;
            i        = 0;
            index    = 1;
            while( m_status > 0 & i < length(pbot(ipbot).sig(isig).vec) )
            
                i = i + 1;
                
                switch(m_status)
                    case 1
                        
                        if( pbot(ipbot).sig(isig).vecdec(i) == -1 )
                            
                            m_status = 2;
                        else
                            m_status = 0;
                        end
                    case 2
                        
                        if( pbot(ipbot).sig(isig).vecdec(i) ~= -1 )
                            
                            %m_status = 2;
                        %else
                            m_status = 0;
                            index = i;
                        end
                end
            end
            
            for i=1:index-1
                
                pbot(ipbot).sig(isig).vec(i)    = pbot(ipbot).sig(isig).vec(index);
                pbot(ipbot).sig(isig).vecdec(i) = pbot(ipbot).sig(isig).vecdec(index);
            end
        end
    end
end
