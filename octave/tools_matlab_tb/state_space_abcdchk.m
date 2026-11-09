function [msg,A,B,C,D] = state_space_abcdchk(A,B,C,D)
%ABCDCHK Checks dimensional consistency of A,B,C,D matrices.
%   ERROR(ABCDCHK(A,B,C,D)) checks that the dimensions of A,B,C,D
%   are consistent for a linear, time-invariant system model.
%   An error occurs if the nonzero dimensions are not consistent.
%
%   [MSG,A,B,C,D] = ABCDCHK(A,B,C,D) also alters the dimensions
%   any 0-by-0 empty matrices to make them consistent with the others.
 
%   Copyright 1984-2004 The MathWorks, Inc.
 
  if nargin < 4, D = []; end 
  if nargin < 3, C = []; end 
  if nargin < 2, B = []; end 
  if nargin < 1, A = []; end 
   
  [ma,na] = size(A); 
  [mb,nb] = size(B); 
  [mc,nc] = size(C); 
  [md,nd] = size(D); 
   
  if mc==0 && nc==0 && (md==0 || na==0) 
     mc = md; nc = na; C = zeros(mc,nc);
  end
  if mb==0 && nb==0 && (ma==0 || nd==0) 
     mb = ma; nb = nd; B = zeros(mb,nb);
  end
  if md==0 && nd==0 && (mc==0 || nb==0) 
     md = mc; nd = nb; D = zeros(md,nd);
  end
  if ma==0 && na==0 && (mb==0 || nc==0) 
     ma = mb; na = nc; A = zeros(ma,na);
  end
   
  if ma~=na && nargin>=1 
      msg = 'Controllib:general:AMustBeSquare';
  elseif ma~=mb && nargin>=2 
      msg = 'Controllib:general:AAndBNumRowsMismatch';
  elseif na~=nc && nargin>=3 
      msg = 'Controllib:general:AAndCNumColumnsMismatch';
  elseif md~=mc && nargin>=4 
      msg = 'Controllib:general:CAndDNumRowsMismatch';
  elseif nd~=nb && nargin>=4 
      msg = 'Controllib:general:BAndDNumColumnsMismatch';
  else 
    msg.message = ''; 
    msg.identifier = ''; 
    msg = msg(zeros(0,1)); 
  end 
end