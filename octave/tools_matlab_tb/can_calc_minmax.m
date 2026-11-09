function [xmin,xmax] = can_calc_minmax(sig)
%
% [xmin,xmax] = can_calc_minmax(sig)
%
% berechnet Min-Max-Wert mit dbc-Info
%
%           sig.name            char    Name des Signals
%              .bitlength          double  bit Länge
%              .wertetyp        double  0 -> unsigned
%                                       1 -> signed
%              .faktor          double  Faktor
%              .offset          double  Offset

% dec-wert
if( sig.wertetyp == 0 ) % unsigned
    decmin = 0;
    decmax = 2^sig.bitlength-1;
else
    decmin = -2^(sig.bitlength-1)+1;
    decmax = 2^(sig.bitlength-1)-1;
end

xmin = decmin * sig.faktor + sig.offset;
xmax = decmax * sig.faktor + sig.offset;
