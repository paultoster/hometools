function sout = struct_sortiere_nach(sin,field,ascend_flag)
%
% sout = struct_sortiere_nach(sin,field,ascend_flag)
% sin            Strucktur mit Werten sin(i) i=1:n
% field          Feld (string) nach diesem Wert sortiert
% ascend_flag    aufsteigend (default = 1)
%
if( ~exist('ascend_flag','var') )
    ascend_flag = 1;
end

if( ~isfield(sin,field) )
    error('struct_sortiere_nach_error: Feld:%s ist nicht in Struktur enthalten',field);
end
    
if( ~isnumeric(sin(1).(field)) )
    error('struct_sortiere_nach_error: Feld:%s ist nicht numerisch (class: %s)',class(sin(1).(field)));
end
    
n = length(sin);

vec = [];
for i=1:n
    
    vec = [vec;sin(i).(field)];
end

if( ascend_flag )
    [y,i_liste] = sort(vec,1,'ascend');
else
    [y,i_liste] = sort(vec,1,'descend');
end
   
for i = 1:length(i_liste)
    
    sout(i) = sin(i_liste(i));
end
    
    
    