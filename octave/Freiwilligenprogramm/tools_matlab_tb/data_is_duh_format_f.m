function  [okay] = data_is_duh_format_f(duh)                      

                                                
% duh-Datensatz mu� eine Struktur sein und mu� d
% als Struktur besitzen
if( strcmp(class(duh),'struct') ...
  & isfield(duh,'d') ...
  & strcmp(class(duh.d),'struct') ...
  )
    okay = 1;

else
    okay = 0;
end
                       