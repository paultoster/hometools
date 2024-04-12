function eout = cg_read_tacc_channel_AD2PCurvRequest(e,name)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

  for i=1:n
    vecname = c_names{i};
    [tin,vin] = elim_nicht_monoton(double(e.(c_names{i}).time),double(e.(c_names{i}).vec));

    eout.(vecname).time = tin;
    eout.(vecname).vec  = vin;
    eout.(vecname).unit = '';       
    eout.(vecname).lin  = 1;       
    eout.(vecname).comment = '';       
  end
end