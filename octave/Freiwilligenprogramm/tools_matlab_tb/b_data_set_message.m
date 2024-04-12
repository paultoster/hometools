function b  = b_data_set_message(dbc,idhex,s,channel)
%
% b  = b_data_set_message(dbc,idhex,s,[channel])
% b  = b_data_set_message(dbc,name,s,[channel])
%
% set a message with idhex as b-structur
%
% dbc     struct   dbc-struct read dbc-Struktur with can_read_dbc()
%
% idehx   char     ID in HEX as string
% name    char     name of message
%
% s       struct   structure with Signals
%                  s.time     vector with time
%                  s.signame1 vector with signalname
%                  etc...
% channel num      [1],2,3
%
% output
%
%   b            b-Datenstruktur mit b.time(i)    Zeit
%                                    b.id(i)      ID-Botschaft
%                                    b.channel(i) Channel-Nr von 1 an
%                                    b.len(i)     DLC bytelength
%                                    b.byte0(i)   Vektor mit byte0 von 8 bytes
%                                    b.byte1(i)   Vektor mit byte1 von 8 bytes
%                                    b.byte2(i)   Vektor mit byte2 von 8 bytes
%                                    b.byte3(i)   Vektor mit byte3 von 8 bytes
%                                    b.byte4(i)   Vektor mit byte4 von 8 bytes
%                                    b.byte5(i)   Vektor mit byte5 von 8 bytes
%                                    b.byte6(i)   Vektor mit byte6 von 8 bytes
%                                    b.byte7(i)   Vektor mit byte7 von 8 bytes
%                                    b.receive(i) =1 Rx =0 Tx

% dbc:
% dbc(i).ident     double   Identifier Botschaft decimal
%       .id        double   Identifier Botschaft decimal 
%       .identhex  char     Identifier hex
%       .name      char     Name der Botschaft
%       .dlc       double   Länge bytes
%       .sender      char     Sender
%       .indexmz   double   Index mit Signal mit Multiplexzaehler
%       .comment   char     Kommentar
%       .cycle_time char     Zykluszeit aus Kommmentar ausgefiltert
%                           (Kennung im Kommentar @cycle_time:10 ms@, bleibt string)
% dbc(i).s_bus(i).name    char Name des Busses (Wird nur in der ersten Botschaft gespeichert)
% dbc(i).s_bus(i).comment char Kommentar
%       .CAN_bus   double   CAN-Bus-Nummer, wird bei doppeldeutigkeiten
%                           festgelegt. Normalerweise = 0, d.h. keine Zuordnung
%       .sig       struct   Struktur mit Signalen
%        sig(j).name            char    Name des Signals
%              .nr              double  laufende Nummer
%              .typ             double  -2 -> Signal (normal)
%                                       -1 -> Multiplexsignal (also Zähler)
%                                       i>=0 -> gemultiplexte Signal und Zählerwert
%              .mtyp            char    'N' -> Signal (normal)
%                                       'Z' -> Multiplexsignal (also Zähler)
%                                       'Mx' -> gemultiplexte Signal und
%                                               Zählerwert x=0,1,...
%              .startbit        double  Startbit  (bei Intel lsb, motorola msb)
%              .bitlength       double  bit Länge
%              .byteorder       double  0 -> Motorola
%                                       1 -> Intel
%              .wertetyp        double  0 -> unsigned
%                                       1 -> signed
%              .faktor          double  Faktor
%              .offset          double  Offset
%              .minval             double  Minimum
%              .maxval             double  Maximum
%              .einheit            char    Einheit
%              .empfang{k}      cell    Namen der BUs, die die Botschaft
%                                       bekommen
%              .comment   char     Kommentar
%              .s_val(i)        struct  Stuktur mit Wert und Bezeichnung
%              
%               s_val(k).val    double  Wert
%                       .comment char   Bezeichnung

%
% 
%
  if( ~exist('channel','var' ) )
    channel = 1;
  end
  b    = [];
  ndbc = length(dbc);
  flag = 0;
  for i=1:ndbc
    
    if( strcmpi(idhex,dbc(i).identhex) )
      flag = 1;
      message = dbc(i);
      break;
    elseif( strcmpi(idhex,dbc(i).name) )
      flag = 1;
      message = dbc(i);
      break;
    end
  end
  
  if( ~flag )
    error('%s_error: idhex = 0x%s wurd nicht in dbc gefunden',mfilename,idhex);
  end
  
  signames = fieldnames(s);
  
  itime = [];
  civec  = {};
  
  nmax = length(s.(signames{1}));
  for i=1:length(signames)
    
    nmax = min(nmax,length(s.(signames{i})));
    
    signame = signames{i};
    
    if( strcmpi(signame,'time') )
      itime = i;
    else
      for j=1:length(message.sig)
        if( strcmpi(signame,message.sig(j).name) )
          civec = cell_add(civec,[i,j]);
          break;
        end
      end
    end
  end
  for i=1:length(signames)
   
    s.(signames{i}) = s.(signames{i})(1:nmax);
  end 
  % Zeit belegen
  if( isempty(itime) )
    error('in struct s no time-Vektor found (s.time)')
  else
    ss.time = s.time;
  end
  
  % Alle Signale mit Nullen belegen
  for j=1:length(message.sig)
    ss.(message.sig(j).name) = ss.time*0;
  end
  
  % Vorhandene Signale kopieren
  for i=1:length(civec)
    
    ss.(message.sig(civec{i}(2)).name) = s.(signames{civec{i}(1)});
    fprintf('message.%s = s.%s\n',message.sig(civec{i}(2)).name,signames{civec{i}(1)});
  end
