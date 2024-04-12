function s_chain = bezier_chain_split(s_chain,ssplit)
%
%  s_chain = bezier_chain_split(s_chain,ssplit)
%
%  split bezier at ssplit in two beziers
%
%  input:
%
%  s_chain             definition of a  bezier chain 
%                       s_chain.s(i)        ith bezier definition
%                       s_chain.n           number of beziers
%                       s_chani.slen(i)     slen(i) is start of s(i) and slen(i+1) is end of
%                                           s(i) => length(slen) = n+1
%  ssplit             distance on s_chani.slen to identify number of bezier
%  
%  output:
%
%  s_chain
%


  rindex              = suche_index(s_chain.slen,ssplit,'===');
  index               = floor(rindex);
  t                   = rindex - index;
  if( index > s_chain.n )
    index = s_chain.n;
  elseif( (abs(t) < eps) && (index > 1 ) )
    index = index -1;
  end
  
  s0 = bezier_chain_split_s0(s_chain.s(index));
  s1 = bezier_chain_split_s1(s_chain.s(index));
  
  s_chain.n = s_chain.n + 1;
  slen0     = s_chain.slen(index);
  slen1     = s_chain.slen(index+1);
  for i=s_chain.n:-1:index+1
    s_chain.s(i)    = s_chain.s(i-1);
    s_chain.slen(i+1) = s_chain.slen(i);
  end
  s_chain.s(index)   = s0;
  s_chain.s(index+1) = s1;
  s_chain.slen(index+1) = slen0 + (slen1-slen0)*0.5;
  s_chain.slen(index+2) = slen1;
  
%   s_chain.slen = zeros(s_chain.n+1,1);
%   for i=1:s_chain.n
%     s_chain.slen(i+1) = s_chain.slen(i) + s_chain.s(i).length;
%   end
  
end
function  s0 = bezier_chain_split_s0(s)

  xvec = zeros(s.d,1);
  yvec = zeros(s.d,1);
  
  for i=1:s.d
    for j=1:i
      f = binominalkoeffizient(i-1,j-1) / (2.^(i-1));
      
      xvec(i) = xvec(i) + f * s.xvec(j);
      yvec(i) = yvec(i) + f * s.yvec(j);
    end
  end
  
  s0 = bezier_def(xvec,yvec);
  
end
function  s1 = bezier_chain_split_s1(s)

  xvec = zeros(s.d,1);
  yvec = zeros(s.d,1);
  
  for i=1:s.d
    for j=i:s.d
      f = binominalkoeffizient(s.d-i,s.d-j) / (2.^(s.d-i));      
      xvec(i) = xvec(i) + f * s.xvec(j);
      yvec(i) = yvec(i) + f * s.yvec(j);
    end
  end
  
  s1 = bezier_def(xvec,yvec);
  
end
