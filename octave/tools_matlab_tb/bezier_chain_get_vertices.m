function [xvec,yvec] = bezier_chain_get_vertices(s_chain,ii0,ii1)
%
%  [xvec,yvec] = bezier_chain_get_vertices(s_chain)
%  [xvec,yvec] = bezier_chain_get_vertices(s_chain,index)
%  [xvec,yvec] = bezier_chain_get_vertices(s_chain,index0,index1)
%  [xvec,yvec] = bezier_chain_get_vertices(s_chain,indexvec)
%
%  get all vertices or from index or from index0 to index1 or from indexvec
%
%  input:
%
%  s_chain             definition of a  bezier chain 
%                       s_chain.s(i)        ith bezier definition
%                       s_chain.n           number of beziers
%                       s_chani.slen(i)     slen(i) is start of s(i) and slen(i+1) is end of
%                                           s(i) => length(slen) = n+1
%  ii0                index to start or 
%                     index  (ii1 not given)
%                     indexvec (ii1 not given)
%  ii1                index to end    
%  
%  output:
%
%  xvec,yvec          All vertices but not  doubled at start and end
%

  if( ~exist('ii0','var') )
    ivec = [1:length(s_chain.s)]';
  else
    
    if( exist('ii1','var') )
      ivec = [ii0(1):ii1(1)]';
    else
      ivec = ii0;
    end
  end
  
  xvec = [];
  yvec = [];
  i0 = -1;
  for i=1:length(ivec)
    
    i1 = ivec(i);
    
    if( i1-1 == i0 )
      xvec = [xvec;s_chain.s(i1).xvec(2:end)];
      yvec = [yvec;s_chain.s(i1).yvec(2:end)];      
    else      
      xvec = [xvec;s_chain.s(i1).xvec];
      yvec = [yvec;s_chain.s(i1).yvec];
    end
    
    i0 = i1;
  end

  
end