%   b            b-Datenstruktur mit b.time(i)    Zeit
%                                    b.id(i)      ID-Botschaft
%                                    b.channel(i) Channel-Nr von 1 an
%                                    b.len(i)     DLC bytelength
%                                    b.byte0(i)   Vektor mit byte0 von 8 bytes
%                                    b.byte1(i)   Vektor mit byte1 von 8 bytes
%                                    b.byte2(i)   Vektor mit byte2 von 8 bytes
%                                    b.byte3(i)   Vektor mit byte3 von 8 bytes
%                                    b.byte4(i)   Vektor mit byte4 von 8 bytes
%                                    b.byte5(i)   Vektor mit byte5 von 8 bytes
%                                    b.byte6(i)   Vektor mit byte6 von 8 bytes
%                                    b.byte7(i)   Vektor mit byte7 von 8 bytes
%                                    b.receive(i) =1 Rx =0 Tx
  n         = length(ss.time);
  b.time    = zeros(n,1);
  b.id      = zeros(n,1);
  b.channel = zeros(n,1);
  b.len     = zeros(n,1);
  b.byte0   = zeros(n,1);
  b.byte1   = zeros(n,1);
  b.byte2   = zeros(n,1);
  b.byte3   = zeros(n,1);
  b.byte4   = zeros(n,1);
  b.byte5   = zeros(n,1);
  b.byte6   = zeros(n,1);
  b.byte7   = zeros(n,1);
  b.receive = zeros(n,1);
  
  for i=1:n
    
    bytes = [0;0;0;0;0;0;0;0];
    
    t0    = ss.time(i);
    
    for j=1:length(message.sig)
      
      rawvalue = (ss.(message.sig(j).name)(i)- message.sig(j).offset) / message.sig(j).faktor;
      rawvalue = fix(rawvalue);
      
      if( message.sig(j).wertetyp ) % 1 -> signed
        
        if( message.sig(j).bitlength <= 8 )
          rawvaluelength = 8;
          rawbin         = dec2bin(typecast(int8(rawvalue),'uint8'),8);
        elseif( message.sig(j).bitlength <= 16 )
          rawvaluelength = 16;
          rawbin         = dec2bin(typecast(int16(rawvalue),'uint16'),16);
        elseif( message.sig(j).bitlength <= 32 )
          rawvaluelength = 32;
          rawbin         = dec2bin(typecast(int32(rawvalue),'uint32'),32);
        else
          rawvaluelength = 64;
          rawbin         = dec2bin(typecast(int64(rawvalue),'uint64'),64);
        end
      else
        if( message.sig(j).bitlength <= 8 )
          rawvaluelength = 8;
          rawbin         = dec2bin(typecast(uint8(rawvalue),'uint8'),8);
        elseif( message.sig(j).bitlength <= 16 )
          rawvaluelength = 16;
          rawbin         = dec2bin(typecast(uint16(rawvalue),'uint16'),16);
        elseif( message.sig(j).bitlength <= 32 )
          rawvaluelength = 32;
          rawbin         = dec2bin(typecast(uint32(rawvalue),'uint32'),32);
        else
          rawvaluelength = 64;
          rawbin         = dec2bin(typecast(uint64(rawvalue),'uint64'),64);
        end
      end  
      rawvaluelength = min(rawvaluelength,message.sig(j).bitlength);
      % Fit to bytes
      istart = mod(message.sig(j).startbit,8)+1;
      ibyte  = fix((message.sig(j).startbit)/8)+1;
      bytes  = b_data_set_message_set_rawvalue(bytes,ibyte,istart,rawbin,rawvaluelength,message.sig(j).byteorder);
        
        
        
    end
    
    b.time(i)    = t0;
    b.id(i)      = message.id;
    b.channel(i) = channel;
    b.len(i)     = message.dlc;
    b.byte0(i)   = bytes(1);
    b.byte1(i)   = bytes(2);
    b.byte2(i)   = bytes(3);
    b.byte3(i)   = bytes(4);
    b.byte4(i)   = bytes(5);
    b.byte5(i)   = bytes(6);
    b.byte6(i)   = bytes(7);
    b.byte7(i)   = bytes(8);
    b.receive(i) = 1;
  end
  
end
function bytes = b_data_set_message_set_rawvalue(bytes,ibyte,istart,rawbin,rawvaluelength,byteorder)
 n = length(rawbin);
 for i = 1:rawvaluelength
  ii = n-i+1;
  if( rawbin(ii) == '1' )
    try
    bytes(ibyte) = bitset(bytes(ibyte),istart,'uint8');
    catch
      a = 0;
    end
  end
  istart = istart + 1;
  if( istart > 8 )
    if( byteorder > 0.5 ) % Intel
      ibyte = ibyte + 1;
    else
      ibyte  = ibyte - 1;
    end
    istart = istart - 8;
    if( (ibyte > 8) || (ibyte < 1 ) )
      break;
    end
  end
 end  
end