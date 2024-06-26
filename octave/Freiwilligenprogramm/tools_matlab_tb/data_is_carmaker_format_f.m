function  [okay] = data_is_carmaker_format_f(cm)                      

% Transformiert dspa-Datenformat in duh-Datenformat
                                                
% cm-Datensatz mu� eine Struktur sein und mu� Time als struktur haben
% 
if(  isstruct(cm) ...
  && isfield(cm,'Time') ...
  && isstruct(cm.Time) ...
  && isfield(cm.Time,'name') ...
  && strcmp(cm.Time.name,'Time') ...
  && isfield(cm.Time,'data') ...
  && isnumeric(cm.Time.data) ...
  && isfield(cm.Time,'unit') ...
  )
    okay = 1;

else
    okay = 0;
    if( isstruct(cm) )
      warning('Signal Time ist nicht richtig enthalten')
    else
      warning('cmdata enth�lt keine Struktur')
    end
end
                       