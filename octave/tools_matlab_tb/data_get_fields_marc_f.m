function  [okay,s_data_duh] = data_get_fields_marc_f(s_data)

okay = 1;
s_data_duh = [];

if( ~data_is_marc_aft_format_f(s_data) )
    okay = 0;
    return
end

cnames = fieldnames(s_data);
% Name wird unten verwendet
name   = cnames{1};

s_data = s_data.(name);

% Signalauswertung
nsig = length(s_data.Signal);
% Signallänge auf Länge abchecken
llist = [];
nllist = 0;
for isig = 1:nsig
    
    ll = length(s_data.Signal(isig).Values);
    index = find_val_in_vec(llist,ll);
    
    if( index == 0 )
        nllist = nllist + 1;
        llist  = [llist;ll];
        index  = nllist;
    end
    
    % Vektor
    s_data_duh(index).d.(s_data.Signal(isig).Name) = s_data.Signal(isig).Values;
    
    [n,m] = size(s_data_duh(index).d.(s_data.Signal(isig).Name));
    
    if( n < m ) 
        s_data_duh(index).d.(s_data.Signal(isig).Name) = s_data_duh(index).d.(s_data.Signal(isig).Name)';
    end
    
    % Einheit
    s_data_duh(index).u.(s_data.Signal(isig).Name) = s_data.Signal(isig).PhysUnit;
end

h{1} = [datestr(now),' read-marc-data'];

c_names = fieldnames(s_data.GlobalInfo);

for i=1:length(c_names)

    if( ischar(s_data.GlobalInfo.(c_names{i})) )
        h{length(h)+1} = [c_names{i},':',s_data.GlobalInfo.(c_names{i})];
    end
end

% Kommentar einfügen

for i=1:length(s_data.GlobalInfo.Info)
    
    if( strcmp(s_data.GlobalInfo.Info(i).Title,'Kommentar') )
        
        h{length(h)+1} = ['Kommentar',':',s_data.GlobalInfo.Info(i).Content];
    end
end

for i = 1:length(s_data_duh)
    
    s_data_duh(i).h    = h;
    s_data_duh(i).name = name;
    
end
