function b1  = b_data_filter(b,idvec,chanvec,type)
%
% b  = b_data_filter(b,idvec,chanvec,type)
%
% b           b-Datenstruktur mit    b.time(i)    Zeit
%                                    b.id(i)      ID-Botschaft
%                                    b.channel(i) Channel-Nr von 1 an
%                                    b.len(i)     DLC bytelength
%                                    b.byte0(i)   Vektor mit byte0 von 8 bytes
%                                    b.byte1(i)   Vektor mit byte1 von 8 bytes
%                                    b.byte2(i)   Vektor mit byte2 von 8 bytes
%                                    b.byte3(i)   Vektor mit byte3 von 8 bytes
%                                    b.byte4(i)   Vektor mit byte4 von 8 bytes
%                                    b.byte5(i)   Vektor mit byte5 von 8 bytes
%                                    b.byte6(i)   Vektor mit byte6 von 8 bytes
%                                    b.byte7(i)   Vektor mit byte7 von 8 bytes
%                                    b.receive(i) =1 Rx =0 Tx
% idvec                              vektor mit ids
% chanvec                            vektor mit channel gleiche Länge idvec
% Filterted idvec und chanvec mit type = 'd' Durchlassfilter bzw. type = 's' Sperrfilter
%
  if( ~data_is_bstruct_format_f(b) )
    error('%s: b hat nicht das richtige Datenformat b.time(i), b.id(i), b.channel(i), b.len(i), b.byte0(i), ...  b.byte7(i), d.receive(i)',mfilename);
  end
  b1 = struct([]);
  n  = length(b.time);
  nv = min(length(idvec),length(chanvec));
  nn = 0;
  if( (type(1) == 's') || (type(1) == 'S') )
    itype = 1;
  else
    itype = 0;
  end
  if( itype ) % Sperrr
    for i=1:n
      flag  = 1;
      for j=1:nv
        if( (idvec(j) == b.id(i)) && (chanvec(j) == b.channel(i)) )
          flag  = 0;
          break;
        end
      end
      if( flag )
        nn = nn+1;
        b1=b_data_add(b1,b,i);
      end
    end
  else % Durchlass
    for i=1:n
      flag  = 0;
      for j=1:nv
        if( (idvec(j) == b.id(i)) && (chanvec(j) == b.channel(i)) )
          flag  = 1;
          break;
        end
      end
      if( flag )
        nn = nn+1;
        b1=b_data_add(b1,b,i);
      end
    end
  end  
  if( isfield(b1,'time') ) 
    [n,m] = size(b1.time);
    if( m > n )
     b1.time    = b1.time';
     b1.id      = b1.id';
     b1.channel = b1.channel';
     b1.len     = b1.len';
     b1.byte0   = b1.byte0';
     b1.byte1   = b1.byte1';
     b1.byte2   = b1.byte2';
     b1.byte3   = b1.byte3';
     b1.byte4   = b1.byte4';
     b1.byte5   = b1.byte5';
     b1.byte6   = b1.byte6';
     b1.byte7   = b1.byte7';
     b1.receive = b1.receive';
    end
  end
end
function  b1=b_data_add(b1,b,i)

 if( isempty(b1) || ~isfield(b1,'time') )
   b1 = struct('time',b.time(i) ...
              ,'id',b.id(i) ...
              ,'channel',b.channel(i) ...
              ,'len',b.len(i) ...
              ,'byte0',b.byte0(i) ...
              ,'byte1',b.byte1(i) ...
              ,'byte2',b.byte2(i) ...
              ,'byte3',b.byte3(i) ...
              ,'byte4',b.byte4(i) ...
              ,'byte5',b.byte5(i) ...
              ,'byte6',b.byte6(i) ...
              ,'byte7',b.byte7(i) ...
              ,'receive',b.receive(i) ...
              );
 else
  n = length(b1.time)+1;
   b1.time(n)    = b.time(i);
   b1.id(n)      = b.id(i);
   b1.channel(n) = b.channel(i);
   b1.len(n)     = b.len(i);
   b1.byte0(n)   = b.byte0(i);
   b1.byte1(n)   = b.byte1(i);
   b1.byte2(n)   = b.byte2(i);
   b1.byte3(n)   = b.byte3(i);
   b1.byte4(n)   = b.byte4(i);
   b1.byte5(n)   = b.byte5(i);
   b1.byte6(n)   = b.byte6(i);
   b1.byte7(n)   = b.byte7(i);
   b1.receive(n) = b.receive(i);
 end
end
  