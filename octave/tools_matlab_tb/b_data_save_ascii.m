function okay = b_data_save_ascii(b,ascii_datei_name,i0,i1)
%
% okay = b_data_save_ascii(b,ascii_datei_name)
% okay = b_data_save_ascii(b,ascii_datei_name,i0,i1)
%
% Speichert b-Struktur in ascii-DAtei (wenn i0 und i1 angegben,
% dann i = i0:i1
%
% b.time(i)
% b.id(i)
% b.channel(i)
% b.len(i)
% b.byte0(i)
% ...
% b.byte7(i)
% b.receive(i)

  if( exist('i0','var') && exist('i1','var') )
    if( i1 >= i0 )
      istart = i0;
      iend   = i1;
    else
      istart = i1;
      iend   = i0;
    end
  else
    istart = 1;
    iend   = length(b.time);
  end
  okay = 1;
  
  mexBDataSaveAscii(b,ascii_datei_name,istart,iend);
  
%   [fid,message] = fopen(ascii_datei_name,'w');
% 
%   if( fid < 0 )
%     error('%s\n',message);
%   end
% 
%   % Header
%   fprintf(fid,'date %s\n',datestr(now, 'ddd mmm HH:MM:SS yyyy'));
%   fprintf(fid,'base hex  timestamps absolute\n');
%   fprintf(fid,'Begin Triggerblock %s\n',datestr(now, 'ddd mmm HH:MM:SS yyyy'));
% 
%   for i = istart:iend
%     if( b.receive(i) )
%       fprintf(fid,'%11.6f%2i%5s             Rx   d%2i',b.time(i),b.channel(i),dec2hex(b.id(i)),b.len(i));
%     else
%       fprintf(fid,'%11.6f%2i%5s             Tx   d%2i',b.time(i),b.channel(i),dec2hex(b.id(i)),b.len(i));
%     end
%     tt = [];
%     if( b.len(i) > 0 ),tt = [tt,sprintf(' %2s',dec2hex(b.byte0(i)))];end
%     if( b.len(i) > 1 ),tt = [tt,sprintf(' %2s',dec2hex(b.byte1(i)))];end
%     if( b.len(i) > 2 ),tt = [tt,sprintf(' %2s',dec2hex(b.byte2(i)))];end
%     if( b.len(i) > 3 ),tt = [tt,sprintf(' %2s',dec2hex(b.byte3(i)))];end
%     if( b.len(i) > 4 ),tt = [tt,sprintf(' %2s',dec2hex(b.byte4(i)))];end
%     if( b.len(i) > 5 ),tt = [tt,sprintf(' %2s',dec2hex(b.byte5(i)))];end
%     if( b.len(i) > 6 ),tt = [tt,sprintf(' %2s',dec2hex(b.byte6(i)))];end
%     if( b.len(i) > 7 ),tt = [tt,sprintf(' %2s',dec2hex(b.byte7(i)))];end
%     fprintf(fid,'%s\n',tt);
%   end
%   
%   fprintf(fid,'End TriggerBlock');
%   fclose(fid);
  
%   c = {};
% 
%   % Header
%   c{1} = sprintf('date %s',datestr(now, 'ddd mmm HH:MM:SS yyyy'));
%   c{2} = sprintf('base hex  timestamps absolute');
%   c{3} = sprintf('Begin Triggerblock %s',datestr(now, 'ddd mmm HH:MM:SS yyyy'));
% 
%   for i = istart:iend
%     if( b.receive(i) )
%       c{i+3} = sprintf('%11.6f%2i%5s             Rx   d%2i',b.time(i),b.channel(i),dec2hex(b.id(i)),b.len(i));
%     else
%       c{i+3} = sprintf('%11.6f%2i%5s             Tx   d%2i',b.time(i),b.channel(i),dec2hex(b.id(i)),b.len(i));
%     end
%     if( b.len(i) > 0 ),c{i+3} = [c{i+3},sprintf(' %2s',dec2hex(b.byte0(i)))];end
%     if( b.len(i) > 1 ),c{i+3} = [c{i+3},sprintf(' %2s',dec2hex(b.byte1(i)))];end
%     if( b.len(i) > 2 ),c{i+3} = [c{i+3},sprintf(' %2s',dec2hex(b.byte2(i)))];end
%     if( b.len(i) > 3 ),c{i+3} = [c{i+3},sprintf(' %2s',dec2hex(b.byte3(i)))];end
%     if( b.len(i) > 4 ),c{i+3} = [c{i+3},sprintf(' %2s',dec2hex(b.byte4(i)))];end
%     if( b.len(i) > 5 ),c{i+3} = [c{i+3},sprintf(' %2s',dec2hex(b.byte5(i)))];end
%     if( b.len(i) > 6 ),c{i+3} = [c{i+3},sprintf(' %2s',dec2hex(b.byte6(i)))];end
%     if( b.len(i) > 7 ),c{i+3} = [c{i+3},sprintf(' %2s',dec2hex(b.byte7(i)))];end
%   end
%   
%   c = cell_add(c,'End TriggerBlock');
% 
%   okay = write_ascii_file(ascii_datei_name,c);
%   
end

