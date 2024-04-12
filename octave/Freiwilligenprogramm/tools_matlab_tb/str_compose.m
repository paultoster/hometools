function textout = str_compose(cnames,delim)
%
% textout = str_compose(cnames,delim)
%
% Textcellarray wird mit delim zusammengesetzt
  textout = '';
  if( strcmp(delim,'\t') )
    delim  = sprintf(delim);
  end

  if( isempty(cnames) )
      return
  end

  if( iscell(cnames) )
    n = length(cnames);
    for i=1:n
      if( ~ischar(cnames{i}) )
        error('cnames{%i} ist kein string',i);
      end
      textout = [textout,cnames{i}];
      if( i < n )
        textout = [textout,delim];
      end
    end    
  else
    error('Typ von cnames ist nicht cellarray')
  end
end

