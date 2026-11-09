function Ssig = ContiGuard_PT_CAN_CART_OUT_mod_SigList
%
% Design List of signals from PT-CAN BMW545 (PT_CAN_CART_OUT_mod.dbc) do read from measurement
%
% Ssig(i).name_in      = 'signal name';
% Ssig(i).unit_in      = 'dbc unit';
% Ssig(i).lin_in       = 0/1;
% Ssig(i).name_sign_in = 'signal name for sign';
% Ssig(i).name_out     = 'output signal name';
% Ssig(i).unit_out     = 'output unit';
% Ssig(i).comment      = 'description';
%
% name_in      is name from dbc, could also be used with two and mor names
%              in cell array {'nameold','namenew'}, if their was an change
%              in dbc, use for old measurements
% unit_in      will used if no unit is in dbc for that input signal
% lin_in       =0/1 linearise if to interpolate to a commen time base
% name_sign_in if in dbc-File is a particular signal for sign (how VW
%              uses) exist
% name_out     output name in Matlab
% unit_out     output unit
% comment      description
%


  c = ...
  {{      'name_in','unit_in','lin_in','name_sign_in',      'name_out','unit_out',                               'comment'} ...
  ,{'ABS_Vref_low' ,'km/h'   ,0       ,''            ,'ABS_Vref_low'  ,'m/s'     ,'LowByte VRef'                          } ...
  ,{'ABS_Vref_high','km/h'   ,0       ,''            ,'ABS_Vref_high' ,'m/s'     ,'HighByte VRef'                         } ...
  ,{'STWA_TOP'     ,'deg'    ,0       ,''            ,'deltaStWhlBmw' ,'rad'     ,'Lenkwinkel BMW direkt vom PT-CAN'      } ...
  ,{'STWA_TOP_V'   ,'deg/s'  ,0       ,''            ,'deltapStWhlBmw','rad/s'   ,'Lenkwinkelgeschw BMW direkt vom PT-CAN'} ...
  };
  Ssig = cell_liste2struct(c);
%   iSig = 0;
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ABS_Vref_low';
%   Ssig(iSig).unit_in      = 'km/h';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ABS_Vref_low';
%   Ssig(iSig).unit_out     = 'm/s';
%   Ssig(iSig).comment      = 'LowByte VRef';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ABS_Vref_high';
%   Ssig(iSig).unit_in      = 'km/h';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ABS_Vref_high';
%   Ssig(iSig).unit_out     = 'm/s';
%   Ssig(iSig).comment      = 'HighByte VRef';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'STWA_TOP';
%   Ssig(iSig).unit_in      = 'deg';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'deltaStWhlBmw';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Lenkwinkel BMW direkt vom PT-CAN';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'STWA_TOP_V';
%   Ssig(iSig).unit_in      = 'deg/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'deltapStWhlBmw';
%   Ssig(iSig).unit_out     = 'rad/s';
%   Ssig(iSig).comment      = 'Lenkwinkelgeschw BMW direkt vom PT-CAN';
%   %-----------------------------------------------------------------------------------------------
%   okay = struct2cell_liste(Ssig)
% 
end