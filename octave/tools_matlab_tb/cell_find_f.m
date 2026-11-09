function  [ifound,ipos] = cell_find_f(cell_array,such_muster,rg)
%
% ifound        = cell_find_f(cell_array,such_muster,regel)
% [ifound,ipos] = cell_find_f(cell_array,such_muster,regel)
%
% Sucht in cell array nach such_muster und gibt Index zurück
% Wenn nicht gefunden dann isempty(ifound)
%
% cell_array    cell        cell array
% such_muster   char,cell   der zu suchende Text oder meherere Texte
% regel         char        'f' oder 'v' full oder voll. d.h such_muster muß
%                           vollständig mit einer cell übereinstimmen (default)
%                           'n'  muß nicht vollständig übereinstimmen
%                           'fl','vl','nl' vergleicht den Text mit lower()
% ifound        double array      Index des cellarray gefunden
%                                 [] nichts gefunden
% ipos          double array      Liste mit Position in cell, bei 'f','v'
%                                 pos(index) = 1

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

  ifound = [];
  ipos   = [];

  for j = 1:length(such_muster)

      if( lregel )
        text2 = lower(such_muster{j});
      else
        text2 = such_muster{j};
      end
  %    found_flag = 0;
      for i=1:length(cell_array)

          if( lregel )
            text1 = lower(cell_array{i});
          else
            text1 = cell_array{i};
          end
          if( regel == 'f' )
            if( strcmp(text1,text2) )
              ifound = [ifound,i];
              ipos   = [ipos,1];
  %                found_flag = 1;
            end
          else
            ll = strfind(text1,text2);
            for ii=1:length(ll)
              ifound = [ifound,i];
              ipos   = [ipos,ll(ii)];
            end
          end
  %         if( found_flag )
  %             break;
  %         end
      end
  end
  %found_flag = 0;
end