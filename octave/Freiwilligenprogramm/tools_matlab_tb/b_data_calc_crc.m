function b = b_data_calc_crc(b,id,byte_start,byte_end,byte_write,start_value,negate,byteorder,type)

%
% b = b_data_calc_crc(b,id,byte_start,byte_end,byte_write)
% b = b_data_calc_crc(b,id,byte_start,byte_end,byte_write,type)
%
% Calculates CRC-Check, starting from byte_start to byte_end and writes
% into byte_write
%
% b              d_data-structure
%                b.time(i)
%                b.id(i)
%                b.channel(i)
%                b.len(i)
%                b.byte0(i)
%                ...
%                b.byte7(i)
%                b.receive(i)
% id             decimal id of message
% byte_start     start byte for calculation start by 1
% byte_end       end byte for calculation ends maximum at 8
% byte_start     write into byte for calculation start by 1
% start_value    start value for crc-calc
% negate         negate byte of crc-check
% byteorder      0: motorola, 1: intel
% type           type of crc-check (default = 'SAEJ1850')

  if( ~exist('type','var') )
    type = 'SAEJ1850';
  end
  
  if( strcmp(type,'SAEJ1850') )
    
    n  = length(b.time);
    i0 = uint8(byte_start-1);
    for i=1:n
      
      if( b.id(i) == id )
        clear bytes
        for j = 1:b.len(i)
          if( j == 1 )
            bytes(j) = uint8(b.byte0(i));
          elseif( j == 2 )
            bytes(j) = uint8(b.byte1(i));
          elseif( j == 3 )
            bytes(j) = uint8(b.byte2(i));
          elseif( j == 4 )
            bytes(j) = uint8(b.byte3(i));
          elseif( j == 5 )
            bytes(j) = uint8(b.byte4(i));
          elseif( j == 6 )
            bytes(j) = uint8(b.byte5(i));
          elseif( j == 7 )
            bytes(j) = uint8(b.byte6(i));
          elseif( j == 8 )
            bytes(j) = uint8(b.byte7(i));
          end
        end
        i1 = uint8(min(byte_end,b.len(i))-1);
        %iw = uint8(min(byte_write,b.len(i))-1);
        nbytes = uint8(i1-i0+1);
        
        crc = mexBuildCrcSaeJ1850(uint8(start_value),bytes,i0,nbytes,uint8(negate),uint8(byteorder));

        if( byte_write == 1 )
          b.byte0(i) = crc;
        elseif( byte_write == 2 )
          b.byte1(i) = crc;
        elseif( byte_write == 3 )
          b.byte2(i) = crc;
        elseif( byte_write == 4 )
          b.byte3(i) = crc;
        elseif( byte_write == 5 )
          b.byte4(i) = crc;
        elseif( byte_write == 6 )
          b.byte5(i) = crc;
        elseif( byte_write == 7 )
          b.byte6(i) = crc;
        elseif( byte_write == 8 )
          b.byte7(i) = crc;
        end
      end
      
    end
    
  end
end

