function val = value_step_limit(valnew,valold,steplimitplus,steplimitminus)
%
% val = value_step_limit(valnew,valold,steplimit)
% val = value_step_limit(valnew,valold,steplimitplus,steplimitminus)
%
%
  if( ~exist('steplimitminus','var') )
    steplimitminus = -steplimitplus;
  end
  delta = valnew-valold;
  if( delta > 0.0 ), val = valold + min(delta,steplimitplus);
  else               val = valold + max(delta,steplimitminus);    
  end
end