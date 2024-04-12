function qlast_set(value_name,value)
%
% qlast_set(value_name,value)
% qlast_set(n,value)
%
% qlast.value_name = value;
% and store it to qlast.mat
%
% with n:
% n = 1: qlast.last_used_mease_dir        = value
% n = 2: qlast.last_used_file_list        = value
% n = 3: qlast.last_used_carmaker_erg_dir = value
%
  if( ~isempty(value) )
    flag = qlast_exist;
    if( flag )
       load(qlast_filename);
     end
    vname = qlast_build_name(value_name);
    qlast.(vname) = value;    
    qlast.dint    = datum_heute_to_int;
    save(qlast_filename,'qlast','-V6');
  end
end