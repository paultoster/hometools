function eout = cg_read_tacc_channel_GenericObjectList(e)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

  for i=1:n
    if( str_find_f(c_names{i},'_data_mBuffer','vs') > 0 )
      vecname = str_cut_f(c_names{i},'_data_mBuffer','v');
    else
      vecname = c_names{i};
    end
    [tin,vin] = elim_nicht_monoton(double(e.(c_names{i}).time),double(e.(c_names{i}).vec));

    eout.(vecname).time = double(tin);
    eout.(vecname).vec  = double(vin);
    eout.(vecname).unit = '';    
    eout.(vecname).lin  = 0;    
    eout.(vecname).comment = '';    
  end
end