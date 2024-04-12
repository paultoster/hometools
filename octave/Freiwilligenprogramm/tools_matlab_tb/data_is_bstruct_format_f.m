function  okay = data_is_bstruct_format_f(s)                      
%
% okay = data_is_bstruct_format_f(s)
%
% b            b-Datenstruktur mit b(i).time    Zeit
%                                  b(i).id      ID-Botschaft
%                                  b(i).channel Channel-Nr von 1 an
%                                  b(i).len     DLC bytelength
%                                  b(i).bytes   Vektor mit 8 bytes
%                                  b(i).receive =1 Rx =0 Tx

  okay = 0;
  if( isstruct(s) )
    okay = data_is_bstruct_format_check(s);
    if( ~okay )
      if( isfield(s,'b') )
        b = s.b;
        if( isstruct(b) )
          okay = data_is_bstruct_format_check(b);
        end
      end
    end
  end
end
function okay = data_is_bstruct_format_check(b)
  okay = 0;
  cnames = fieldnames(b);
  count = 0;
  for i=1:length(cnames)
    if(  strcmp(cnames{i},'time') ...
      || strcmp(cnames{i},'id') ...
      || strcmp(cnames{i},'channel') ...
      || strcmp(cnames{i},'len') ...
      || strcmp(cnames{i},'byte0') ...
      || strcmp(cnames{i},'byte1') ...
      || strcmp(cnames{i},'byte2') ...
      || strcmp(cnames{i},'byte3') ...
      || strcmp(cnames{i},'byte4') ...
      || strcmp(cnames{i},'byte5') ...
      || strcmp(cnames{i},'byte6') ...
      || strcmp(cnames{i},'byte7') ...
      || strcmp(cnames{i},'receive') ...
      )
      count = count +1;
    end
  end
  if( count == 13 )
    okay = 1;
  end
end                       