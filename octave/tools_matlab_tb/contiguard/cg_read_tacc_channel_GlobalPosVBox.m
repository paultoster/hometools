function eout = cg_read_tacc_channel_GlobalPosVBox(e)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

  for i=1:n
    vecname = c_names{i};
    [tin,vin] = elim_nicht_monoton(double(e.(c_names{i}).time),double(e.(c_names{i}).vec));

    if(  strcmpi(vecname,'mTimestamp') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'us';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'TimeStamp';       
    elseif(  strcmpi(vecname,'mAltitude') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin)*0.5;
      eout.(vecname).unit = 'm';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Höhe';       
    elseif(  strcmpi(vecname,'mLat') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'deg';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Latitude';       
    elseif(  strcmpi(vecname,'mLon') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'deg';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Longitude';       
    elseif(  strcmpi(vecname,'mCourse') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'deg';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Headingangle';       
    elseif(  strcmpi(vecname,'mCourseValid') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'enum';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Valid Heading Angle';       
    elseif(  strcmpi(vecname,'mConfCircle') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'm';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Confidencecircle (2.0/0.4/0.02)';       
    elseif(  strcmpi(vecname,'mX') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'm';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'x-Position';       
    elseif(  strcmpi(vecname,'mY') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'm';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'y-Position';       
    elseif(  strcmpi(vecname,'mVelocity') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'm/s';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Fahrgeschwindigkeit';       
    elseif(  strcmpi(vecname,'mYawrate') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'rad/s';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Gierrate';       
    elseif(  strcmpi(vecname,'mAccLong') )
      eout.(vecname).time = tin;
      eout.(vecname).vec  = double(vin);
      eout.(vecname).unit = 'm/s/s';
      eout.(vecname).lin  = 0;       
      eout.(vecname).comment = 'Beschleunigung';       
    end    
    
  end
end