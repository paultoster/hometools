function  d_out = dspa_beschneiden_f(d,istart,iend,t0_flag)
%
% d_out = dspa_beschneiden_f(d,istart,iend,t0_flag)
%
% Dspace-Datenformat; Daten beschneieden
%
% d         dspa-Datenstruktur
% istart    Startindex
% iend      Endindex
% t0_flag   wenn gesetzt, Zeitvektor mit Offset auf null verschieben
%

d.X.Data = d.X.Data(max(istart,1):min(iend,length(d.X.Data)));

if( nargin >=4 ...
  & t0_flag == 1 ...
  )
        d.X.Data = d.X.Data-d.X.Data(1);
end

for i=1:length(d.Y)
    
    d.Y(i).Data = d.Y(i).Data(max(istart,0):min(iend,length(d.Y(i).Data)));
end

d_out = d;