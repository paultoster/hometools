% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function  [choice,okay] = o_get_remote_command_f(remote_struct)
%
% remote_struct.i           aktuelle Zähler;
% remote_struct.n           Anzahl remote commands
% remote_struct.command     Cellarray mit den commands

if( remote_struct.i <= remote_struct.n )
    choice = char(remote_struct.command{i});
    remote_struct.i = remote_struct.i+1;
    if( remote_struct.i == remote_struct.n )
        fprintf('remote-Eingabe zu Ende \n');
    end
    okay = 1;
else
    choice = '';
    okay = 0;
end
