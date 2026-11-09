function ivec = isalphanumspez(text_string,cadd)
%
% ivec = isalphanumspez(text_string,cadd)
%
% find with ivec = isstrprop(text_string,'alphanum')
% all aphanumerical digits and add from cellarray cadd
%
% example
%
% ivec = isalphanumspez('ab_k u_wd',{'_'}); => ivec = [1,1,1,1,0,1,1,1,1]
% ivec = isalphanumspez('ab_k u_wd',{''}); => ivec = [1,1,0,1,0,1,0,1,1]
%
%
  ivec = isstrprop(text_string,'alphanum');
  n    = length(ivec);
  for i=1:length(cadd)
    
    s = cadd{i};
    if( ~isempty(s) )
      for j=1:n
        if( s(1) == text_string(j) )
          ivec(j) = 1;
        end
      end
    end
  end
end
