function b = b_data_add(b0,b1)
%
% b = b_data_add(b0,b1);
%
% eingelesene CAN-Ascii-Daten b1 wird an b0 gehängt, dabei zählt die Zeit
% weiter 
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
    error('%s: b0 is empty',mfilename);
  elseif( isempty(b1) )
    error('%s: b1 is empty',mfilename);
  else
    n0 = length(b0.time);
    n1 = length(b1.time);
    
    time0 = b0.time(n0);
    if( b1.time(1) < delta_t_inc_halbe )
      time0 = time0 + delta_t_inc;
    end
    b0 = check_b_size(b0);
    b1 = check_b_size(b1);
    b  = struct('time',[b0.time;b1.time+time0] ...
               ,'id',[b0.id;b1.id] ...
               ,'channel',[b0.channel;b1.channel] ...
               ,'len',[b0.len;b1.len] ...
               ,'byte0',[b0.byte0;b1.byte0] ...
               ,'byte1',[b0.byte1;b1.byte1] ...
               ,'byte2',[b0.byte2;b1.byte2] ...
               ,'byte3',[b0.byte3;b1.byte3] ...
               ,'byte4',[b0.byte4;b1.byte4] ...
               ,'byte5',[b0.byte5;b1.byte5] ...
               ,'byte6',[b0.byte6;b1.byte6] ...
               ,'byte7',[b0.byte7;b1.byte7] ...
               ,'receive',[b0.receive;b1.receive] ...
               );
  end
end
function b = check_b_size(b)
  b = check_vec_size(b,'time');
  b = check_vec_size(b,'id');
  b = check_vec_size(b,'channel');
  b = check_vec_size(b,'len');
  b = check_vec_size(b,'byte0');
  b = check_vec_size(b,'byte1');
  b = check_vec_size(b,'byte2');
  b = check_vec_size(b,'byte3');
  b = check_vec_size(b,'byte4');
  b = check_vec_size(b,'byte5');
  b = check_vec_size(b,'byte6');
  b = check_vec_size(b,'byte7');
  b = check_vec_size(b,'receive');
end
function  b = check_vec_size(b,name)
  if( isfield(b,name) ) 
    [n,m] = size(b.(name));
    if( m > n )
     b.(name)    = b.(name)';
    end
  end
end
     
      
