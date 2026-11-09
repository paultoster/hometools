function eout = cg_read_tacc_channel_MFCImage(e)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

  for i=1:n          
    switch(c_names{i})
      case 'MFCImage_Timestamp'
        [tin,vin] = elim_nicht_monoton(double(e.(c_names{i}).time),double(e.(c_names{i}).vec));

         eout.(c_names{i}).time = tin;
         eout.(c_names{i}).vec  = vin;
         eout.(c_names{i}).unit = 'us';       
         eout.(c_names{i}).comment = 'TimeStamp MFC-Image';       
         eout.(c_names{i}).lin     = 1;       
    end
  end
end