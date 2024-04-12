function [lowbyte,highbyte] = can_calc_lowhighbyte(sig)
%
% [lowbyte,highbyte] = can_calc_lowhighbyte(sig)
%
% Berechne lowbyte, highbyte aus der Signalstruktur sig (siehe
% can_dbc_read()
%
%           sig.name            char    Name des Signals
%              .nr              double  laufende Nummer
%              .typ             double  -2 -> Signal (normal)
%                                       -1 -> Multiplexsignal (also Zähler)
%                                       i>=0 -> gemultiplexte Signal und Zählerwert
%              .mtyp            char    'N' -> Signal (normal)
%                                       'Z' -> Multiplexsignal (also Zähler)
%                                       'Mx' -> gemultiplexte Signal und
%                                               Zählerwert x=0,1,...
%              .startbit        double  Startbit  (bei Intel lsb, motorola msb)
%              .bitlength          double  bit Länge
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

if( sig.byteorder == 1 ) %Intel
    lsb      = sig.startbit;
    lowbyte  = floor(lsb/8);
    
    highbyte = floor((lsb+sig.bitlength-1)/8);
else % Motorola
    msb     = sig.startbit;
    highbyte = floor(msb/8);
    
    delbyte = floor((msb-sig.bitlength+1)/8)-highbyte;
    
    lowbyte = highbyte - delbyte;
    
end
