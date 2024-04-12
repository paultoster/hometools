function  cnames = cell_get_find_f(cell_array,such_muster,rg)
%
% cnames        = cell_get_find_f(cell_array,such_muster,regel)
%
% Sucht in cell array nach such_muster und gibt die Zellen zurück
% Wenn nicht gefunden dann {}
%
% cell_array    cell        cell array
% such_muster   char,cell   der zu suchende Text oder meherere Texte
% regel         char        'f' oder 'v' full oder voll. d.h such_muster muß
%                           vollständig mit einer cell übereinstimmen (default)
%                           'n'  muß nicht vollständig übereinstimmen
%                           'fl','vl','nl' vergleicht den Text mit lower()

  if( ~exist('rg','var') || ~ischar(rg) )    
      regel = 'f';    
      rg    = 'f';
  elseif( lower(rg(1)) ~= 'f' && lower(rg(1)) ~= 'v' )    
      regel = 'n';    
  else
      regel = 'f';
  end
  if( (length(rg) > 1) && (lower(rg(2)) == 'l') )
      lregel = 1;
  else
      lregel = 0;
  end

  if( ~iscell(cell_array) )
      error('1. Parameter von cell_find_f ist kein cell array')
  end

  if( ischar(such_muster) )

  %     if( strcmp(such_muster,'matx_Tin_Tdrag_0_gear_trans') )
  %         found_flag = 0;
  %     end
      such_muster = {such_muster};
  end
  if( ~iscell(such_muster) )
      error('2. Parameter von cell_find_f ist kein char oder cellarray mit char')
  end
  
  
  [ifound,~] = cell_find_f(cell_array,such_muster,rg);
  
  cnames = {};
  
  for i=1:length(ifound)
    cnames = cell_add(cnames,cell_array{ifound(i)});
  end

end