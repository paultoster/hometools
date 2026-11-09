function [c_words,n_words] = cell_find_next_words(c,icell,ipos,n_search,type,cdelim)
%
% [c_words,n_words] = cell_find_next_words(c,icell,ipos,n_search,type)
%
% Find in in cellarray c (string) from position c{icell}(ipos) in direction
% of type for n_search words
%
% type   : 'for' :     forward
%          'back':     backwards
%
% cdelim :             list of delimiter default {' ','\t'}
%
% [c_words,n_words] cell_find_next_words({'abc def kah','123 qqh'},2,5,2,'b',' '}
%
% => c_words = {'123','kah'} n_words = 2
%
  c_words = {};
  n_words = 0;
  
  if( ~exist('cdelim','var') )
    cdelim = {' ',sprintf('\t')};
  end
  if( ischar(cdelim) )
    cdelim = {cdelim};
  end
  ndelim = length(cdelim);
  
  if( strcmpi(t(1),'f') )
    ipos = ipos + 1;
    [jcell,jpos,str] = cell_find_nearest_from_ipos(c,icell,ipos,cdelim,'f');
    % #### hier weiter
  else
    forw = 0;
  end
  
end