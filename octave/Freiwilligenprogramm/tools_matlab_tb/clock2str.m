function str = clock2str(typ)
%
% str = clock2str(typ)
%
% typ = 'all'       Ausgabe alles (default) 
% z.B.
% 2-11-2006 12:53:56.37
% typ = 'file'
% '20061102125356'
%
if( ~exist('typ','var') )
    typ = 'all';
end
a = clock;
if( strcmp(typ,'file') )
  str = sprintf('%4.4i%2.2i%2.2i%2.2i%2.2i%2.2i',a(1),a(2),a(3),a(4),a(5),round(a(6)));
else
  str = sprintf('%i-%i-%i %i:%i:%s',a(3),a(2),a(1),a(4),a(5),num2str(a(6)));
end