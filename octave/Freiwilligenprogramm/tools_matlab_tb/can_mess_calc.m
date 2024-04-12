function cal = can_mess_calc(mes,dbc)
%
% cal(i).tline          char            Orginalbotschat
%       .zeit           double          Zeit
%       .ident          double          Identifier
%       .identhex       char            Identifier Hex
%       .name           char            Botschaftsname Name
%       .comment        char            Kommentar
%       .sender         char            Wer sendet
%       .valhex{j}      cell{char}      Werte in hex
%       .dlc            double          Anzahl bytes (Werte)
%       .nsig           double          Anzahl erkannter Signale
%       .sig(j).name    char            Signalname
%              .comment char            Kommentar
%              .nr      double          Nummer
%              .startbit double         Starbit
%              .bitlength double        Länge
%              .valdec  double          Rohwert
%              .val     double          skalierter Wert
%              .einheit char            Einheit
%              .valcom  char            kommentierter Wert
%              .mtyp       char         '':normale,'Z':Zaehler,'Mi':Multiplexsignal mit Zaehler
%             

cal  = struct([]);
ncal = 0;

nmes = length(mes);
nbot = length(dbc);

for imes = 1:nmes
    
    ncal = ncal+1;
    
    % Orginal inhalt
    cal(ncal).tline = mes(imes).tline;
    % zeit
    cal(ncal).zeit = mes(imes).zeit;
    % Identifier
    cal(ncal).ident = mes(imes).ident;
    cal(ncal).identhex = mes(imes).identhex;
 
    % bytes
    cal(ncal).valhex = mes(imes).valhex;
    % dlc
    cal(ncal).dlc    = mes(imes).dlc;
    
    % Botschaftsname, Sender
    cal(ncal).name   = '';
    cal(ncal).sender = '';
    ibotindex = 0;
    for ibot=1:nbot
        
        if( dbc(ibot).ident == cal(ncal).ident )
            
            cal(ncal).name = dbc(ibot).name;
            cal(ncal).comment = dbc(ibot).comment;
            cal(ncal).sender = dbc(ibot).sender;
            ibotindex = ibot;
            break;
        end
    end
    cal(ncal).sig  = struct([]);
    
    if( ibotindex > 0 ) % Signal auswerten
        
        for isig=1:length(dbc(ibotindex).sig)
                       
            
            % Name
            cal(ncal).sig(isig).name = dbc(ibotindex).sig(isig).name;
%             if( strcmp(cal(ncal).sig(isig).name,'MFN_Zaehler') )
%                     valdec = 0;
%             end
            % Kommentar
            cal(ncal).sig(isig).comment = dbc(ibotindex).sig(isig).comment;
            
            % Nummer
            cal(ncal).sig(isig).nr = dbc(ibotindex).sig(isig).nr;
            
            % Empfaenger
            cal(ncal).sig(isig).empfang = dbc(ibotindex).sig(isig).empfang;
            
            % Standardwert oder Multiplexzähler
            if( dbc(ibotindex).sig(isig).typ < 0 ) % Standard oder Multiplexzaehler
                %typ
                if( dbc(ibotindex).sig(isig).typ == -1 )
                    cal(ncal).sig(isig).mtyp = 'Z'; 
                else
                    cal(ncal).sig(isig).mtyp = ' ';
                end
                % Rohwert
                valdec = mexCalcCanByte(mes(imes).dlc ...
                                       ,mes(imes).val ...
                                       ,dbc(ibotindex).sig(isig).startbit ...
                                       ,dbc(ibotindex).sig(isig).bitlength ...
                                       ,dbc(ibotindex).sig(isig).wertetyp ...
                                       ,dbc(ibotindex).sig(isig).byteorder);
%                 valdec = can_mess_calc_to_dec(mes(imes).val,mes(imes).dlc, ...
%                                             dbc(ibotindex).sig(isig).startbit, ...
%                                             dbc(ibotindex).sig(isig).bitlength, ...
%                                             dbc(ibotindex).sig(isig).byteorder, ...
%                                             dbc(ibotindex).sig(isig).wertetyp, ...
%                                             dbc(ibotindex).name, ...
%                                             dbc(ibotindex).sig(isig).name ...
%                                             );
                                      
                cal(ncal).sig(isig).valdec = valdec;

                % skalierter Wert
                val = valdec*dbc(ibotindex).sig(isig).faktor+dbc(ibotindex).sig(isig).offset;
                cal(ncal).sig(isig).val = val;
                                
                % Wertetabelle
                cal(ncal).sig(isig).valcom = '';
                if(length(dbc(ibotindex).sig(isig).s_val) > 0 )

                    for ival=1:length(dbc(ibotindex).sig(isig).s_val)

                        if( dbc(ibotindex).sig(isig).s_val(ival).val == val )

                            cal(ncal).sig(isig).valcom = dbc(ibotindex).sig(isig).s_val(ival).comment;
                            break;
                        end
                    end
                end
            end
            cal(ncal).sig(isig).startbit = dbc(ibotindex).sig(isig).startbit;
            cal(ncal).sig(isig).bitlength = dbc(ibotindex).sig(isig).bitlength;
            
            % EInheit
            cal(ncal).sig(isig).einheit = dbc(ibotindex).sig(isig).einheit;
            
                                      
        end
        
        % Multiplexsignal bearbeiten
        for isig=1:length(dbc(ibotindex).sig)
            
            if( dbc(ibotindex).sig(isig).typ >= 0 ) % Multiplexsignal
                
                %typ
                cal(ncal).sig(isig).mtyp = sprintf('M%s',num2str(dbc(ibotindex).sig(isig).typ));
                
