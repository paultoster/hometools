% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function  [okay] = data_is_dspa_format_f(dspa)                      

% Transformiert dspa-Datenformat in duh-Datenformat
                                                
% dspa-Datensatz muﬂ eine Struktur sein und muﬂ X und Y
% als Struktur besitzen, und Data muﬂ darin als double enthalten sein
if( strcmp(class(dspa),'struct') ...
  & isfield(dspa,'X') & isfield(dspa,'Y') ...
  & strcmp(class(dspa.X),'struct') & strcmp(class(dspa.Y),'struct') ...
  & isfield(dspa.X(1),'Data') & strcmp(class(dspa.X(1).Data),'double') ...
  & isfield(dspa.Y(1),'Data') & strcmp(class(dspa.Y(1).Data),'double') ...
  )
    okay = 1;

else
    okay = 0;
end
                       