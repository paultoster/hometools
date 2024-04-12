function b = b_data_merge(b0,b1)
%
% b = b_data_merge(b0,b1);
%
% b            b-Datenstruktur mit b.time(i)    Zeit
%                                  b.id(i)      ID-Botschaft
%                                  b.channel(i) Channel-Nr von 1 an
%                                  b.len(i)     DLC bytelength
%                                  b.byte0(i)   Vektor mit byte0 von 8 bytes
%                                  b.byte1(i)   Vektor mit byte1 von 8 bytes
%                                  b.byte2(i)   Vektor mit byte2 von 8 bytes
%                                  b.byte3(i)   Vektor mit byte3 von 8 bytes
%                                  b.byte4(i)   Vektor mit byte4 von 8 bytes
%                                  b.byte5(i)   Vektor mit byte5 von 8 bytes
%                                  b.byte6(i)   Vektor mit byte6 von 8 bytes
%                                  b.byte7(i)   Vektor mit byte7 von 8 bytes
%                                  b.receive(i) =1 Rx =0 Tx

  delta_t_inc = 0.000001;
  delta_t_inc_halbe = delta_t_inc*0.5;
   b = struct([]);
  if( isempty(b0) )
    b = b1;
  elseif( isempty(b1) )
    b = b0;
  else
    n0 = length(b0.time);
    n1 = length(b1.time);
    if( b0.time(1) < b1.time(1) )
      b=b_data_add(b,b0,1);
      i    = 1;
      i0   = 2;
      i1   = 1;
    else
      b=b_data_add(b,b1,1);
      i    = 1;
      i0   = 1;
      i1   = 2;
    end
    while( (i0 < n0) || (i1 < n1) )
      if( i0 == n0 )
        b=b_data_add(b,b1,i1);
        i    = i+1;
        i1   = i1+1;          
        if( (b1.time(i1-1)-b.time(i-1)) <  delta_t_inc_halbe )
          b.time(i) = b.time(i-1) + delta_t_inc;
        end        
      elseif( i1 == n1 )
        i    = i+1;
        b=b_data_add(b,b0,i0);
        i0   = i0+1;          
        if( (b0.time(i0-1)-b.time(i-1)) <  delta_t_inc_halbe )
          b.time(i) = b.time(i-1) + delta_t_inc;
        end
      else
        if( b0.time(i0) <= b1.time(i1) )
          i    = i+1;
          b=b_data_add(b,b0,i0);
          i0   = i0+1;          
          if( (b0.time(i0-1)-b.time(i-1)) <  delta_t_inc_halbe )
            b.time(i) = b.time(i-1) + delta_t_inc;
          end
        else
          i    = i+1;
          b=b_data_add(b,b1,i1);
          i1   = i1+1;          
          if( (b1.time(i1-1)-b.time(i-1)) <  delta_t_inc_halbe )
            b.time(i) = b.time(i-1) + delta_t_inc;
          end        
        end
      end
    end
  end
  if( isfield(b,'time') ) 
    [n,m] = size(b.time);
    if( m > n )
     b.time    = b.time';
     b.id      = b.id';
     b.channel = b.channel';
     b.len     = b.len';
     b.byte0   = b.byte0';
     b.byte1   = b.byte1';
     b.byte2   = b.byte2';
     b.byte3   = b.byte3';
     b.byte4   = b.byte4';
     b.byte5   = b.byte5';
     b.byte6   = b.byte6';
     b.byte7   = b.byte7';
     b.receive = b.receive';
    end
  end
end
function  b1=b_data_add(b1,b,i)

 if( ~isfield(b1,'time') )
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
     
      
