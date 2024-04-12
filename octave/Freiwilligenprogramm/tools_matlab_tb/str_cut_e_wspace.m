function str = str_cut_e_wspace(str)
%
% str = str_cut_e_wspace(str)
%
% Schneide alle Whitespace (' ',\t,\n) am Ende ab

  ivec = isstrprop(str,'wspace');
  n    = length(ivec);

  if( ivec(n) == 0 ) % no whitespcae
    return
  else
    i = n-1;
    while( i >= 1 )

      if( ivec(i) == 0 )
        break;
      end
      i = i-1;
    end
    if( i == 0 )
      str = '';
    else
      str = str(1:i);
    end
  end
end
% function str = str_cut_a_wspace(str)
% %
% % str = str_cut_a_wspace(str)
% %
% % Schneide alle Whitespace (' ',\t,\n) am Anfang ab
% 
%   ivec = isstrprop(str,'wspace');
%   n    = length(ivec);
% 
%   if( ivec(1) == 0 ) % no whitespcae
%     return
%   else
%     i = 2;
%     while( i <= n )
% 
%       if( ivec(i) == 0 )
%         break;
%       end
%       i = i+1;
%     end
%     str = str(i:end);
%   end
% end
