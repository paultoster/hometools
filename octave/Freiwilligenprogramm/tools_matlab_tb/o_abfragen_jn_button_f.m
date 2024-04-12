function [flag,s_prot,s_remote] = o_abfragen_jn_button_f(s_frage,s_prot,s_remote)
%
% [flag,s_prot,s_remote] = o_abfragen_jn_button_f(s_frage,s_prot,s_remote)
%
% Abfrage auf ja/nein mit einem button
% s_frage           Struktur mit Frage
% s_frage.comment   Die Frage (oder .frage)
% s_frage.command   Command f�r Protokoll
% s_frage.prot      Soll protokolliert werden
% s_frgae.default   Solldefault verwendet werden
% s_frage.def_value Defaulteinstellung bei Abfrage 'j' oder 'n'
% s_frage.exact_answer wenn gleich 1, mu� eine exakte Eingabe j,y, oder n
% gegeben werden
%
% fid_proto     ist die Ausgabe fid f�r das Protokoll
%
% remote_struct Struktur mit den remote eingaben, wenn nicht vorhanden oder
%               keine Struktur dann ignorieren
%
% flag          antwort mit 1:ja  0:nein

prot_flag = 1;
remote_flag = 1;
default = 1;
debug_fid = 0;
def_value = 'n';

if( nargin > 0 && isstruct(s_frage) )

    if( ~isfield(s_frage,'prot') )
        prot_flag = 0;
    else
        prot_flag = s_frage.prot;
    end
    if( ~isfield(s_frage,'command') )
        prot_flag = 0;
        remote_flag = 0;
    else
        command = s_frage.command;
    end
    if( isfield(s_frage,'frage') )

        comment = s_frage.frage;
    elseif( isfield(s_frage,'comment') )
            
        comment = s_frage.comment;    
    else
        
        comment = 'Ja oder Nein ?';
    end
    if( ~isfield(s_frage,'default') )
        default = 1;
    else
        default = s_frage.default;
    end
    if( ~isfield(s_frage,'def_value') )
        default = 1;
    else
        if( ischar(s_frage.def_value) )
           if( s_frage.def_value(1) == 'j' || s_frage.def_value(1) == 'J' || s_frage.def_value(1) == 'y' || s_frage.def_value(1) == 'Y' )
                def_value = 'j';
           else
                def_value = 'n';
           end
        else
            if( s_frage.def_value )
                def_value = 'j';
            else
                def_value = 'n';
            end
        end
    end
    
    if( ~isfield(s_frage,'exact_answer') )
        exact_answer = 0;
    else
        if( s_frage.exact_answer ~= 0 )
            exact_answer = 1;
        else
            exact_answer = 0;
        end
    end
        
else
     prot_flag = 0;
     remote_flag = 0;
     comment   = 'Ja oder Nein ?';
     default_flag = 1;
     exact_answer = 0;
end

% def_value
if( nargin <= 1 )
    prot_flag = 0;
else
    if( ~isstruct(s_prot) )
        prot_flag = 0;
    else
        debug_fid = s_prot.debug_fid; 
    end
end
if( nargin <= 2 )
    remote_flag = 0;
else
    if( ~isstruct(s_remote) )
        remote_flag = 0;
    elseif( ~s_remote.run_flag )
        remote_flag = 0;
    end
end

if( remote_flag )
    [ok_flag,s_remote,line,remote_command,c_value,c_type] = o_remote_f(s_remote);
    if( ok_flag == 0 || ok_flag == 2 || ~strcmp(c_type{1},'char') )
        remote_flag = 0;
    else
        if( strcmp(remote_command,command)  )
                choice = char(c_value{1});
        else
            a=sprintf('\no_abfragen_jn_f:Der remote_command <%s> aus Zeile %i in Datei <%s> \n',remote_command,line,s_remote.file);
            o_ausgabe_f(a,debug_fid);
            a=sprintf('ist falsch\n');
            o_ausgabe_f(a,debug_fid);
            remote_flag = 0;
        end
    end
end

ask_flag = 1;
while( ask_flag )
  if( ~remote_flag )
    if( default )
      if( def_value == 'j' )
        textd = 'Ja';
      else
        textd = 'Nein';
      end
      choice = questdlg(comment, ...
                       'Ja-Nein-Abfrage', ...
                       'Ja','Nein',textd);
    else
      choice = questdlg(comment, ...
                       'Ja-Nein-Abfrage', ...
                       'Ja','Nein');
    end
    % Handle response
    switch choice
      case 'Ja'
        flag = 1;
        ask_flag = 0;
    case 'Nein'
        flag = 0;
        ask_flag = 0;
    end
  end

end
if( prot_flag )
    s_prot.command = command;
    if( flag )
        s_prot.val     = 'j';
    else
        s_prot.val     = 'n';
    end
    s_prot = o_protokoll_f(3,s_prot);
end
    