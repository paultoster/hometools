function eout = cg_read_tacc_channel_Vpu4IQF1(e)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

  for i=1:n
    vecname = c_names{i};
    [tin,vin] = elim_nicht_monoton(double(e.(c_names{i}).time),double(e.(c_names{i}).vec));

    if(  strcmpi(vecname,'Vpu4IQF1_RefAng') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = vin;
      eout.(vecname).unit = 'deg';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Solllenkwinkel aus VPU4 in TAcc gemessen';       
    end    
    
  end
end