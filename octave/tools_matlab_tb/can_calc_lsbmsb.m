function [lsb,msb] = can_calc_lsbmsb(sig,typ)
%
% [lsb,msb] = can_calc_lsbmsb(sig,typ)
%
% Berechne lsb, msb aus der Signalstruktur sig (siehe
% can_dbc_read()
%
%  typ = 'byte' (default)      lsb und msb pro byte
%      = 'absolut'             lsb in der gesamten Botschaft
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
if( ~exist('typ','var') )
    typ = 'byte';
end

if( sig.byteorder == 1 ) %Intel
    lsb      = sig.startbit;
    msb      = lsb + sig.bitlength-1;
    
else % Motorola
    msb     = sig.startbit;
    lsb     = msb-sig.bitlength+1;
    [lowbyte,highbyte] = can_calc_lowhighbyte(sig);
    
    delbyte = lowbyte-highbyte;
    
    lsb = lsb + delbyte*2*8;
    
end
if( lower(typ(1)) == 'b' )
        
        [lowbyte,highbyte] = can_calc_lowhighbyte(sig);
        
        lsb = lsb - lowbyte*8;
        msb = msb - highbyte*8;
end
