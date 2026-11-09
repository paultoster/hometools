function eout = cg_read_tacc_channel_RT4000DataIn(e)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

% Channels zuordnen
%              RT4000DataIn_mAccLat: [1x1 struct]
%             RT4000DataIn_mAccLong: [1x1 struct]
%               RT4000DataIn_mAccUp: [1x1 struct]
%            RT4000DataIn_mAltitude: [1x1 struct]
%RT4000DataIn_mCurvature: [1x1 struct]
%            RT4000DataIn_mDistance: [1x1 struct]
%RT4000DataIn_mGpsStatus: [1x1 struct]
%RT4000DataIn_mLat: [1x1 struct]
%     RT4000DataIn_mLocalAngleTrack: [1x1 struct]
%RT4000DataIn_mLocalAngleYaw: [1x1 struct]
%           RT4000DataIn_mLocalVelX: [1x1 struct]
%           RT4000DataIn_mLocalVelY: [1x1 struct]
%RT4000DataIn_mLocalX: [1x1 struct]
%RT4000DataIn_mLocalY: [1x1 struct]
%RT4000DataIn_mLon: [1x1 struct]
%            RT4000DataIn_mPitchAcc: [1x1 struct]
%          RT4000DataIn_mPitchAngle: [1x1 struct]
%           RT4000DataIn_mPitchRate: [1x1 struct]
%             RT4000DataIn_mRollAcc: [1x1 struct]
%           RT4000DataIn_mRollAngle: [1x1 struct]
%            RT4000DataIn_mRollRate: [1x1 struct]
%       RT4000DataIn_mSideSlipAngle: [1x1 struct]
%          RT4000DataIn_mStdDevEast: [1x1 struct]
%         RT4000DataIn_mStdDevNorth: [1x1 struct]
%       RT4000DataIn_mTaccTimestamp: [1x1 struct]
%RT4000DataIn_mTimestamp: [1x1 struct]
%          RT4000DataIn_mTrackAngle: [1x1 struct]
%RT4000DataIn_mVelocity: [1x1 struct]
%     RT4000DataIn_mVelocityForward: [1x1 struct]
%     RT4000DataIn_mVelocityLateral: [1x1 struct]
%           RT4000DataIn_mVersionNo: [1x1 struct]
%              RT4000DataIn_mYawAcc: [1x1 struct]
%RT4000DataIn_mYawAngle: [1x1 struct]
%             RT4000DataIn_mYawRate: [1x1 struct]

  for i=1:n
    
    switch(c_names{i})
      case 'RT4000DataIn_mTimestamp'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment  = 'timestamp';
       eout.(c_names{i}).lin      = 0;
      case 'RT4000DataIn_mGpsStatus'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time     = tin;
       eout.(c_names{i}).vec      = vin;
       eout.(c_names{i}).unit     = 'enum';
       eout.(c_names{i}).comment  = 'mGpsStatus PosMode';
       eout.(c_names{i}).lin      = 0;
      case 'RT4000DataIn_mLocalX'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'Local Pos X';
       eout.(c_names{i}).lin      = 1;
      case 'RT4000DataIn_mLocalY'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'Local Pos Y';
       eout.(c_names{i}).lin      = 1;
      case 'RT4000DataIn_mLat'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'deg';
       eout.(c_names{i}).comment  = 'Lateral Position';
       eout.(c_names{i}).lin      = 1;
      case 'RT4000DataIn_mLon'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'deg';
       eout.(c_names{i}).comment  = 'Longitudinal Position';
       eout.(c_names{i}).lin      = 0;
      case 'RT4000DataIn_mYawAngle'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'deg';
       eout.(c_names{i}).comment  = 'Heading Angle';
       eout.(c_names{i}).lin      = 1;
      case 'RT4000DataIn_mLocalAngleYaw'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time     = tin;
       eout.(c_names{i}).vec      = vin;
       eout.(c_names{i}).unit     = 'deg';
       eout.(c_names{i}).comment  = 'Local Yaw Angle';
       eout.(c_names{i}).lin      = 1;
      case 'RT4000DataIn_mCurvature'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time     = tin;
       eout.(c_names{i}).vec      = vin;
       eout.(c_names{i}).unit     = '1/m';
       eout.(c_names{i}).comment  = 'Curvature';
       eout.(c_names{i}).lin      = 1;
      case 'RT4000DataIn_mVelocity'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time     = tin;
       eout.(c_names{i}).vec      = vin;
       eout.(c_names{i}).unit     = 'm/s';
       eout.(c_names{i}).comment  = 'approx velocity';
       eout.(c_names{i}).lin      = 1;       
      otherwise
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time     = tin;
       eout.(c_names{i}).vec      = vin;
       eout.(c_names{i}).unit     = '';
       eout.(c_names{i}).comment  = '';
       eout.(c_names{i}).lin      = 1;
       
    end
  end
end