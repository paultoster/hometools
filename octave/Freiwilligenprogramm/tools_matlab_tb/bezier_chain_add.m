function s_chain = bezier_chain_add(s_chain,s,tol)
%
%  s_chain = bezier_chain_add(s_chain,s)
%  s_chain = bezier_chain_add(s_chain,s,tol)
%
%  add a bezier curve s build by s = bezier_def(xvec,yvec)
%
%  last point of chain must fit with tol to first point of s (s.xvec(1),s.yvec(1))
%
%  input:
%
%  s_chain             definition of a  bezier chain if new than struct([])
%  s                   bezier definition with bezier_def
%  tol                 tolerance (default = eps)
%  
%  output:
%
%  s_chain.s(i)        ith bezier definition
%  s_chain.n           number of beziers
%  s_chani.slen(i)     slen(i) is start of s(i) and slen(i+1) is end of
%                      s(i) => length(slen) = n+1
%  


  if( ~exist('tol','var') )
    tol = eps;
  else
    tol = abs(tol);
  end
  
  for i=1:length(s)
    s_chain = bezier_chain_add_single(s_chain,s(i),tol);
  end
end
function s_chain = bezier_chain_add_single(s_chain,s,tol)
  if( isempty(s_chain) )
    s_chain      = struct('s',s ...
                         ,'n',1 ...
                         ,'slen',[0.;s.length]);
  else
    xend = s_chain.s(end).xvec(end);
    yend = s_chain.s(end).yvec(end);
    dist = vek_2d_length(s.xvec(1),s.yvec(1),xend,yend);
    
    if( dist <= tol )
      s_chain.n            = s_chain.n + 1;
      s_chain.s(s_chain.n) = s;
      s_chain.slen         = [s_chain.slen;s_chain.slen(end)+s.length];
    else
      error('distance first point s (%f,%f) is not on last point of chain (%f,%f)',s.xvec(1),s.yvec(1),xend,yend)
    end
  end
end
