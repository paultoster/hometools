function t = str_resolvecamelcase(tin,type)
%
%
% t = str_resolvecamelcase(t)
% t = str_resolvecamelcase(t,type)
%
% resolve camelcase type = 0 (default) AbcDef => abc_def
%                   type = 1           AbcDef => Abc_Def
  t = '';
  if( ~exist('type','var') )
    tye = 0;
  end
  n = length(tin);
  if( n == 0 )
    t = '';
  elseif( n == 1 )
    t = tin;
  else
    t = '';
    for i=1:n-1
      a = str_is_upper(tin(i));
      b = str_is_lower(tin(i+1));
      
      if( a(1) && b(1) )
        if( i > 1 )
          t = [t,'_'];
        end
        if( ~type )
          t = [t,lower(tin(i))];
        else
          t = [t,tin(i)];
        end
      else
        t = [t,tin(i)];
      end
    end
  end
end
