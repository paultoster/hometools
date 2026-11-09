function type = get_type_of_matlabfilename(filename)
%
% proof filename for type
%
%  'abcd_gef_e.mat'  =>    type = 'e' e-Type e-Struktur (e_data_read_mat.m)
%  'abcd_gef_b.mat'  =>    type = 'b' b-Type CAN-Ascii-Daten
%  'abcd_gef.mat'    =>    type = 'd' d-Type d-Struktur (siehe d_data_read_mat.m)
%
% Wird hier nur anhand des Filenames identifiziert, nicht die Daten
%
  s_file = str_get_pfe_f(filename);

  cnames = str_split(s_file.name,'_');
  n      = length(cnames);
  
  if( n == 1 )
    type = 'd';
  elseif( strcmpi(cnames{n},'e') )
    type = 'e';
  elseif( strcmpi(cnames{n},'b') )
    type = 'b';
  else
    type = 'd';
  end
end