%                 if( strcmp(cal(ncal).sig(isig).name,'MFN_Interv_Wmin') )
%                     valdec = 0;
%                 end
                
                % Signal wird jetzt gesetzt
                if( cal(ncal).sig(dbc(ibotindex).indexmz).valdec == dbc(ibotindex).sig(isig).typ )
                    
                    % Rohwert
                valdec = mexCalcCanByte(mes(imes).dlc ...
                                       ,mes(imes).val ...
                                       ,dbc(ibotindex).sig(isig).startbit ...
                                       ,dbc(ibotindex).sig(isig).bitlength ...
                                       ,dbc(ibotindex).sig(isig).wertetyp ...
                                       ,dbc(ibotindex).sig(isig).byteorder);
%                     valdec = can_mess_calc_to_dec(mes(imes).val,mes(imes).dlc, ...
%                                                 dbc(ibotindex).sig(isig).startbit, ...
%                                                 dbc(ibotindex).sig(isig).bitlength, ...
%                                                 dbc(ibotindex).sig(isig).byteorder, ...
%                                                 dbc(ibotindex).sig(isig).wertetyp, ...
%                                                 dbc(ibotindex).name, ...
%                                                 dbc(ibotindex).sig(isig).name ...
%                                                 );

                    cal(ncal).sig(isig).valdec = valdec;

                    % skalierter Wert
                    val = valdec*dbc(ibotindex).sig(isig).faktor+dbc(ibotindex).sig(isig).offset;
                    cal(ncal).sig(isig).val = val;

                    % Wertetabelle
                    cal(ncal).sig(isig).valcom = '';
                    if(length(dbc(ibotindex).sig(isig).s_val) > 0 )

                        for ival=1:length(dbc(ibotindex).sig(isig).s_val)

                            if( dbc(ibotindex).sig(isig).s_val(ival).val == val )

                                cal(ncal).sig(isig).valcom = dbc(ibotindex).sig(isig).s_val(ival).comment;
                                break;
                            end
                        end
                    end
                else % gemultiplextes Signal wird nicht gesetzt, d.h. alter Wert übernehmen
                    
                    found_flag = 0;
                    for ical=ncal-1:-1:1 % zurückgehen und Botschaft suchen
                        
                        if( strcmp(cal(ncal).name,cal(ical).name) ) % Botschaft gefunden
                            
                            found_flag = 1;
                            cal(ncal).sig(isig).valdec = cal(ical).sig(isig).valdec;
                            cal(ncal).sig(isig).val    = cal(ical).sig(isig).val;
                            cal(ncal).sig(isig).valcom = cal(ical).sig(isig).valcom;
                            break;
                        end
                    end
                    if( ~found_flag ) % Botschaft wurde noch nicht gesetzt
                        
                        cal(ncal).sig(isig).valdec = -1;
                        cal(ncal).sig(isig).val    = -1;
                        cal(ncal).sig(isig).valcom = '-1';
                    end
                            
                end                    
            end
        end
    end
end
    

% function val = can_mess_calc_to_dec(bytes,dlc,startbit,bitlength,byteorder,wertetyp,bot_name,sig_name)
% val = 0;
% if( bitlength > 8 )
%     val = 0;
% end
% endbit = startbit+bitlength-1;
% 
% istart = floor(startbit/8)+1;
% iend   = floor(endbit/8)+1;
% 
% if( iend > dlc | istart > dlc )
%     
% %     text = sprintf('can_mess_calc: Aus Botschaft <%s> Signal <%s> ist gemessenes dlc=%i zu klein \nfür Signal (startbit=%i,bitlength=%i)', ...
% %                    bot_name,sig_name,dlc,startbit,bitlength);
% %     warning(text);
%     val = 0;
% else    
% 
%     startbit_istart = startbit - (istart-1)*8;
%     endbit_iend     = endbit - (istart-1)*8;
% 
%     bb= '';
%     if( byteorder == 1 | istart == iend ) % Intel bzw. alles in einem bytes von daher egal
%     
%         % Die entsprechenden bytes in bits wandeln
%         for i=istart:iend
%     
%             b = dec2bin(bytes(i));
%     
%             while length(b) < 8
%                 b = ['0',b];
%             end
%     
%             bb = [b,bb];
%         end
%     
%         % Den Ausschnitt der bits bestimmen
%         bb = bb(length(bb)-endbit_iend:length(bb)-startbit_istart);
%     
%         if( wertetyp == 1 ) %signed
%             text = sprintf('can_mess_calc: Aus Botschaft <%s> Signal <%s> ist der Wert signed zu berechnen Noch nicht programmiert', ...
%                            bot_name,sig_name);
%             error(text);
%         else %unsigned
%             val = bin2dec(bb);
%         end
%     
%         
%     else % Motorola
%         text = sprintf('can_mess_calc: Aus Botschaft <%s> Signal <%s> ist mit byteorder Motorola angegeben. Bisher noch nicht programmiert', ...
%                        bot_name,sig_name);
%         error(text);
%     end    
% 
% end