function c = d_data_build_empty_cstruct(d)
%
% c = d_data_build_empty_cstruct(d)
%
% Erstellt eine Kommentar c-structur aus mit den Namen aus der d-Struktur
% mit leeren strings
c_names = fieldnames(d);
if( isempty(c_names) ) 
  c = struct([]);
else
  for i=1:length(c_names)
    c.(c_names{i}) = '';
  end
end